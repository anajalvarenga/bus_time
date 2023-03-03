import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/route_model.dart';

class RoutesPage extends StatelessWidget {
  RoutesPage({super.key});

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['driver'],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.yellow
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              document['stops'][0].latitude.toString(),
              style: Theme.of(context).textTheme.displaySmall,
            )
          ),
        ],
      ),
      onTap: () {
        // document.reference.update({
        //   'driver': 'ana'
        // });
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap = await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            'driver': 'ana julia'
          });
        });
      }
    );
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: _controller),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final driver = _controller.text;
              createRoute(driver: driver);
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('route').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data?.docs[index] as DocumentSnapshot<Object?>),
          );
        }
      ),
    );
  }

  Future createRoute({required String driver}) async {
    final docRoute = FirebaseFirestore.instance.collection('route').doc();
    final route = BusRoute(
      id: docRoute.id,
      driver: driver,
      start: DateTime(2023, 3, 2),
      end: DateTime(2023, 3, 3),
      stops: [const GeoPoint(0.0, 0.0)]
    );
    final json = route.toJson();

    await docRoute.set(json);
  }
}