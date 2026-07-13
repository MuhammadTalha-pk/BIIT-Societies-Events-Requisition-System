import 'package:flutter/material.dart';
import '../screens/common/splash_screen.dart';
import '../screens/common/login_screen.dart';
import '../screens/chairperson/cp_home.dart';
import '../screens/it_head/it_home.dart';
import '../screens/staff_head/staff_home.dart';
import '../screens/student_affairs/sa_home.dart';
import '../screens/accounts_officer/account_home.dart';
import '/models/user.dart';

// import other screens here...

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/login': (context) => LoginScreen(),
};

// This function helps to pass user data dynamically when navigating
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/it_home':
      final user = settings.arguments as User;
      return MaterialPageRoute(builder: (context) => ItHomeScreen(user: user));
    case '/staff_home':
      final user = settings.arguments as User;
      return MaterialPageRoute(
        builder: (context) => StaffHomeScreen(user: user),
      );
    case '/cp_home':
      final user = settings.arguments as User;
      return MaterialPageRoute(
        builder: (context) => ChairpersonHomeScreen(user: user),
      );
    case '/sa_home':
      final user = settings.arguments as User;
      return MaterialPageRoute(builder: (context) => SaHomeScreen(user: user));
    case '/account_home':
      final user = settings.arguments as User;
      return MaterialPageRoute(
        builder: (context) => AccountHomeScreen(user: user),
      );
    // Add other cases for other screens requiring user
    default:
      return MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ); // Default screen
  }
}
