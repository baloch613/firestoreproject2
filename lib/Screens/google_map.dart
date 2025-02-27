import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> myMarker = [];
  final List<Marker> markerList = const [
    Marker(
        markerId: MarkerId("marker1"),
        position: LatLng(29.613362430325918, 72.09039777444661),
        infoWindow: InfoWindow(title: "Qadir Pur")),
    Marker(
        markerId: MarkerId("marker2"),
        position: LatLng(29.5404435090352, 71.63304485120821),
        infoWindow: InfoWindow(title: "Lodhran City")),
    Marker(
        markerId: MarkerId("marker3"),
        position: LatLng(28.94443069144502, 70.93294001009535),
        infoWindow: InfoWindow(title: "Liaqat Pur City")),
    Marker(
        markerId: MarkerId("marker4"),
        position: LatLng(29.395616363355213, 71.69013521106233),
        infoWindow: InfoWindow(title: "Univercity Chowk")),
  ];
  final Completer<GoogleMapController> mapController = Completer();
  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(29.38409460827959, 71.68180015031703),
    zoom: 10,
  );
  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  showMyLocationOnMap() {
    getUserLocation().then((value) async {
      print("My Location: ${value.latitude}${value.longitude}");
      myMarker.add(Marker(
          markerId: const MarkerId("Marker5"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: "My Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 14),
      ));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _cameraPosition,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            mapController.complete(controller);
          },
          mapType: MapType.normal,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () async {
          GoogleMapController controller = await mapController.future;

          controller.animateCamera(
              CameraUpdate.newCameraPosition(const CameraPosition(
            target: LatLng(29.395616363355213, 71.69013521106233),
            zoom: 13,
          )));
        },
      ),
    );
  }
}
