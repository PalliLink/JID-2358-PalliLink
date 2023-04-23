import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PalliNet());
}

class PalliNet extends StatelessWidget {
  const PalliNet({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: createMaterialColor(const Color(0xFFD6EDFF)),
          errorColor: createMaterialColor(const Color(0xFFFF8484)),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginLandingPage(),
          '/login/patient': (context) => const PatientLogin(),
          '/login/physician': (context) => const PhysicianLogin(),
          '/new/patient': (context) => const NewAccountPage(),
          '/provider': (context) => const ProviderLandingPage(),
          '/patient/home': (context) => const PatientHome(),
          '/patient/medications': (context) => const Medications(),
          '/patient/recommendedspecialists': (context) =>
              const RecommendedSpecialists(),
          '/prescriptionsdetailedview': (context) =>
              const PrescriptionsDetailedView(),
          '/patient/endoflifeplans': (context) => const EndOfLifePlansView(),
          '/patient/treatments': (context) => const Treatments(),
          '/patient/diary/new': (context) => const NewPainDiaryEntry(),
          '/physician/home': (context) => const PhysicianHome(),
          '/patients': (context) => const PatientList(),
          '/physician/patient/details': (context) => const PatientDetails(),
          '/physician/patient/edit_details': (context) =>
              const EditPatientDetails(),
          '/physician/appointments': (context) => const PhysicianAppointments(),
          '/appointments/details': (context) => const AppointmentPage(),
          '/patient/appointments': (context) => const PatientAppointments(),
          '/physician/appointments/new': (context) => const CreateAppointment(),
          '/patient/calendar': (context) => const CalendarView(),
          '/forgotpassword': (context) => const ForgotPage(),
          '/symptoms': (context) => const SymptomsView(),
          '/physician/profile': (context) => const ProfileContent(),
          '/forgotsuccess': (context) => const ForgotSuccess(),
          '/chart': (context) => const Chart(),
          '/contacts': (context) => const ContactsPage(),
          '/facilities': (context) => const FacilitiesPage(),
        },
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => const HomePage()));
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
