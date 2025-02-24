import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool showSuggestions = false;
  double? distanceInKm;
  final String googleApiKey = "AIzaSyB0sppwm5PsZzrfHd0n2Pv4nSAz188b_Ls";

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    searchController.addListener(() => searchController.text.isNotEmpty
        ? fetchSearchSuggestions()
        : hideSuggestions());
  }

  Future<void> requestLocationPermission() async {
    if (await Permission.location.request().isGranted) getUserLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    userLocation = LatLng(position.latitude, position.longitude);
    updateMarkers("userLocation", userLocation!, "Your Location",
        BitmapDescriptor.hueAzure);
  }

      setState(() {
        searchResults = jsonDecode(response.body)['predictions'];
        showSuggestions = searchResults.isNotEmpty;
      });
    }
  }

  Future<void> fetchPlaceDetails(String placeId, String placeName) async {
    final response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey"));
    if (response.statusCode == 200) {
      final location =
          jsonDecode(response.body)['result']['geometry']['location'];
      selectedDestination = LatLng(location['lat'], location['lng']);
      updateMarkers("destination_$placeId", selectedDestination!, placeName,
          BitmapDescriptor.hueGreen);
      drawRoute();
    }
  }

  void updateMarkers(String id, LatLng position, String title, double hue) {
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      ));
    });
  }

  void drawRoute() {
    if (userLocation == null || selectedDestination == null) return;
    setState(() {
      polylines.clear();
      polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        points: [userLocation!, selectedDestination!],
        color: Colors.blue,
        width: 4,
      ));
      distanceInKm = Geolocator.distanceBetween(
              userLocation!.latitude,
              userLocation!.longitude,
              selectedDestination!.latitude,
              selectedDestination!.longitude) /
          1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: searchController,
          onTap: () => setState(() => showSuggestions = true),
          decoration: InputDecoration(
            hintText: "Search location...",
            border: InputBorder.none,
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      hideSuggestions();
                      searchResults.clear();
                      setState(() => distanceInKm = null);
                    },
                  )
                : const Icon(Icons.search),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: userLocation ?? const LatLng(29.3952, 71.6726),
                zoom: 13),
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          ),
          if (showSuggestions)
            Positioned(
              top: 80,
              left: 15,
              right: 15,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchResults[index]['description']),
                      onTap: () {
                        fetchPlaceDetails(searchResults[index]['place_id'],
                            searchResults[index]['description']);
                        hideSuggestions();
                      },
                    );
                  },
                ),
              ),
            ),
          if (distanceInKm != null)
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38, blurRadius: 5, spreadRadius: 2)
                  ],
                ),
                child: Text(
                  "Distance: ${distanceInKm!.toStringAsFixed(2)} km",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}