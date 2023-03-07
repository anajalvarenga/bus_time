// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RoutePage extends StatefulWidget {
  var route_id = '';

  RoutePage({super.key, required this.route_id});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool _started = false;
  late DocumentSnapshot _document;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    getCityName(name) {
      var index = name.indexOf(',');
      if(index == -1) return name;
      return name.substring(0, index);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: Image.asset(
                'assets/images/bus.png',
                height: 24,
              ),
            ),
            Text(
              document['company'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      getCityName(document['bus_stops'][0]['name']),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${document['date_start'].toDate().hour}:${document['date_start'].toDate().minute}'
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.yellow
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Icon(Icons.arrow_right_alt)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      getCityName(document['bus_stops'][(document['bus_stops'].length - 1)]['name']),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${document['date_end'].toDate().hour}:${document['date_end'].toDate().minute}'
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  RoutePage(route_id: document['id']),
            ),
          );
        }
      ),
    );
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  setCurrentPosition() async{
    getUserCurrentLocation().then((value) async {
      print("${value.latitude} ${value.longitude}");
      _document.reference.update({
        'current_position': GeoPoint(value.latitude, value.longitude),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rota'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("route")
          .where('id', isEqualTo: widget.route_id).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              _document = (snapshot.data?.docs[0] as DocumentSnapshot<Object?>);
              return Column(
                children: [
                  _buildListItem(context, snapshot.data?.docs[0] as DocumentSnapshot<Object?>),
                  if (!_started) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        setState(() {
                            _started = true;
                            Timer.periodic(const Duration(seconds: 1), (timer) {
                              setCurrentPosition();
                              if(!_started) {
                                timer.cancel();
                              }
                            });
                        });
                      },
                      child: const Text('Iniciar rota')
                    ),
                  ) else Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        setState(() {
                            _started = false; //set output date to TextField value. 
                        });
                      },
                      child: const Text('Finalizar rota')
                    ),
                  )

                ],
              );
            }
          );
        }
      ),
    );
  }
}