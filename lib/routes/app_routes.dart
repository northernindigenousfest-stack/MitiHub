import 'package:flutter/material.dart';
import '../presentation/tree_species_library/tree_species_library.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/miti_bot_chat/miti_bot_chat.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String treeSpeciesLibrary = '/tree-species-library';
  static const String splash = '/splash-screen';
  static const String authentication = '/authentication-screen';
  static const String dashboard = '/dashboard';
  static const String onboardingFlow = '/onboarding-flow';
  static const String mitiBotChat = '/miti-bot-chat';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    treeSpeciesLibrary: (context) => const TreeSpeciesLibrary(),
    splash: (context) => const SplashScreen(),
    authentication: (context) => const AuthenticationScreen(),
    dashboard: (context) => const Dashboard(),
    onboardingFlow: (context) => const OnboardingFlow(),
    mitiBotChat: (context) => const MitiBotChat(),
    // TODO: Add your other routes here
  };
}
