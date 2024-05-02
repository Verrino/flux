import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';

class LaunchAppScreen extends StatelessWidget {
  LaunchAppScreen({super.key});

  final ColorPallete colorPallete =
      1 == 1 ? DarkModeColorPallete() : LightModeColorPallete();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then(
      (value) {
        Navigator.pushNamed(context, 'login');
      },
    );

    return Scaffold(
      backgroundColor: colorPallete.backgroundColor,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
