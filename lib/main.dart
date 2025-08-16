import 'package:flutter/material.dart';
import 'package:inner_me_application/core/style.dart';
import 'package:inner_me_application/core/app_routes.dart';
import 'package:loader_overlay/loader_overlay.dart';


void main() {
  runApp(InnerMeApp());
}

class InnerMeApp extends StatelessWidget {
  InnerMeApp({super.key});

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: IMAppColor.appBlue,
    primary: IMAppColor.appBlue,
    secondary: IMAppColor.appBlue,
    surface: IMAppColor.appLightGrey,
    onPrimary: IMAppColor.appWhite,
    onSurface: IMAppColor.appBlack,
    primaryContainer: IMAppColor.appLightGrey,
    error: IMAppColor.appRed,
  );

  final TextTheme textTheme = TextTheme(
    headlineLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: IMAppColor.appBlack,
    ),
    headlineMedium: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: IMAppColor.appBlack,
    ),
    headlineSmall: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: IMAppColor.appBlack,
    ),
    bodySmall: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: IMAppColor.appMidGrey,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: IMAppColor.appMidGrey,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: IMAppColor.appMidGrey,
    ),
    titleMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: IMAppColor.appBlack,
    ),
    displayMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: IMAppColor.appBlack,
    ),
    labelSmall: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: IMAppColor.appBlack,
    ),
    labelMedium: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: IMAppColor.appBlack,
    ), // can use in first line of vehicle block
  );

  final IconThemeData iconTheme = IconThemeData.fallback().copyWith(
    color: IMAppColor.appBlue,
    size: 12.0,
    opticalSize: 24.0,
  );
  final ProgressIndicatorThemeData progressTheme = ProgressIndicatorThemeData(
    borderRadius: BorderRadius.circular(3),
    linearMinHeight: 6,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appBarTheme = AppBarTheme(
      titleSpacing: 0.0,
      titleTextStyle: textTheme.headlineMedium,
      centerTitle: true,
      leadingWidth: 66,
      actionsPadding: EdgeInsets.only(right: 20),
      toolbarHeight: 56,
    );
    return GestureDetector(
      onTap: () {
        // Hide keyboard when click outside https://stackoverflow.com/questions/51652897/how-to-hide-soft-input-keyboard-on-flutter-after-clicking-outside-textfield-anyw
        FocusScope.of(context).unfocus();
      },
      child: GlobalLoaderOverlay(
        child: MaterialApp.router(
          title: 'Inner Me',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            buttonTheme: ButtonThemeData(height: 45),
            colorScheme: colorScheme,
            textTheme: textTheme,
            fontFamily: IMAppFont.appFontFamily,
            dividerTheme: const DividerThemeData(color: Colors.transparent),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: NoTransitionsBuilder(),
                TargetPlatform.iOS: NoTransitionsBuilder(),
                TargetPlatform.macOS: NoTransitionsBuilder(),
                TargetPlatform.windows: NoTransitionsBuilder(),
              },
            ),
            appBarTheme: appBarTheme,
            iconTheme: iconTheme,
            radioTheme: RadioThemeData(
              visualDensity: VisualDensity(
                horizontal: VisualDensity.minimumDensity,
              ),
            ),
          
            popupMenuTheme: PopupMenuThemeData(
              color: IMAppColor.appLightGrey,
              iconSize: 24,
              iconColor: Colors.black,
              textStyle: textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: IMAppColor.appLightGrey,
              modalBarrierColor: IMAppColor.backdropColor,
              showDragHandle: false,
            ),
            bottomAppBarTheme: BottomAppBarTheme(
              color: Colors.transparent,
              height: 69,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: IMAppColor.appLightGrey,
            ),
            progressIndicatorTheme: progressTheme,
          ),
          routerConfig: routerConfig,
        ),
      ),
    );
  }
}

// Disable animation when route
class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
