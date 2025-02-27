import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'google_map_search.dart'; // Import the SearchScreen

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

  static const CameraPosition _defaultCameraPosition = CameraPosition(
    target: LatLng(29.98749382842702, 69.3261929163755),
    zoom: 8,
  );

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
        }
      });

      // Move camera to current location
      final controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation!, zoom: 14),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching current location: $e')),
      );
    }
  }

  Future<LatLng> fetchCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
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
    // Use a geocoding package (e.g., geocoding) to fetch the address
    // Example:
    // final placemarks = await placemarkFromCoordinates(
    //   location.latitude,
    //   location.longitude,
    // );
    // return placemarks.first.toString();
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
    });
  }

  void _onLocationSelected() {
    if (selectedLocation != null && selectedAddress != null) {
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
      Navigator.pop(context, {
        'latitude': searchedLocation!.latitude,
        'longitude': searchedLocation!.longitude,
        'address': address,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search for a location first')),
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
          width: 5,
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
                    // Draw polyline from current location to searched location
                    _drawPolyline(currentLocation!, searchedLocation!);
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
            if (!widget.isViewer)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  children: [
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
