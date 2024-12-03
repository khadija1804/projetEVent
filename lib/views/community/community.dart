import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(36.8065, 10.1815), // Tunis, Tunisia
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1Ijoia2hhZGlqYTEyMzk5IiwiYSI6ImNtNDhya2Y0bTAybW0ya3NkNmd3YXd5NTYifQ.Xt-3ZUh6sCp3iRVG-LacXA',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1Ijoia2hhZGlqYTEyMzk5IiwiYSI6ImNtNDhya2Y0bTAybW0ya3NkNmd3YXd5NTYifQ.Xt-3ZUh6sCp3iRVG-LacXA',
                  'id': 'mapbox.streets',
                },
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),

          // Search bar overlaid on top of the map
          Positioned(
            top: 20, // Adjust for your desired margin from the top
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/search.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  hintText: 'Search location or tags',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
