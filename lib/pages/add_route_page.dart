import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/route_model.dart';

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final _controller = TextEditingController();

  Future createRoute({required String driver}) async {
    final docRoute = FirebaseFirestore.instance.collection('route').doc();
    final route = BusRoute(
      id: docRoute.id,
      driver: driver,
      company: 'Bus Ana',
      start: DateTime(2023, 3, 2),
      end: DateTime(2023, 3, 3),
      stops: [const GeoPoint(0.0, 0.0)]
    );
    final json = route.toJson();

    await docRoute.set(json);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Rota'),
      ),
      body: Column(
        children: [
          TextField(controller: _controller),
          ElevatedButton(
            onPressed: () {
              final driver = _controller.text;
              createRoute(driver: driver);
            },
            child: const Icon(Icons.add)
          ),
        ],
      )
    );
  }
}