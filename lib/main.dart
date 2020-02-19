import 'package:flutter/material.dart';
import 'package:poloTournamnets/locator.dart';
import 'package:poloTournamnets/providers/data_service.dart';
import 'package:poloTournamnets/ui/screens/tournament_screen.dart';
import "package:poloTournamnets/ui/screens/walk_screen.dart";
import 'package:poloTournamnets/ui/screens/root_screen.dart';
import 'package:poloTournamnets/ui/screens/sign_in_screen.dart';
import 'package:poloTournamnets/ui/screens/sign_up_screen.dart';
import 'package:poloTournamnets/ui/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  Firestore.instance.settings();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => locator<DataService>())        
      ],
      child: MaterialApp(
        title: 'Club Billard Polo',
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
          '/root': (BuildContext context) => new RootScreen(),
          '/signin': (BuildContext context) => new SignInScreen(),
          '/signup': (BuildContext context) => new SignUpScreen(),
          '/main': (BuildContext context) => new MainScreen(),
          '/tournament': (BuildContext context) => new TorunamentScreen(),
        },
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.grey,
        ),
        home: _handleCurrentScreen(),
      ),
    );
  }

  Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      return new RootScreen();
    } else {
      return new WalkthroughScreen(prefs: prefs);
    }
  }
}
