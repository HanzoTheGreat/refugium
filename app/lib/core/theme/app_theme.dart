import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Refugium App Theme
///
/// Trauma-informiertes Design nach SAMHSA-Prinzipien:
/// - Safety: weiche Farben, keine aggressiven Kontraste, vorhersagbare UI
/// - Trustworthiness: klare Hierarchie, ehrliche Komponenten
/// - Empowerment: angenehme Touch-Targets, nie aufdringlich
///
/// Grün als persönlicher Akzent – gedämpft wie Moos, nicht wie eine Ampel.
/// Hintergründe warm wie Elfenbein – nie klinisch weiß.
class AppTheme {
  AppTheme._();

  // ── Kern-Farbpalette ─────────────────────────────────────────────────────

  /// Primär: warmes Waldgrün – persönlich, ruhig, geerdet
  static const _seed = Color(0xFF4B7A5C);

  /// Hintergrund hell: warmes Elfenbein – einladend, nicht klinisch

  /// Hintergrund dunkel: tiefes Waldnachtgrün

  /// Oberfläche hell: minimal heller als Hintergrund
  static const _surfaceLight = Color(0xFFF2EFE8);

  /// Oberfläche dunkel
  static const _surfaceDark = Color(0xFF1E2420);

  /// Oberflächenvariante hell: leicht getöntes Grün-Grau für Cards
  static const _surfaceVarLight = Color(0xFFDCE8E0);

  /// Oberflächenvariante dunkel
  static const _surfaceVarDark = Color(0xFF2C3530);

  // ── Light Theme ─────────────────────────────────────────────────────────

  static ThemeData get light {
    final base =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ).copyWith(
          surface: _surfaceLight,
          surfaceVariant: _surfaceVarLight,
          onSurface: const Color(0xFF1A1E1C),
          onSurfaceVariant: const Color(0xFF3D4D44),
        );
    return _build(base, Brightness.light);
  }

  // ── Dark Theme ───────────────────────────────────────────────────────────

  static ThemeData get dark {
    final base =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ).copyWith(
          surface: _surfaceDark,
          surfaceVariant: _surfaceVarDark,
          onSurface: const Color(0xFFE0E8E3),
          onSurfaceVariant: const Color(0xFFBACABF),
        );
    return _build(base, Brightness.dark);
  }

  // ── Theme Builder ────────────────────────────────────────────────────────

  static ThemeData _build(ColorScheme cs, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: brightness,
      scaffoldBackgroundColor: cs.surface,

      // ── AppBar ──────────────────────────────────────────────────────────
      // Fließt nahtlos in den Hintergrund – kein harter Balken oben
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: cs.shadow.withOpacity(0.08),
        surfaceTintColor: cs.primary,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: cs.surface,
              )
            : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: cs.surface,
              ),
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        iconTheme: IconThemeData(color: cs.onSurfaceVariant),
        actionsIconTheme: IconThemeData(color: cs.onSurfaceVariant),
      ),

      // ── Navigation Bar ──────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: cs.primary,
        height: 64,
        indicatorColor: cs.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? cs.primary : cs.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            size: 22,
          );
        }),
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      // Flach, weiche Ecken – keine harten Schatten
      cardTheme: CardThemeData(
        elevation: 0,
        color: isLight
            ? cs.surfaceVariant.withOpacity(0.5)
            : cs.surfaceVariant.withOpacity(0.6),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isLight
                ? cs.outlineVariant.withOpacity(0.4)
                : cs.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Input Felder ────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? cs.surfaceVariant.withOpacity(0.4)
            : cs.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: cs.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        hintStyle: TextStyle(
          color: cs.onSurfaceVariant.withOpacity(0.6),
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(color: cs.primary, fontSize: 13),
      ),

      // ── Buttons ─────────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          minimumSize: const Size(64, 48),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimaryContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          minimumSize: const Size(64, 48),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.outline.withOpacity(0.6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          minimumSize: const Size(48, 44),
        ),
      ),

      // ── Chips ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceVariant,
        selectedColor: cs.primaryContainer,
        checkmarkColor: cs.onPrimaryContainer,
        labelStyle: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: cs.outlineVariant.withOpacity(0.4), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),

      // ── Dialoge ─────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 14,
          height: 1.5,
        ),
      ),

      // ── SnackBar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? const Color(0xFF2C3530) : cs.surfaceVariant,
        contentTextStyle: TextStyle(
          color: isLight ? const Color(0xFFE0E8E3) : cs.onSurfaceVariant,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // ── ListTile ────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minVerticalPadding: 12,
        iconColor: cs.onSurfaceVariant,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 13,
          height: 1.4,
        ),
      ),

      // ── Switch ──────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          return cs.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return cs.primaryContainer;
          }
          return cs.surfaceVariant;
        }),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant.withOpacity(0.4),
        thickness: 1,
        space: 1,
      ),

      // ── BottomSheet ─────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.primary,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: cs.outlineVariant,
      ),

      // ── PopupMenu ───────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: cs.surface,
        surfaceTintColor: cs.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(color: cs.onSurface, fontSize: 14),
      ),

      // ── Dropdown ────────────────────────────────────────────────────────
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cs.surfaceVariant.withOpacity(0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(cs.surface),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          elevation: const WidgetStatePropertyAll(4),
        ),
      ),

      // ── Floating Action Button ───────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // ── Text Theme ──────────────────────────────────────────────────────
      // Minimal angepasst – leicht größere Body-Text für bessere Lesbarkeit
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w300,
        ),
        displaySmall: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        headlineMedium: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 26,
        ),
        headlineSmall: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 0.1,
        ),
        titleMedium: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
        bodyLarge: TextStyle(color: cs.onSurface, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: cs.onSurface, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 12,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 12,
          letterSpacing: 0.4,
        ),
        labelSmall: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
