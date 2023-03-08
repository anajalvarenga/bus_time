import 'package:bus_time/pages/routes_user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

class RoutesFilter extends StatefulWidget {
  const RoutesFilter({super.key});

  @override
  State<RoutesFilter> createState() => _RoutesFilterState();
}

class _RoutesFilterState extends State<RoutesFilter> {
  final _dateController = TextEditingController();

  String googleApiKey = 'AIzaSyCVCLhkQcULS-gCNlg8LGZMX0E--iegw_A';

  String locationStart = "Buscar ponto de origem"; 
  late Map<String, dynamic> locationStartSearch; 
  
  String locationEnd = "Buscar ponto de chegada";
  late Map<String, dynamic> locationEndSearch; 
  
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
                      locationStart = place.description.toString();
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

                    setState(() {
                      locationStartSearch = {
                        'name': locationStart,
                        'coordinates': GeoPoint(lat, lng),
                      };
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
                        title:Text(locationStart),
                        trailing: const Icon(Icons.search_rounded),
                        dense: true,
                      )
                    ),
                ),
              )
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
                      locationEnd = place.description.toString();
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

                    setState(() {
                      locationEndSearch = {
                        'name': locationEnd,
                        'coordinates': GeoPoint(lat, lng),
                      };
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
                        title:Text(locationEnd),
                        trailing: const Icon(Icons.search),
                        dense: true,
                      )
                    ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Data da partida',
                ),
                controller: _dateController,
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
                            _dateController.text = formattedDate; //set output date to TextField value. 
                        });
                    }
                }
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                final dateText = _dateController.text;
                if(dateText == ''
                  || locationStart == 'Buscar ponto de origem'
                  || locationStart == 'Buscar ponto de chegada') return;
          
                final date = DateTime.parse(dateText);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  RoutesUserPage(
                      start: locationStartSearch,
                      end: locationEndSearch,
                      date: date,
                    ),
                  ),
                );
              },
              child: const Text('Buscar')
            ),
          ],
        ),
      )
    );
  }
}