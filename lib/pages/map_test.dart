import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/directions_repository.dart';
import '../models/directions_model.dart';

class MapTest extends StatefulWidget {
  const MapTest({super.key});

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentSnapshot _document;

  final Completer<GoogleMapController> _controller = Completer();
  // late final GoogleMapController controller;
  
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  CameraPosition center = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  LatLng lastStop = const LatLng(0.0, 0.0);
  // late Directions directions;
  // CameraPosition cameraPosition = const CameraPosition(
  //   target: LatLng(0.0, 0.0),
  //   zoom: 14,
  // );
  // Directions _info = Directions(
  //   bounds: LatLngBounds(
  //     northeast: const LatLng(0.0, 0.0),
  //     southwest: const LatLng(0.0, 0.0),
  //   ),
  //   polylinePoints: [],
  //   totalDistance: '0',
  //   totalDuration: '0'
  // );

  // componentDidMount() async {
  //   BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(),
  //     "assets/images/bus.png",
  //   );
  //   controller = await _controller.future;
  //   directions = await DirectionsRepository()
  //       .getDirections(origin: cameraPosition.target, destination: center.target);
  // }

  Future<BitmapDescriptor> getBitmap() {
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/bus.png",
    );
  }
  Future<GoogleMapController> getController(mapController) {
    return mapController.future;
  }

  getDirections(cameraPosition) {
    return DirectionsRepository()
      .getDirections(origin: cameraPosition.target, destination: lastStop);
  }

  Directions _info = Directions(
    bounds: LatLngBounds(
      northeast: const LatLng(0.0, 0.0),
      southwest: const LatLng(0.0, 0.0),
    ),
    polylinePoints: [],
    totalDistance: '0',
    totalDuration: '0'
  );

  funcao() async {

    // BitmapDescriptor markerbitmap = await getBitmap();

             // specified current users location
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(center.target.latitude, center.target.longitude),
      zoom: 14,
    );
    
    final directions = await getDirections(cameraPosition);
    _info = directions;

    final GoogleMapController controller = await getController(_controller);
    controller.animateCamera(CameraUpdate.newLatLngBounds(directions.bounds, 100.0));
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados em tempo real')
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("route")
          .where('id', isGreaterThanOrEqualTo: '5JgEJ9KgXrDdUYUAPLO2')
          .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          if(snapshot.hasData) {
            _document = (snapshot.data?.docs[0] as DocumentSnapshot<Object?>);

            center = CameraPosition(
              target: LatLng(
                _document['current_position'].latitude,
                _document['current_position'].longitude
              ),
              zoom: 14.4746,
            );

            var stops = _document['bus_stops'];
            lastStop = LatLng(
              stops[stops.length - 1]['coordinates'].latitude,
              stops[stops.length - 1]['coordinates'].longitude
            );

            funcao();

            final List<Marker> markers = stops.map<Marker>((stop) {
              return Marker(
                  markerId: MarkerId(stop['name']),
                  position: LatLng(stop['coordinates'].latitude, stop['coordinates'].longitude),
                  infoWindow: InfoWindow(
                    title: "parada: ${stop['name']}",
                  )
              );
            }).toList();

            return GoogleMap(
              myLocationEnabled: false,
              compassEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: center,
              markers: Set<Marker>.of(markers),
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
            );

            // return Text(_document['current_position'].latitude.toString());
          }
          return const Text('Erro ao carregar o mapa');
        }
      )
    );
  }
}