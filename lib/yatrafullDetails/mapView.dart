// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapViewScreen extends StatefulWidget {
//   @override
//   _MapViewScreenState createState() => _MapViewScreenState();
// }

// class _MapViewScreenState extends State<MapViewScreen> {
//   late GoogleMapController _mapController;
//   final Set<Marker> _markers = {};
//   bool _isLoading = true;

//   Future<void> _fetchNavigationPlaces() async {
//     try {
//       // Fetching data from Firestore collection 'arrival'
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('yatras').get();

//       if (snapshot.docs.isNotEmpty) {
//         for (var doc in snapshot.docs) {
//           var navigationPlaces = doc['navigationPlaces'];
//           for (var place in navigationPlaces) {
//             final marker = Marker(
//               markerId: MarkerId(place['placeName']),
//               position: LatLng(
//                 double.parse(place['latitude']),
//                 double.parse(place['longitude']),
//               ),
//               infoWindow: InfoWindow(title: place['placeName']),
//             );
//             _markers.add(marker);
//           }
//         }
//       }
//     } catch (e) {
//       print('Error fetching navigation places: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchNavigationPlaces();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map View'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: _markers.isNotEmpty
//                     ? _markers.first.position
//                     : LatLng(0.0, 0.0), // Default position
//                 zoom: 10,
//               ),
//               markers: _markers,
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapViewScreen extends StatefulWidget {
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final List<LatLng> _polylineCoordinates = [];
  final Location _location = Location();
  late LatLng _currentLocation;
  bool _isLoading = true;

  Future<void> _fetchNavigationPlaces() async {
    try {
      // Fetching data from Firestore collection 'yatras'
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('yatras').get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          var navigationPlaces = doc['navigationPlaces'];
          for (var place in navigationPlaces) {
            final marker = Marker(
              markerId: MarkerId(place['placeName']),
              position: LatLng(
                double.parse(place['latitude']),
                double.parse(place['longitude']),
              ),
              infoWindow: InfoWindow(title: place['placeName']),
            );
            _markers.add(marker);
          }
        }
      }
    } catch (e) {
      print('Error fetching navigation places: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      var locationData = await _location.getLocation();
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('Current Location'),
            position: _currentLocation,
            infoWindow: InfoWindow(title: 'You are here'),
          ),
        );
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _drawRoute(LatLng destination) async {
    try {
      PolylinePoints polylinePoints = PolylinePoints(apiKey: '');

      // Create a request object for the route
      PolylineRequest request = PolylineRequest(
        origin:
            PointLatLng(_currentLocation.latitude, _currentLocation.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving, // Set mode to driving, walking, or bicycling
      );

      // Fetch the route using PolylinePoints
      PolylineResult result =
          await polylinePoints.getRouteBetweenCoordinates(request: request);

      if (result.points.isNotEmpty) {
        _polylineCoordinates.clear();
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        setState(() {});
      } else {
        print('No route found');
      }
    } catch (e) {
      print('Error drawing route: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNavigationPlaces();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14,
              ),
              markers: _markers,
              polylines: {
                Polyline(
                  polylineId: PolylineId('Route'),
                  color: Colors.blue,
                  width: 5,
                  points: _polylineCoordinates,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_markers.isNotEmpty) {
            _drawRoute(_markers.first.position);
          }
        },
        child: Icon(Icons.directions),
      ),
    );
  }
}
