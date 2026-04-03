import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle splashTitle = TextStyle(
    fontFamily: 'Mojangles',
    fontSize: 28,
    color: Color(0xFF111391),
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  );

  static const TextStyle splashTagline = TextStyle(
    fontFamily: 'Tilt Warp',
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'IBM Plex Serif',
    fontSize: 24,
    color: Color(0xFF555555),
    fontWeight: FontWeight.w700,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'IBM Plex Serif',
    fontSize: 16,
    color: Color(0xFF666666),
    fontWeight: FontWeight.w400,
  );

  static const TextStyle smallMuted = TextStyle(
    fontFamily: 'Mojangles',
    fontSize: 13,
    color: Color(0xFF797D87),
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Mojangles',
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle clickableAccent = TextStyle(
    color: Color(0xFF69856B),
    fontSize: 13,
    fontFamily: 'Mojangles',
    fontWeight: FontWeight.w400,
  );

  // Reading Content Screen

  static const TextStyle readingHeaderLabel = TextStyle(
    color: Color(0xFF818181),
    fontSize: 12,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle readingHeaderTitle = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle readingTitle = TextStyle(
    color: Colors.black,
    fontSize: 32,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle readingAuthor = TextStyle(
    color: Color(0xFF868686),
    fontSize: 14,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle readingSummary = TextStyle(
    color: Colors.black,
    fontSize: 11,
    fontStyle: FontStyle.italic,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle readingBody = TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w400,
    height: 1.8,
  );

  static const TextStyle readingQuizButton = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    height: 1.5,
  );
}