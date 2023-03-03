import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.indigo,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 9,
    appBarStyle: FlexAppBarStyle.primary,
    tabBarStyle: FlexTabBarStyle.universal,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      textButtonRadius: 6.0,
      elevatedButtonRadius: 4.0,
      outlinedButtonBorderWidth: 1.5,
      outlinedButtonPressedBorderWidth: 1.0,
      toggleButtonsRadius: 5.0,
      switchSchemeColor: SchemeColor.secondary,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorRadius: 7.0,
      inputDecoratorBorderWidth: 2.0,
      inputDecoratorFocusedBorderWidth: 2.5,
      fabUseShape: true,
      fabRadius: 15.0,
      fabSchemeColor: SchemeColor.tertiaryContainer,
      popupMenuRadius: 5.0,
      popupMenuElevation: 5.0,
      snackBarBackgroundSchemeColor: SchemeColor.inversePrimary,
      tabBarIndicatorSchemeColor: SchemeColor.surfaceTint,
      bottomSheetRadius: 7.0,
      navigationBarIndicatorOpacity: 0.19,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.indigo,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 15,
    appBarElevation: 11.0,
    tabBarStyle: FlexTabBarStyle.universal,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      textButtonRadius: 6.0,
      elevatedButtonRadius: 4.0,
      outlinedButtonBorderWidth: 1.5,
      outlinedButtonPressedBorderWidth: 1.0,
      toggleButtonsRadius: 5.0,
      switchSchemeColor: SchemeColor.secondary,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorRadius: 7.0,
      inputDecoratorBorderWidth: 2.0,
      inputDecoratorFocusedBorderWidth: 2.5,
      fabUseShape: true,
      fabRadius: 15.0,
      fabSchemeColor: SchemeColor.tertiaryContainer,
      popupMenuRadius: 5.0,
      popupMenuElevation: 5.0,
      snackBarBackgroundSchemeColor: SchemeColor.inversePrimary,
      bottomSheetRadius: 7.0,
      navigationBarIndicatorOpacity: 0.19,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
}
