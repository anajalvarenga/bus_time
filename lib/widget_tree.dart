import 'package:bus_time/pages/navigate_page.dart';
import 'package:bus_time/pages/routes_filter.dart';
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
          // return RoutesPage();
          return const NavigatePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}