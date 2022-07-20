import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/page/home.dart';
import 'package:flutter_application_2/page/login.dart';
import 'package:flutter_application_2/provider/auth_prover.dart';
import 'package:flutter_application_2/provider/data_provider.dart';
import 'package:flutter_application_2/routes/page_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DataProvider>(
            create: (context) => DataProvider(),
            update: (context, auth, data) =>
                data!..getDataAuh(auth.tokenId, auth.userId))
      ],
      child: MyApp(),
    ));

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  Future<Widget> _isAuth(bool isAuth) async {
    final prefs = await SharedPreferences.getInstance();
    final dateData = prefs.getString("expireDate");

    if (isAuth) {
      return Home();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
            body: auth.isAuth
                ? Home()
                : FutureBuilder(
                    future: auth.getData(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      return LoginScreen();
                    }));
      },
    );
  }
}
