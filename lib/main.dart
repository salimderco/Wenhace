// Import Flutter core packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import app-specific services and screens
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

/// Main entry point of the application
/// Initializes Flutter bindings, sets up system UI, and starts the app
void main() async {
  // Initialize Flutter bindings (required before using Flutter services)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI (status bar and navigation bar) to be transparent
  // This creates an immersive, edge-to-edge design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // Light icons on dark background
      systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
      systemNavigationBarIconBrightness: Brightness.light, // Light navigation icons
    ),
  );
  
  // Initialize authentication service (loads saved login state from storage)
  await AuthService().init();
  
  // Launch the app with MyApp as the root widget
  runApp(const MyApp());
}

/// Root widget of the application
/// Configures the Material app with custom theme and sets splash screen as home
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Reputation Enhancer', // App name shown in task switcher
      debugShowCheckedModeBanner: false, // Hide debug banner in top-right corner
      
      // Configure app-wide theme (colors, fonts, styles)
      theme: ThemeData(
        useMaterial3: true, // Use Material Design 3
        // Generate color scheme from orange seed color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCC5500), // Orange accent color
          brightness: Brightness.dark, // Dark theme
        ),
        scaffoldBackgroundColor: const Color(0xFF0f0f1e), // Dark background color
        fontFamily: '.SF Pro Text', // iOS system font
        // Define text styles for different text types (headings, body, labels)
        textTheme: const TextTheme(
          // Display text styles (largest headings)
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          // Headline text styles (section titles)
          headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          // Title text styles (card titles, list items)
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          // Body text styles (paragraphs, descriptions)
          bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400),
          // Label text styles (buttons, form labels)
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        // Card theme (glassmorphism style with semi-transparent background)
        cardTheme: CardThemeData(
          elevation: 0, // No shadow (flat design)
          color: Colors.white.withOpacity(0.08), // Semi-transparent white
          surfaceTintColor: Colors.transparent, // No color tint
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(28)), // Rounded corners
            side: BorderSide(
              color: Colors.white.withOpacity(0.15), // Subtle border
              width: 1.5,
            ),
          ),
        ),
        // App bar theme (transparent with centered title)
        appBarTheme: const AppBarTheme(
          centerTitle: true, // Center the title
          elevation: 0, // No shadow
          backgroundColor: Colors.transparent, // Transparent background
          foregroundColor: Colors.white, // White icons and text
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: '.SF Pro Text',
            letterSpacing: 0.5,
          ),
        ),
        // Elevated button theme (orange gradient buttons)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0, // No shadow
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20), // Button padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32), // Rounded corners
            ),
            backgroundColor: const Color(0xFFCC5500), // Orange background
            foregroundColor: Colors.white, // White text
            shadowColor: const Color(0xFFCC5500), // Orange shadow color
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Floating action button theme (orange FAB)
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFFCC5500), // Orange background
          foregroundColor: Colors.white, // White icon
          elevation: 6, // Slight shadow for depth
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // Rounded corners
          ),
        ),
      ),
      home: const SplashScreen(), // First screen shown when app launches
    );
  }
}
