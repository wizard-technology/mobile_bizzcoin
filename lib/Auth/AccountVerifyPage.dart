import 'dart:convert';

import 'package:bizzcoin_app/Auth/ForgotPassword/NewPasswordPage.dart';
import 'package:bizzcoin_app/Auth/Register/AccountCreated.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AccountVerifyPage extends StatefulWidget {
  final _from;
  AccountVerifyPage(this._from);
  @override
  _AccountVerifyPageState createState() => _AccountVerifyPageState(this._from);
}

class _AccountVerifyPageState extends State<AccountVerifyPage> {
  String _from;
  _AccountVerifyPageState(this._from);
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: CheckInternetWidget(
        Container(
            width: screenWidth(context),
            height: screenHeight(context),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: screenHeight(context) / 20),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: _dir
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          _dir ? Icon(CupertinoIcons.back) : Container(),
                          SizedBox(
                            width: _dir ? 5 : 0,
                          ),
                          Text(
                            _data["SendCode"],
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: const Color(0xff0c0a0a),
                                fontWeight: FontWeight.w700,
                                fontSize: 19),
                            textAlign: TextAlign.center,
                          ),
                          !_dir
                              ? Icon(
                                  CupertinoIcons.back,
                                  textDirection: TextDirection.rtl,
                                )
                              : Container(),
                          SizedBox(
                            width: !_dir ? 5 : 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth(context) / 2.6,
                    height: screenHeight(context) / 2.6,
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                        color: const Color(0xfff9bf2d), shape: BoxShape.circle),
                    child: Center(
                      child: Container(
                        width: screenWidth(context) / 4,
                        height: screenHeight(context) / 4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage("assets/phoneAuth.png"))),
                      ),
                    ),
                  ),
                  Text(
                    _data["Verification"],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: screenHeight(context) / 19,
                      color: const Color(0xff0c0a0a),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      _data['Sended4DigitCode'],
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: screenHeight(context) / 40,
                        color: const Color(0xff0c0a0a),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: screenWidth(context) / 1.5,
                    margin: EdgeInsets.only(top: 25),
                    child: PinFieldAutoFill(
                      decoration: BoxTightDecoration(
                        strokeColor: Colors.grey,
                        radius: Radius.circular(5.0),
                        strokeWidth: 0.8,
                      ),

                      currentCode: "", //auto complite
                      onCodeChanged: (string) =>
                          this.onCodeDone(context, string),
                      codeLength: 4,
                      keyboardType: TextInputType.number,
                    ),
                    color: _checkCode ? Colors.red[200] : Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: CupertinoButton(
                        child: Text(
                          _data["ResendCode"],
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => this.onResendPressed(context)),
                  ),
                ]))),
      ),
    );
  }

//---------------------Methods---------------------//
  bool _checkCode = false;
  void onResendPressed(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = RouteApi().routeGet(name: "forget");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Map json = {
      "phone": "${prefs.getString('phone')}",
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
    } else {}
  }

  void onCodeDone(BuildContext context, string) {
    if (string.toString().length == 4) {
      if (_from == "fromForgotPage") {
        _sendPhone(context, string);
      } else {
        _verify(context, string);
      }
    }
  }

  _verify(context, string) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "verify");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map json = {
      "code": string.toString(),
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountCreatedPage()),
      );
    } else {
      setState(() {
        _checkCode = true;
      });
    }
  }

  _sendPhone(context, string) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = RouteApi().routeGet(name: "verify_reset_password");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Map json = {
      "phone": prefs.getString('phone'),
      "code": string.toString(),
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      prefs.setString('code', string.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPasswordPage()),
      );
    } else {
      setState(() {
        _checkCode = true;
      });
    }
  }
}
