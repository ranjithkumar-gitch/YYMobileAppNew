import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapScreen extends StatelessWidget {
  const GoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) { 
      
     final List<LatLng> waypoints = [
      const LatLng(17.3850, 78.4867),
      const LatLng(17.3276, 78.6047),
      const LatLng(17.3642, 79.6797), 
      const LatLng(17.0888, 79.6149), 
      const LatLng(17.0568, 79.2685), 
    ];


    final Polyline polyline = Polyline(
      polylineId: const PolylineId('waypoints'),
      color: Colors.blue,
      points: waypoints,
      width: 5
    );

    return Scaffold(
      
      body: Container(
        height: 250, width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect( borderRadius: BorderRadius.circular(15),
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(17.3850, 78.4867),
              zoom: 10,
            ),
            onTap: (_) {
              _launchGoogleMap();
            },
            markers: {
             const  Marker(
                markerId: MarkerId('Hyderabad'),
                position: LatLng(17.3850, 78.4867),
                infoWindow: InfoWindow(title: 'Hyderabad'),
              ),
              const Marker(
                markerId: MarkerId('Hayathnagar'),
                position: LatLng(17.3276, 78.6047),
                infoWindow: InfoWindow(title: 'Hayathnagar'),
              ),
             const Marker(
                markerId: MarkerId('Choutuppal'),
                position: LatLng(17.3642, 79.6797),
                infoWindow: InfoWindow(title: 'Choutuppal'),
              ),
             const Marker(
                markerId: MarkerId('Chityala'),
                position: LatLng(17.0888, 79.6149),
                infoWindow: InfoWindow(title: 'Chityala'),
              ),
            const  Marker(
                markerId: MarkerId('Nalgonda'),
                position: LatLng(17.0568, 79.2685),
                infoWindow: InfoWindow(title: 'Nalgonda'),
              ),
            },
             polylines: {polyline, 
            
             },  
          ),
        ),
      ),
    );
  }

  _launchGoogleMap() async {
  
 const hyderabadCoordinates = "17.346963818901653, 78.55060023176189";
  const filmcityCoordintaes = "17.311621895586608, 78.68248350544282";
  const choutuppalCoordinates = "17.25437900517632, 78.89564602552935";
  const chityalaCoordinates = "17.2321768099796, 79.12663453073752";
  const nalgondaCoordinates = "17.057625015167677, 79.2689302656816";

    const  googleMapUrl =
    'https://www.google.com/maps/dir/?api=1&origin=$hyderabadCoordinates&destination=$nalgondaCoordinates&waypoints=$filmcityCoordintaes|$choutuppalCoordinates|$chityalaCoordinates';
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}











