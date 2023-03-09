import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  var textoTeste = '';
  var currentRoute;
  late DocumentSnapshot _document;
  
  Future getRoute() async {
    // await db.collection("route")
    //   .where("id", isEqualTo: '5JgEJ9KgXrDdUYUAPLO2')
    //   .get()
    //   .then(
    //     (res) => setState(() {
    //       currentRoute = res.docs[0].data();
    //       print("currentRoute $currentRoute");
    //       textoTeste = '${currentRoute['current_position'].latitude} ${currentRoute['current_position'].longitude}';
    //     }),
    //     onError: (e) => setState(() {
    //       textoTeste = "Error completing: $e";
    //     }),
    //   );

    // var snapshots = FirebaseFirestore.instance.collection("route")
    //   .where('id', isGreaterThanOrEqualTo: '5JgEJ9KgXrDdUYUAPLO2')
    //   .snapshots();
    // print(snapshots.value);
  }

  // bool cancelTimer = false;

  @override
  void initState() {
    super.initState();
    getRoute();

    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   getRoute();
    //   if(cancelTimer) {
    //     timer.cancel();
    //   }
    // });
  }

  // @override
  // @mustCallSuper
  // @protected
  // void dispose() {
  //   // TODO: implement dispose
  //   // WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);

  //   setState(() {
  //     cancelTimer = true;
  //   });
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: 500,
        width: 200,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("route")
            .where('id', isGreaterThanOrEqualTo: '5JgEJ9KgXrDdUYUAPLO2')
            .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            if(snapshot.hasData) {
              _document = (snapshot.data?.docs[0] as DocumentSnapshot<Object?>);
              return Text(_document['current_position'].latitude.toString());
              // return ListView.builder(
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: 1,
              //   itemBuilder: (context, index) {
              //     _document = (snapshot.data?.docs[0] as DocumentSnapshot<Object?>);
                  
              //     CameraPosition _center = CameraPosition(
              //       target: LatLng(
              //         _document['current_position'].latitude,
              //         _document['current_position'].longitude
              //       ),
              //       zoom: 14.4746,
              //     );
                  
              //     final List<Marker> _markers = <Marker>[
              //       const Marker(
              //           markerId: MarkerId('1'),
              //           position: LatLng(-22.422971, -45.460251),
              //           infoWindow: InfoWindow(
              //             title: 'Posição atual',
              //           )
              //       ),
              //     ];
                  
              //     return GoogleMap(
              //             myLocationEnabled: false,
              //             compassEnabled: false,
              //             onMapCreated: _onMapCreated,
              //             initialCameraPosition: _center,
              //             markers: Set<Marker>.of(_markers),
              //             // polylines: {
              //             //   if(_info.polylinePoints.isNotEmpty)
              //             //     Polyline(
              //             //       polylineId: const PolylineId('overview_polyline'),
              //             //       color: Colors.yellow,
              //             //       width: 5,
              //             //       points: _info.polylinePoints
              //             //         .map((e) => LatLng(e.latitude, e.longitude))
              //             //         .toList(),
              //             //     )
              //             // },
              //           );
              //     //     ),
              //     //     // if(_info.bounds != LatLngBounds(
              //     //     //   northeast: const LatLng(0.0, 0.0),
              //     //     //   southwest: const LatLng(0.0, 0.0),
              //     //     // ))
              //     //     //   Positioned(
              //     //     //     top:20,
              //     //     //     child: Container(
              //     //     //       padding: const EdgeInsets.symmetric(
              //     //     //         vertical: 6.0,
              //     //     //         horizontal: 12.0,
              //     //     //       ),
              //     //     //       decoration: BoxDecoration(
              //     //     //         color: Colors.yellowAccent,
              //     //     //         borderRadius: BorderRadius.circular(20.0),
              //     //     //         boxShadow: const [
              //     //     //           BoxShadow(
              //     //     //             color: Colors.black26,
              //     //     //             offset: Offset(0, 2),
              //     //     //             blurRadius: 6.0
              //     //     //           )
              //     //     //         ]
              //     //     //       ),
              //     //     //       child: Text(
              //     //     //         '${_info.totalDistance}, ${_info.totalDuration}',
              //     //     //         style: const TextStyle(
              //     //     //           fontSize: 18.0,
              //     //     //           fontWeight: FontWeight.w600,
              //     //     //         ),
              //     //     //       ),
              //     //     //     ),
              //     //     //   ),
              //     //   ],
              //     // );
              //   }
              // );
            }
            return SizedBox();
          }
        ),
      )
      // body: Text(textoTeste),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getRoute
      // ),
      // body: Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     SafeArea(
      //       child: GoogleMap(
      //         myLocationEnabled: false,
      //         compassEnabled: false,
      //         onMapCreated: _onMapCreated,
      //         initialCameraPosition: _center,
      //         markers: Set<Marker>.of(_markers),
      //         polylines: {
      //           if(_info.polylinePoints.isNotEmpty)
      //             Polyline(
      //               polylineId: const PolylineId('overview_polyline'),
      //               color: Colors.yellow,
      //               width: 5,
      //               points: _info.polylinePoints
      //                 .map((e) => LatLng(e.latitude, e.longitude))
      //                 .toList(),
      //             )
      //         },
      //       ),
      //     ),
      //     if(_info.bounds != LatLngBounds(
      //       northeast: const LatLng(0.0, 0.0),
      //       southwest: const LatLng(0.0, 0.0),
      //     ))
      //       Positioned(
      //         top:20,
      //         child: Container(
      //           padding: const EdgeInsets.symmetric(
      //             vertical: 6.0,
      //             horizontal: 12.0,
      //           ),
      //           decoration: BoxDecoration(
      //             color: Colors.yellowAccent,
      //             borderRadius: BorderRadius.circular(20.0),
      //             boxShadow: const [
      //               BoxShadow(
      //                 color: Colors.black26,
      //                 offset: Offset(0, 2),
      //                 blurRadius: 6.0
      //               )
      //             ]
      //           ),
      //           child: Text(
      //             '${_info.totalDistance}, ${_info.totalDuration}',
      //             style: const TextStyle(
      //               fontSize: 18.0,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
    );
  }
}