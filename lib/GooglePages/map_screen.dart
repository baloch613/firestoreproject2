import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_map_search.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation; // Initial location to center the map
  final bool isViewer; // Whether the screen is in viewer mode (no selection)
  const MapScreen({super.key, this.initialLocation, this.isViewer = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> myMarker = {};
  final Set<Polyline> myPolyline = {};
  final Completer<GoogleMapController> mapController = Completer();
  LatLng? selectedLocation;
  String? selectedAddress;
  LatLng? currentLocation;
  LatLng? searchedLocation;

  double distanceInKm = 0.0;

  static const CameraPosition _defaultCameraPosition = CameraPosition(
    target: LatLng(29.98749382842702, 69.3261929163755),
    zoom: 8,
  );

  StreamSubscription<Position>? _locationStreamSubscription;

  @override
  void dispose() {
    _locationStreamSubscription
        ?.cancel(); // Cancel the stream subscription when the widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      selectedLocation = widget.initialLocation;
      myMarker.add(
        Marker(
          markerId: const MarkerId("SelectedLocation"),
          position: widget.initialLocation!,
          infoWindow: const InfoWindow(title: "Selected Location"),
        ),
      );
    }
    _fetchCurrentLocation(); // Fetch and display current location
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      // Fetch initial location
      currentLocation = await fetchCurrentLocation();
      setState(() {
        // Add marker for current location
        myMarker.add(
          Marker(
            markerId: const MarkerId("CurrentLocation"),
            position: currentLocation!,
            infoWindow: const InfoWindow(title: "My Location"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );

        // If in viewer mode and initial location is provided, draw polyline
        if (widget.isViewer && selectedLocation != null) {
          _drawPolyline(currentLocation!, selectedLocation!);
          _calculateDistance(currentLocation!, selectedLocation!);
        }
      });

      // Move camera to current location
      final controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation!, zoom: 14),
      ));

      // Start listening for location updates
      _locationStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        distanceFilter: 10,
        accuracy: LocationAccuracy.high,
      )).listen((Position position) {
        final newLocation = LatLng(position.latitude, position.longitude);
        setState(() {
          currentLocation = newLocation;
          myMarker.removeWhere(
              (marker) => marker.markerId.value == "CurrentLocation");
          myMarker.add(
            Marker(
              markerId: const MarkerId("CurrentLocation"),
              position: newLocation,
              infoWindow: const InfoWindow(title: "My Location"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          );

          // Update polyline if in viewer mode
          if (widget.isViewer && selectedLocation != null) {
            _drawPolyline(newLocation, selectedLocation!);
            _calculateDistance(newLocation, selectedLocation!);
          }
        });

        // Optionally, move the camera to follow the user's location
        controller.animateCamera(CameraUpdate.newLatLng(newLocation));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching current location: $e')),
      );
    }
  }

  Future<LatLng> fetchCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location disabled. please enable location');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Future<String> _getAddressFromLatLng(LatLng location) async {
    return "Sample Address"; // Replace with actual address
  }

  void _onMapTap(LatLng location) async {
    if (widget.isViewer) return; // Do nothing if in viewer mode

    final address = await _getAddressFromLatLng(location);
    setState(() {
      selectedLocation = location;
      selectedAddress = address;
      myMarker.clear();
      // Add marker for current location
      if (currentLocation != null) {
        myMarker.add(
          Marker(
            markerId: const MarkerId("CurrentLocation"),
            position: currentLocation!,
            infoWindow: const InfoWindow(title: "My Location"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }
      // Add marker for selected location
      myMarker.add(
        Marker(
          markerId: const MarkerId("SelectedLocation"),
          position: location,
          infoWindow: InfoWindow(title: address),
        ),
      );
      _drawPolyline(currentLocation!, location);

      // Calculate distance between current location and selected location
      _calculateDistance(currentLocation!, location);
    });
  }

  // New: Calculate distance between two LatLng points
  void _calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    setState(() {
      distanceInKm = distanceInMeters / 1000; // Convert to kilometers
    });
  }

  void _onLocationSelected() {
    if (selectedLocation != null &&
        selectedAddress != null &&
        myPolyline.isNotEmpty) {
      Navigator.pop(context, {
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
        'address': selectedAddress!,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
    }
  }

  void _onSendCurrentLocation() async {
    try {
      final currentLocation = await fetchCurrentLocation();
      final address = await _getAddressFromLatLng(currentLocation);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'address': address,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching current location: $e')),
      );
    }
  }

  void _onSendSearchedLocation() async {
    if (searchedLocation != null) {
      final address = await _getAddressFromLatLng(searchedLocation!);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, {
        'latitude': searchedLocation!.latitude,
        'longitude': searchedLocation!.longitude,
        'address': address,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search a location first')),
      );
    }
  }

  void _drawPolyline(LatLng start, LatLng end) {
    setState(() {
      myPolyline.clear();
      myPolyline.add(
        Polyline(
          polylineId: const PolylineId("route1"),
          points: [start, end],
          color: Colors.blue,
          width: 3,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          if (!widget.isViewer)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await Get.to(() => const SearchScreen());
                if (result != null) {
                  setState(() {
                    searchedLocation = result;
                    // Add marker for searched location
                    myMarker.add(
                      Marker(
                        markerId: const MarkerId("SearchedLocation"),
                        position: searchedLocation!,
                        infoWindow:
                            const InfoWindow(title: "Searched Location"),
                      ),
                    );

                    // Calculate distance between current location and searched location
                    if (currentLocation != null) {
                      _calculateDistance(currentLocation!, searchedLocation!);
                    }
                  });

                  // Move camera to searched location
                  final controller = await mapController.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: searchedLocation!, zoom: 14),
                  ));
                }
              },
            ),
          if (!widget.isViewer)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _onLocationSelected,
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: widget.initialLocation != null
                  ? CameraPosition(
                      target: widget.initialLocation!,
                      zoom: 14,
                    )
                  : _defaultCameraPosition,
              markers: myMarker,
              polylines: myPolyline,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
              onTap: _onMapTap,
              mapType: MapType.normal,
            ),
            // New: Display distance in both modes
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  if (selectedLocation != null || searchedLocation != null)
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "destination: ${distanceInKm.toStringAsFixed(2)} km",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  if (!widget.isViewer) ...[
                    const SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _onSendCurrentLocation,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Send Current Location",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _onSendSearchedLocation,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Send Searched Location",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !widget.isViewer
          ? FloatingActionButton(
              heroTag: "btn1",
              child: const Icon(Icons.my_location),
              onPressed: () async {
                try {
                  myPolyline.clear();
                  final location = await fetchCurrentLocation();
                  final controller = await mapController.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: location, zoom: 14),
                  ));
                  setState(() {
                    currentLocation = location;
                    myMarker.clear();
                    // Add marker for current location
                    myMarker.add(
                      Marker(
                        markerId: const MarkerId("CurrentLocation"),
                        position: currentLocation!,
                        infoWindow: const InfoWindow(title: "My Location"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                      ),
                    );
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            )
          : null,
    );
  }
}
