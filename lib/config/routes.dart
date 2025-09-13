import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/invoice/invoice_screen.dart';
import '../screens/invoice/professional_invoice_screen.dart';
import '../screens/invoice/invoice_list_screen.dart';
import '../models/user.dart';
import '../main.dart';

class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String invoiceList = '/invoices';
  static const String invoice = '/invoice';
  static const String professionalInvoice = '/professional-invoice';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (_) => const MyHomePage());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case profileSetup:
        final args = settings.arguments as Map<String, dynamic>?;
        final user = args?['user'] as User?;
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('User information required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(user: user),
        );

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case booking:
        final args = settings.arguments as Map<String, dynamic>?;
        final physiotherapist = args?['physiotherapist'] as User?;
        if (physiotherapist == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Physiotherapist information required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BookingScreen(physiotherapist: physiotherapist),
        );

      case invoiceList:
        return MaterialPageRoute(builder: (_) => const InvoiceListScreen());

      case invoice:
        final args = settings.arguments as Map<String, dynamic>?;
        final invoiceId = args?['invoiceId'] as String?;
        if (invoiceId == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invoice ID required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => InvoiceScreen(invoiceId: invoiceId),
        );

      case professionalInvoice:
        final args = settings.arguments as Map<String, dynamic>?;
        final invoiceId = args?['invoiceId'] as String?;
        if (invoiceId == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invoice ID required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProfessionalInvoiceScreen(invoiceId: invoiceId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
