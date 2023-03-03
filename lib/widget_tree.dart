import 'package:bus_time/pages/routes_page.dart';
import 'package:bus_time/widgets/map_screen.dart';
import 'package:flutter/material.dart';

import 'package:bus_time/api/auth.dart';
import 'package:bus_time/pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          // return const MapScreen();
          return RoutesPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}