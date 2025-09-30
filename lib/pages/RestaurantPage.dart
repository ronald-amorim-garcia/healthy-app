import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  List places = []; // This will now store places from the new API format

  // IMPORTANT: Ensure this API key is enabled for the "Places API" (the newer one)
  // in your Google Cloud Console.
  final String apiKey = "YOUR-API-KEY"; // replace with your key

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    // Example: São Paulo coordinates (replace with GPS later)
    setState(() {
      currentLocation = const LatLng(-23.5505, -46.6333);
    });
    if (currentLocation != null) {
      _fetchNearbyRestaurantsWithNewApi();
    }
  }

  // --- NEW METHOD using the new Places API ---
  Future<void> _fetchNearbyRestaurantsWithNewApi() async {
    if (currentLocation == null) return;

    final url = Uri.parse("https://places.googleapis.com/v1/places:searchText");

    // Define the request body
    // We'll search for "restaurant" and bias the search to the current location.
    final Map<String, dynamic> requestBody = {
      "textQuery": "restaurant",
      "locationBias": {
        "circle": {
          "center": {
            "latitude": currentLocation!.latitude,
            "longitude": currentLocation!.longitude,
          },
          "radius": 1500.0, // Radius in meters
        }
      },
      "languageCode": "pt-BR", // Optional: set language for results
      // "maxResultCount": 10, // Optional: limit number of results
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": apiKey,
          // Specify the fields you want. This is CRUCIAL.
          // Adjust based on what you need for your markers and list.
          "X-Goog-FieldMask":
          "places.id,places.displayName,places.formattedAddress,places.location,places.primaryTypeDisplayName",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("New API Response: $data"); // For debugging

        setState(() {
          // The new API returns a list under the "places" key
          places = data["places"] ?? [];
        });
      } else {
        // Handle error
        print("Error fetching places (New API): ${response.statusCode}");
        print("Error body: ${response.body}");
        setState(() {
          places = []; // Clear places on error
        });
      }
    } catch (e) {
      print("Exception fetching places (New API): $e");
      setState(() {
        places = []; // Clear places on exception
      });
    }
  }

  // --- OLD METHOD (kept for reference, but not used if _setInitialLocation calls the new one) ---
  // Future<void> _fetchNearbyRestaurants() async {
  //   if (currentLocation == null) return;
  //   final url =
  //       "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
  //       "?location=${currentLocation!.latitude},${currentLocation!.longitude}"
  //       "&radius=1500&type=restaurant&key=$apiKey";
  //   final response = await http.get(Uri.parse(url));
  //   final data = json.decode(response.body);
  //   setState(() {
  //     places = data["results"];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurantes próximos (Nova API)"),
        centerTitle: true,
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 14,
              ),
              markers: {
                ...places.map((place) {
                  // Adapt to the new API response structure
                  // "geometry"."location"."lat" -> "geometry"."location"."latitude"
                  // "place_id" -> "id"
                  // "name" -> "displayName"."text" (if you request displayName as an object)
                  // "vicinity" -> "formattedAddress"

                  final location = place["location"];
                  if (location == null || location["latitude"] == null || location["longitude"] == null) {
                    return const Marker(markerId: MarkerId("invalid_place_data")); // Skip if no location
                  }
                  final lat = location["latitude"];
                  final lng = location["longitude"];

                  String title = "Restaurante"; // Default title
                  if (place["displayName"] != null && place["displayName"]["text"] != null) {
                    title = place["displayName"]["text"];
                  }

                  String snippet = place["formattedAddress"] ?? "Endereço não disponível";


                  return Marker(
                    markerId: MarkerId(place["id"] ?? "unknown_id_${DateTime.now().millisecondsSinceEpoch}" ),
                    position: LatLng(lat, lng),
                    infoWindow: InfoWindow(
                      title: title,
                      snippet: snippet,
                    ),
                  );
                }).where((marker) => marker.markerId.value != "invalid_place_data").toSet(), // Filter out invalid markers
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                // Adapt to new API response structure
                String name = "Restaurante";
                if (place["displayName"] != null && place["displayName"]["text"] != null) {
                  name = place["displayName"]["text"];
                }
                String address = place["formattedAddress"] ?? "Sem endereço";

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: Text(name),
                    subtitle: Text(address),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
