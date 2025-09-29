import 'package:flutter/material.dart';
import 'pages/map_page.dart';
import 'pages/guide_booking_page.dart';
import 'pages/event_calendar_page.dart';
import 'pages/virtual_tour_page.dart';
import 'pages/booking_checkout_page.dart';
import 'pages/monastery_details_page.dart';
import 'models/booking.dart';
import 'models/monastery.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/bookings_page.dart';

void main() {
  runApp(const SikkimTourismApp());
}

class SikkimTourismApp extends StatelessWidget {
  const SikkimTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sikkim Tourism Prototype',
      theme: ThemeData(
        useMaterial3: true,
      colorSchemeSeed: const Color(0xFF2E7D32), // Sikkim green
      brightness: Brightness.light,
      textTheme: GoogleFonts.poppinsTextTheme(),   // add: import 'package:google_fonts/google_fonts.dart';
      cardTheme: const CardThemeData(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      ),
      appBarTheme: const AppBarTheme(
      centerTitle: false,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const Shell());
          case '/book':
            final monastery = settings.arguments as String?;
            return MaterialPageRoute(builder: (_) => GuideBookingPage(monastery: monastery));
          case '/tour':
            final monastery = settings.arguments as String?;
            return MaterialPageRoute(builder: (_) => VirtualTourPage(monastery: monastery));
          case '/checkout':
            final booking = settings.arguments as Booking;
            return MaterialPageRoute(builder: (_) => BookingCheckoutPage(booking: booking));
          case '/mybookings':
            return MaterialPageRoute(builder: (_) => const MyBookingsPage());
          case '/monastery':
            final monastery = settings.arguments as Monastery;
            return MaterialPageRoute(builder: (_) => MonasteryDetailsPage(monastery: monastery));
        }
        return null;
      },
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;
  final _pages = const [
    MapPage(),
    GuideBookingPage(),
    EventCalendarPage(),
    VirtualTourPage(),
    MyBookingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.person_pin_circle_outlined), label: 'Guides'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.vrpano_outlined), label: 'Tours'),
          NavigationDestination(icon: Icon(Icons.confirmation_num_outlined), label: 'Bookings'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
