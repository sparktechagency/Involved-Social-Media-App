import 'package:flutter/material.dart';
import '../../base/bottom_menu..dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomMenu(0),
    );
  }
}
