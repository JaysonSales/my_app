import 'package:flutter/material.dart';

const MaterialColor primarySeedColor = Colors.deepPurple;

final ThemeData lightTheme = buildTheme(
  primarySeedColor,
  brightness: Brightness.light,
);
final ThemeData darkTheme = buildTheme(
  primarySeedColor,
  brightness: Brightness.dark,
);

ThemeData buildTheme(
  Color seedColor, {
  Brightness brightness = Brightness.light,
}) {
  final brightnessForSeed = ThemeData.estimateBrightnessForColor(seedColor);
  final textColor = (brightnessForSeed == Brightness.dark)
      ? Colors.white
      : Colors.black;

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: seedColor,
      foregroundColor: textColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: seedColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textColor, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(color: textColor, fontWeight: FontWeight.normal),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

final Map<String, ThemeData> appThemes = {
  "default": lightTheme,
  "dark": darkTheme,
  "blue": buildTheme(Colors.blue),
  "green": buildTheme(Colors.green),
  "red": buildTheme(Colors.red),
  "orange": buildTheme(Colors.orange),
  "pink": buildTheme(Colors.pink),
  "teal": buildTheme(Colors.teal),
  "cyan": buildTheme(Colors.cyan),
  "amber": buildTheme(Colors.amber),
  "indigo": buildTheme(Colors.indigo),
  "brown": buildTheme(Colors.brown),
  "yellow": buildTheme(Colors.yellow),
  "lime": buildTheme(Colors.lime),
  "grey": buildTheme(Colors.grey),
  "deepOrange": buildTheme(Colors.deepOrange),
};
