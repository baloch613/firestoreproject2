import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final Uuid uuid = const Uuid();
  List<dynamic> listForPlaces = [];
  String tokenForSession = "";

  @override
  void initState() {
    super.initState();
    tokenForSession = uuid.v4(); // Generate a unique session token
    searchController.addListener(onModify);
  }

  void makeSuggestions(String input) async {
    if (input.isEmpty) return; // Prevent unnecessary API calls

    String googlePlacesApiKey = 'AIzaSyB0sppwm5PsZzrfHd0n2Pv4nSAz188b_Ls';
    String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    try {
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        List<dynamic> predictions = jsonDecode(response.body)["predictions"];
        if (mounted) {
          setState(() {
            listForPlaces = predictions;
          });
        }
      } else {
        throw Exception("Failed to load data, try again.");
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  void onModify() {
    if (!mounted) return; // Prevents crashes if widget is disposed
    makeSuggestions(searchController.text);
  }

  @override
  void dispose() {
    searchController.removeListener(onModify); // Prevents memory leaks
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Search any place",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listForPlaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(
                        listForPlaces[index]["description"],
                      );
                      if (locations.isNotEmpty) {
                        final double latitude = locations.first.latitude;
                        final double longitude = locations.first.longitude;
                        Get.back(result: LatLng(latitude, longitude));
                        searchController.clear();
                      }
                    },
                    title: Text(listForPlaces[index]["description"]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
