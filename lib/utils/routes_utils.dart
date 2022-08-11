import 'package:chat_app/pages/home_page.dart';

import '../pages/login_page.dart';

class RouteUtils {
  static var nameRoutes = {
    LoginPage.loginPageRoute: (context) => const LoginPage(),
    HomePage.homePageRoute: (context) => const HomePage(),
  };
}
