import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color deepSpaceBlack = Color(0xFF050505);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color electricBlue = Color(0xFF00E5FF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSpaceBlack,
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: electricBlue,
        surface: Color(0xFF111111),
        background: deepSpaceBlack,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.orbitron(fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: GoogleFonts.orbitron(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: deepSpaceBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          color: electricBlue,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          shadows: [
            const Shadow(color: electricBlue, blurRadius: 10),
          ],
        ),
        iconTheme: const IconThemeData(color: neonPurple),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonPurple,
        foregroundColor: Colors.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF151515),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: const BorderSide(color: neonPurple, width: 1),
        ),
      ),
    );
  }

  // Neon colors for Priority
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Acil':
        return const Color(0xFFFF1744); // Neon Red
      case 'Önemli':
        return const Color(0xFFFF9100); // Neon Orange
      case 'Normal':
        return const Color(0xFF00E5FF); // Electric Blue
      case 'Az Önemli':
        return const Color(0xFF00E676); // Neon Green
      default:
        return Colors.grey.shade600;
    }
  }
}
