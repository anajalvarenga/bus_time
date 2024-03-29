import 'package:bus_time/pages/add_route_page.dart';
import 'package:bus_time/pages/route_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../api/auth.dart';

class RoutesPage extends StatelessWidget {
  RoutesPage({super.key});

  final User? _user = Auth().currentUser;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotas'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("route")
          .where('driver_id', isEqualTo: _user?.uid).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data?.docs[index] as DocumentSnapshot<Object?>),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddRoutePage(),
            ),
          );
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }
}