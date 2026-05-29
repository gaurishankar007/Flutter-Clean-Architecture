part of 'theme.dart';

/// Color Scheme
ColorScheme get colorScheme => ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  error: AppColors.error,
);

/// App ar Theme
AppBarTheme get appBarTheme => const AppBarTheme(
  backgroundColor: AppColors.white,
  surfaceTintColor: Colors.transparent,
  iconTheme: IconThemeData(color: AppColors.black),
  elevation: 0,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: AppColors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ),
);

/// InputDecoration Theme
OutlineInputBorder outlinedInputBorder(Color color) => OutlineInputBorder(
  borderRadius: UIHelpers.radiusC12,
  borderSide: BorderSide(color: color, width: 2),
);
InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
  hintStyle: const TextStyle(color: AppColors.fade, fontSize: 14),
  enabledBorder: outlinedInputBorder(AppColors.border),
  focusedBorder: outlinedInputBorder(AppColors.primary),
  errorBorder: outlinedInputBorder(AppColors.red600),
  focusedErrorBorder: outlinedInputBorder(AppColors.red600),
);

/// CheckBox Theme
CheckboxThemeData get checkBoxThemeData => CheckboxThemeData(
  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
  shape: RoundedRectangleBorder(borderRadius: UIHelpers.radiusC4),
);

/// ListTile Theme
ListTileThemeData get listTileThemeData => const ListTileThemeData(
  dense: true,
  contentPadding: EdgeInsets.zero,
  // If zero is given than it will take default top padding
  minVerticalPadding: 1,
  horizontalTitleGap: 0,
  minLeadingWidth: 0,
);
