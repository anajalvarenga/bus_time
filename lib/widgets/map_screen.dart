import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/directions_repository.dart';
import '../models/directions_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static const CameraPosition _center = CameraPosition(
      target: LatLng(-22.422971, -45.460251),
    zoom: 14.4746,
  );
  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(-22.422971, -45.460251),
        infoWindow: InfoWindow(
          title: 'Posição atual',
        )
    ),
  ];

  Directions _info = Directions(
    bounds: LatLngBounds(
      northeast: const LatLng(0.0, 0.0),
      southwest: const LatLng(0.0, 0.0),
    ),
    polylinePoints: [],
    totalDistance: '0',
    totalDuration: '0'
  );

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  getCurrentPosition() async{
    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() +" "+value.longitude.toString());

      // marker added for current users location
      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          "assets/images/bus.png",
      );

      _markers.add(
          Marker(
            markerId: const MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(
              title: 'My Current Location',
            ),
            icon: markerbitmap,
          )
      );
      print(_markers);

      // specified current users location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final directions = await DirectionsRepository()
        .getDirections(origin: cameraPosition.target, destination: _center.target);
      setState(() {
        _info = directions;
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(_info.bounds, 100.0));
      setState(() {
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Time'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SafeArea(
            child: GoogleMap(
              myLocationEnabled: false,
              compassEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _center,
              markers: Set<Marker>.of(_markers),
              polylines: {
                if(_info.polylinePoints.isNotEmpty)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.yellow,
                    width: 5,
                    points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                  )
              },
            ),
          ),
          if(_info.bounds != LatLngBounds(
            northeast: const LatLng(0.0, 0.0),
            southwest: const LatLng(0.0, 0.0),
          ))
            Positioned(
              top:20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0
                    )
                  ]
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        onPressed: getCurrentPosition,
        child: const Icon(Icons.local_activity),
      ),
    );
  }
}