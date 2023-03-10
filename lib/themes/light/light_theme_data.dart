part of '../app_theme.dart';

final _lightThemeData = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: LightStyleConstants.charcoal,
    onPrimary: LightStyleConstants.white,
    error: LightStyleConstants.error,
    tertiary: LightStyleConstants.purple,
    onTertiary: LightStyleConstants.blue,
    tertiaryContainer: LightStyleConstants.charcoalTint3,
    background: LightStyleConstants.background,
    onBackground: LightStyleConstants.transparent,
    secondary: LightStyleConstants.charcoalTint3,
    secondaryContainer: Colors.black,
    onSecondary: LightStyleConstants.charcoalTint2,
    surfaceVariant: LightStyleConstants.grey,
    primaryContainer: LightStyleConstants.white,
    onPrimaryContainer: LightStyleConstants.white,
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: LightStyleConstants.background,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  extensions: [
    AppMenuItemStyles.light(),
    SignOutAnimationStyles(
      begin: Colors.indigo[100] ?? Colors.white,
      end: Colors.orange[400] ?? Colors.black,
    ),
  ],
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 64,
      fontFamily: FontFamily.billy,
      fontWeight: FontWeight.w600,
    ),
    subtitle1: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    bodyText1: TextStyle(color: LightStyleConstants.white, fontSize: 20),
    bodyText2: TextStyle(color: LightStyleConstants.charcoal, fontSize: 14),
    headline1: TextStyle(
      color: LightStyleConstants.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    button: TextStyle(color: Colors.white, fontSize: 14),
  ),
);
