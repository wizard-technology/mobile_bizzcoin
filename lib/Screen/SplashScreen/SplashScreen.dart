import 'dart:async';
import 'dart:convert';
import 'package:bizzcoin_app/Auth/LanguagePage.dart';
import 'package:bizzcoin_app/Auth/Register/AgentRegister/AgentPendingAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/AgentMainScreen/AgentMainScreen.dart';
import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/Translate/translate.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Widget error;
  String _language;
  @override
  void initState() {
    PushNotificationService(context: context).initialise();
    appStop().then((v) {
      if (v == null) {
        RouteApi().getLanguage().then((value) async {
          if (value == null) {
            Timer(
              Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => LanguagePage(),
                ),
              ),
            );
          } else {
            isCompany(context).then((isCom) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                _language = prefs.getString('lang').toString();
              });
              Timer(
                Duration(seconds: 3),
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => isCom == "COMPANY"
                        ? AgentMainScreenPage()
                        : MainScreenPage(),
                  ),
                ),
              );
            });
          }
        });
      } else {
        setState(() {
          error = Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "$v ...",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_language != null) {
      final _lang = Provider.of<LanguageService>(context);
      _lang.setLanguage(language[_language]);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: screenWidth(context) / 2.5,
              height: screenHeight(context) / 4,
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/BizzPaymentlogo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Bizz Payment',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: screenHeight(context) / 21,
                  color: const Color(0xff0c0a0a),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future appStop() async {
  String url = RouteApi().routeGet(name: "signup");
  Map<String, String> headers = {
    'Accept': 'application/json',
  };
  Response response = await post(url, headers: headers);
  int statusCode = response.statusCode;
  Map body = jsonDecode(response.body);
  if (statusCode == 401) {
    return body['errors'][0];
  }
  return null;
}

Future isCompany(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  String url = RouteApi().routeGet(name: "profile", type: 'company');
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  Response response = await get(url, headers: headers);
  int statusCode = response.statusCode;
  Map body = jsonDecode(response.body);
  if (statusCode == 200) {
    if (body['u_state'] == 1) {
      return "COMPANY";
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AgentPendingAccountPage()),
      );
    }
  }
  return null;
}
