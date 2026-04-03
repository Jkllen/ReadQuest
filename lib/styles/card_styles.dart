import 'package:flutter/material.dart';

class CardStyles {
  static BoxDecoration borderCard({Color? color}) {
    if (color == null) {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      );
    }

    return BoxDecoration(
      color: clampHSL(color, lightness: 0.5),
      borderRadius: BorderRadius.circular(20),
      // border: Border.all(
      //   color: clampHSL(color, lightness: 0.6, saturation: 0.5),
      //   width: 1,
      // ),
    );
  }

  static BoxDecoration dropshadowCard({Color? color}) {
    if (color == null) {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      );
    }

    return BoxDecoration(
      color: clampHSL(color, lightness: 0.92, saturation: 0.40),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: clampHSL(color, lightness: 0.6, saturation: 0.5),
        width: 1,
      ),
    );
  }

  static Color clampHSL(
    Color color, {
    double lightness = -1,
    double saturation = -1,
  }) {
    HSLColor hsl = HSLColor.fromColor(color);

    if (lightness != -1) {
      lightness = lightness.clamp(0.0, 1.0);
    } else {
      lightness = hsl.lightness;
    }

    if (saturation != -1) {
      saturation = saturation.clamp(0.0, 1.0);
    } else {
      saturation = hsl.saturation;
    }

    return hsl.withLightness(lightness).withSaturation(saturation).toColor();
  }
}
