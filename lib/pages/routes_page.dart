import 'package:bus_time/pages/add_route_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
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
                      'Origem',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${document['start'].toDate().hour}:${document['start'].toDate().minute}'
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
                      'Destino',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${document['end'].toDate().hour}:${document['end'].toDate().minute}'
                    ),
                  ],
                ),
              ),
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
        stream: FirebaseFirestore.instance.collection('route').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            // itemExtent: 80.0,
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