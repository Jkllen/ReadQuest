import 'package:flutter/material.dart';

class CardStyles {
  static BoxDecoration borderCard({Color? color}) {
    if (color == null) {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      );
    }

    return BoxDecoration(
      color: modifyHSL(color, lightness: 0.1, saturation: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: modifyHSL(color, saturation: 0.1),
        width: 2,
      ),
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
      color: setHSL(color, lightness: 0.92, saturation: 0.40),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: setHSL(color, lightness: 0.6, saturation: 0.5),
        width: 1,
      ),
    );
  }

  static Color setHSL(
    Color color, {
    double hue = -1,
    double lightness = -1,
    double saturation = -1,
  }) {
    HSLColor hsl = HSLColor.fromColor(color);

    if (hue != -1) {
      hue = hue.clamp(0.0, 360.0);
    } else {
      hue = hsl.hue;
    }

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

  static Color modifyHSL(
    Color color, {
    double hue = 0,
    double lightness = 0,
    double saturation = 0,
  }) {
    HSLColor hsl = HSLColor.fromColor(color);

    hue = (hsl.hue + hue) % 360;
    lightness = (hsl.lightness + lightness).clamp(0.0, 1.0);
    saturation = (hsl.saturation + saturation).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).withSaturation(saturation).toColor();
  }
}
