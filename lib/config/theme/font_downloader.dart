import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static Future<void> loadFonts() async {
    // Preload fonts to avoid UI jumps
    await Future.wait([
      GoogleFonts.sora().fontFamily,
      GoogleFonts.inter().fontFamily,
    ].map((font) async {
      if (font != null) {
        await precacheFonts(font);
      }
    }));
  }

  static Future<void> precacheFonts(String fontFamily) async {
    const text =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final style = TextStyle(fontFamily: fontFamily, fontSize: 14);
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
  }

  // Get Sora font
  static TextStyle sora({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.sora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Get Inter font
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }
}
