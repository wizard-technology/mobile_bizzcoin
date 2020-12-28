import 'package:bizzcoin_app/Enum/connectivty_status.dart';
import 'package:bizzcoin_app/Service/connectivity.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Translate/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Screen/SplashScreen/SplashScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor:
            const Color(0xff0c0a0a), // navigation bar color
        statusBarColor: Color.fromARGB(255, 249, 186, 28) // status bar color
        ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageService>(
            create: (_) => LanguageService(language['english'])),
        StreamProvider<ConnectivityStatus>(
          create: (_) =>
              ConnectivityService().connectionStatusController.stream,
        ),
      ],
      child: MaterialAppWithProvider(),
    );
  }
}

class MaterialAppWithProvider extends StatefulWidget {
  @override
  _MaterialAppWithProviderState createState() =>
      _MaterialAppWithProviderState();
}

class _MaterialAppWithProviderState extends State<MaterialAppWithProvider> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color.fromARGB(255, 249, 186, 28),
      title: 'BizzPayment',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 249, 186, 28),
        accentColor: Color.fromARGB(255, 249, 186, 28),
        disabledColor: Color.fromARGB(255, 249, 186, 28),
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          iconTheme: IconTheme.of(context),
        ),
      ),
      home: SplashScreenPage(),
    );
  }
}
