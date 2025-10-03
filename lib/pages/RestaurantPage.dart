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
  List places = [];

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

  Future<void> _fetchNearbyRestaurantsWithNewApi() async {
    if (currentLocation == null) return;

    final url = Uri.parse("https://places.googleapis.com/v1/places:searchText");

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
      "languageCode": "pt-BR",
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
          "places.id,places.displayName,places.formattedAddress,places.location,places.rating,places.photos",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          places = data["places"] ?? [];
        });
      } else {
        print("Error fetching places (New API): ${response.statusCode}");
        print("Error body: ${response.body}");
        setState(() {
          places = [];
        });
      }
    } catch (e) {
      print("Exception fetching places (New API): $e");
      setState(() {
        places = [];
      });
    }
  }

  String buildPhotoUrl(String photoName) {
    return 'https://places.googleapis.com/v1/$photoName/media?key=$apiKey&maxHeightPx=400';
  }

  void _showRestaurantPopup(BuildContext context, Map<String, dynamic> place) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(place['displayName']?['text'] ?? 'Restaurante'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Endereço: ${place['formattedAddress'] ?? 'Não disponível'}'),
                  const SizedBox(height: 8),
                  Text('Avaliação: ${place['rating'] ?? 'Sem avaliação'}'),
                ],
              ),
          ),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
        );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurantes próximos"),
        centerTitle: true,
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            flex: 2, // Map takes 2/3 of the screen
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 14,
              ),
              markers: places.map((place) {
                final location = place["location"];
                if (location == null ||
                    location["latitude"] == null ||
                    location["longitude"] == null) {
                  return const Marker(markerId: MarkerId("invalid"));
                }
                return Marker(
                  markerId: MarkerId(place["id"]),
                  position: LatLng(location["latitude"], location["longitude"]),
                  infoWindow: InfoWindow(
                    title: place["displayName"]?["text"] ?? "Restaurante",
                    snippet: place["formattedAddress"],
                  ),
                );
              }).where((marker) => marker.markerId.value != "invalid").toSet(),
            ),
          ),
          Expanded(
            flex: 1,
            child: places.isEmpty
              ? const Center(child: Text("Nenhum restaurante encontrado"))
              : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];

                String? photoUrl;
                if (place['photos'] != null && place['photos'].isNotEmpty){
                  photoUrl = buildPhotoUrl(place['photos'][0]['name']);
                }

                return RestaurantCard(
                  name: place['displayName']?['text'] ?? 'Nome indisponível',
                  rating: (place['rating'] as num?)?.toDouble() ?? 0.0,
                  address: place['formattedAddress'] ?? 'Endereço indisponível',
                  imageUrl: photoUrl,
                  onTap: () => _showRestaurantPopup(context, place),
                );
              }
            )
          )
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.name,
    required this.rating,
    required this.address,
    this.imageUrl,
    required this.onTap,
  });

  final String name;
  final double rating;
  final String address;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 4.0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Restaurant Image
            SizedBox(
              height: 150,
              child: (imageUrl != null)
                  ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null ? child : const Center(
                      child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  print("Error loading image: $error");
                  return const Center(
                    child: Icon(
                        Icons.restaurant_menu, size: 50, color: Colors.grey),
                  );
                },
              )
                  : const Center(
                child: Icon(
                    Icons.restaurant_menu, size: 50, color: Colors.grey),
              ),
            ),
            // Restaurant Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          address,
                          style: TextStyle(fontSize: 14.0, color: Colors
                              .grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4.0),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
