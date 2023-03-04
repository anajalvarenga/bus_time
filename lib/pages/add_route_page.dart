import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

import '../models/route_model.dart';

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final _companyController = TextEditingController();
  final _startController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endController = TextEditingController();
  final _endTimeController = TextEditingController();

  String googleApiKey = 'AIzaSyCVCLhkQcULS-gCNlg8LGZMX0E--iegw_A';
  String location = "Adicionar rota"; 
  List<Map<String, dynamic>> busStopList = [];

  Future createRoute({
    required String company,
    required DateTime start,
    required DateTime end,
  }) async {
    if(busStopList.length < 2) return;

    final docRoute = FirebaseFirestore.instance.collection('route').doc();
    final route = BusRoute(
      id: docRoute.id,
      driver_id: 'aaaaaaaaaaa id',
      company: company,
      date_start: start,
      date_end: end,
      bus_stops: busStopList,
    );
    final json = route.toJson();

    await docRoute.set(json);

    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Rota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.business),
                  labelText: 'Empresa',
                ),
                controller: _companyController
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Data da partida',
                ),
                controller: _startController,
                onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101)
                    );
                    
                    if(pickedDate != null ){
                        String formattedDate = pickedDate.toString().substring(0, 10); 
            
                        setState(() {
                            _startController.text = formattedDate; //set output date to TextField value. 
                        });
                    }
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.timer),
                  labelText: 'Horário da partida',
                ),
                controller: _startTimeController,
                onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now()
                    );
                    
                    if(pickedTime != null ){
                        String formattedTime = pickedTime.toString().substring(10, 15); 
            
                        setState(() {
                          _startTimeController.text = formattedTime; //set output date to TextField value. 
                        });
                    }
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Data da chegada',
                ),
                controller: _endController,
                onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101)
                    );
                    if(pickedDate != null ){
                        String formattedDate = pickedDate.toString().substring(0, 10); 
            
                        setState(() {
                           _endController.text = formattedDate; //set output date to TextField value. 
                        });
                    }
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.timer),
                  labelText: 'Horário da chegada',
                ),
                controller: _endTimeController,
                onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now()
                    );
                    
                    if(pickedTime != null ){
                        String formattedTime = pickedTime.toString().substring(10, 15); 
            
                        setState(() {
                           _endTimeController.text = formattedTime; //set output date to TextField value. 
                        });
                    }
                }
              ),
            ),
            InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApiKey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'br')],
                              //google_map_webservice package
                  onError: (err){
                      print(err);
                  }
                );

                if(place != null){
                    setState(() {
                      location = place.description.toString();
                    });

                    //form google_maps_webservice package
                    final plist = GoogleMapsPlaces(apiKey: googleApiKey,
                          apiHeaders: await const GoogleApiHeaders().getHeaders(),
                                    //from google_api_headers package
                    );
                    String placeid = place.placeId ?? "0";
                    final detail = await plist.getDetailsByPlaceId(placeid);
                    final geometry = detail.result.geometry!;
                    final lat = geometry.location.lat;
                    final lng = geometry.location.lng;

                    busStopList.add({
                      'name': location,
                      'coordinates': GeoPoint(lat, lng),
                    });
                    setState(() {
                      location = "Adicionar rota";
                    });
                }
              },
              child:Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title:Text(location),
                        trailing: const Icon(Icons.add),
                        dense: true,
                      )
                    ),
                ),
              )
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: busStopList.length,
              itemBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          title:Text(busStopList[index]['name']),
                          trailing: const Icon(Icons.location_on),
                          dense: true,
                        )
                      ),
                  ),
                ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                final company = _companyController.text;
                final start = _startController.text;
                final startTime = _startTimeController.text;
                final end = _endController.text;
                final endTime = _endTimeController.text;
                createRoute(
                  company: company,
                  start: DateTime.parse('$start $startTime'),
                  end: DateTime.parse('$end $endTime'),
                );
              },
              child: const Icon(Icons.add)
            ),
          ],
        ),
      )
    );
  }
}