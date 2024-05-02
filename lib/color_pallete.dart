import 'package:flutter/material.dart';

class ColorPallete {
  late Color backgroundColor;
  late Color fontColor;
  late Color textFieldColor;
  late Color textFieldTextColor;
  late Color buttonColor;
  Color textLinkColor = const Color(0xFF4F75FB);
}

class DarkModeColorPallete extends ColorPallete {
  DarkModeColorPallete() {
    super.backgroundColor = const Color(0xFF272727);
    super.fontColor = const Color(0xFFFFFFFF);
    super.textFieldColor = const Color(0xFF5F6363);
    super.textFieldTextColor = const Color(0xFF8C8A8A);
    super.buttonColor = const Color(0xFF333232);
  }
}

class LightModeColorPallete extends ColorPallete {
  LightModeColorPallete() {
    super.backgroundColor = const Color(0xFFF3F3F3);
    super.fontColor = const Color(0xFF000000);
    super.textFieldColor = const Color(0xFFBEBEBE);
    super.textFieldTextColor = const Color(0xFF626262);
    super.buttonColor = const Color(0xFFB2B2B2);
  }
}
