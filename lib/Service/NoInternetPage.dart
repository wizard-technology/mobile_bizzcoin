import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Translate/translate.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoInternetPage extends StatefulWidget {
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  _NoInternetPageState() {
    getData();
  }
  var _language;
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('lang').toString();
    });
  }

  Map _data;
//  bool _dir;
  @override
  Widget build(BuildContext context) {
    if (_language != null) {
      final _lang = Provider.of<LanguageService>(context);
      _lang.setLanguage(language[_language]);
    }
      final _lang = Provider.of<LanguageService>(context);
      _data = _lang.getLanguage()['data'];
      // _dir = _lang.getLanguage()['dir'];
    

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth(context) / 2.6,
                height: screenHeight(context) / 2.6,
                margin: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                    color: const Color(0xfff9bf2d), shape: BoxShape.circle),
                child: Center(
                  child: Container(
                    width: screenWidth(context) / 5,
                    height: screenHeight(context) / 10,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/NoInternetIcon.png"))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  _data["NoInternet"],
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: screenHeight(context) / 30,
                    color: const Color(0xff0c0a0a),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  _data['CouldnotConnectInternet'],
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: screenHeight(context) / 35,
                    color: const Color(0xff0c0a0a),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Text(
                  _data['CheckNetwork'],
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: screenHeight(context) / 35,
                    color: const Color(0xff0c0a0a),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
