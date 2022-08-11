import 'package:chat_app/controllers/chat_provider.dart';
import 'package:chat_app/controllers/user_provider.dart';
import 'package:chat_app/pages/splash_screen.dart';
import 'package:chat_app/utils/routes_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: RouteUtils.nameRoutes,
        home: const SpalashPage(),
      ),
    );
  }
}
