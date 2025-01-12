import 'package:flutter/material.dart';

class CustomTheme with ChangeNotifier {


  static ThemeData get lightTheme {
    return ThemeData(

      appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent
      ),
/*-Main Colors ----------------------------------------------------------------------*/

      primaryColor: const Color(0xFF2B9EF2),
      primaryColorDark: const Color(0xFFFFFEFE),
      scaffoldBackgroundColor: const Color(0xFFF0F0F2),
      primaryColorLight: const Color(0xFFf7f7f7),
      splashColor: Colors.transparent,
      cardColor: const Color(0xFFEAEAEA),
      canvasColor: const Color(0xFFFFFFFF),
      dialogBackgroundColor: const Color(0xFF9EDF66),
      secondaryHeaderColor: const Color(0xFF1C1C1F),



/* Colors for simple stuff (icons etc.)------------------------------*/

      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF888A8D),
        onPrimary: Color(0xFF6C7077),
        tertiaryContainer: Color(0xFFBBBBBB),
        secondary: Color(0xFFBBBBBB),
        onSecondary: Color(0xFFEAEAEA),
        tertiary: Color(0xFF44494E),
        onTertiary: Color(0xFF1C1C1F),
        error: Color(0xFFFEF6F6),
        onError: Color(0xFFF32424),
        surface: Color(0xFFE5E5E8),
        onSurface: Color(0xFF888A8D),
        outline: Color(0xFF888A8D),
      ),

/*-Text Theme-------------------------------------------------------------------------*/

      textTheme: const TextTheme(

        titleLarge: TextStyle(
          color: Color(0xFF0E0E0E),
          fontSize: 18,
          fontFamily: "PBSEB",
          letterSpacing: 0.3,
          height: 0.9,),

        titleMedium: TextStyle(
          color: Color(0xFF0E0E0E),
          fontSize: 18,
          fontFamily: "PBSLT",
          letterSpacing: 0.3,
          height: 0.9,),

        displayLarge: TextStyle(
          color: Color(0xFF0E0E0E),
          fontSize: 18,
          fontFamily: "PBSMD",
          letterSpacing: 0.3,
          height: 0.9,),

        displaySmall: TextStyle(
          color: Color(0xFF0E0E0E),
          fontSize: 18,
          fontFamily: "PBSRG",
          letterSpacing: 0.3,
          height: 0.9,),
      ),
    );
  }
}