import 'package:flutter/material.dart';

import 'package:cinemapedia/ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final Widget childView;

  static const name = 'home-screen';

  const HomeScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: const CustomBottomNavigationbar(),
    );
  }
}
