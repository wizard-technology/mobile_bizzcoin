import 'dart:convert';

import 'package:bizzcoin_app/Auth/AccountVerifyPage.dart';
import 'package:bizzcoin_app/Auth/ForgotPassword/ForgotpasswordPage.dart';
import 'package:bizzcoin_app/Auth/Register/AgentRegister/AgentPendingAccountPage.dart';
import 'package:bizzcoin_app/Auth/Register/RegisterPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/AgentMainScreen/AgentMainScreen.dart';
import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginLoading = false;
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
                          _data['Login'],
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
                          width: _dir ? 5 : 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: screenWidth(context) / 3,
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
                  margin: EdgeInsets.only(top: 2),
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
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: screenHeight(context) / 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      // ignore: deprecated_member_use
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data['PhoneNumber'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _chekPhone == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                "$phoneError",
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _passController,
                    autocorrect: false,
                    autofocus: false,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 8, right: 8, top: _dir ? 13 : 8),
                      hintText: _data["Password"],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                      suffixIcon: _dir
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText == false
                                      ? _obscureText = true
                                      : _obscureText = false;
                                });
                              },
                              child: Icon(
                                _obscureText == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            )
                          : null,
                      prefixIcon: !_dir
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText == false
                                      ? _obscureText = true
                                      : _obscureText = false;
                                });
                              },
                              child: Icon(
                                _obscureText == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                _chekPass == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              alignment:
                                  _dir ? Alignment.topLeft : Alignment.topRight,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                "$passError",
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                !loginLoading
                    ? Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff0c0a0a),
                        ),
                        child: FlatButton(
                          onPressed: () => this.onLoginPressed(context, _data),
                          color: const Color(0xff0c0a0a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          child: Text(
                            _data["Login"],
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff0c0a0a),
                        ),
                        child: Center(
                            child: Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.black,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ))),
                Container(
                  child: CupertinoButton(
                      child: Text(
                        _data["ForgotPassword"] +
                            "" +
                            (_dir ? " ?" : " ؟").toString(),
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: const Color(0xff0c0a0a),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => this.onForgotPressed(context)),
                ),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 40.0,
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xfff9bf2d),
                  ),
                  child: FlatButton(
                    onPressed: () => this.onRegisterPressed(context),
                    color: const Color(0xfff9bf2d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Text(
                      _data["Register"],
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  bool _chekPhone = false;
  bool _chekPass = false;
  String phoneError = "";
  String passError = "";
  bool _obscureText = true;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  void onLoginPressed(BuildContext context, _data) {
    if (_passController.text.toString().isEmpty) {
      setState(() {
        _chekPass = true;
        passError = _data['EmptyPassword'];
      });
    }
    if (_phoneController.text.toString().isEmpty) {
      setState(() {
        _chekPhone = true;
        phoneError = _data['EmptyPhone'];
      });
    } else if (_phoneController.text.toString().length != 11) {
      setState(() {
        _chekPhone = true;
        phoneError = _data['IncorrectPhone'];
      });
    } else {
      setState(() {
        _chekPhone = false;
      });
    }

    if (_passController.text.toString().isEmpty) {
      setState(() {
        _chekPass = true;
      });
    } else {
      setState(() {
        _chekPass = false;
      });
    }
    if (!_chekPass && !_chekPhone) _login(_data);
  }

  void onForgotPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  void onRegisterPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  _login(_data) async {
    setState(() {
      loginLoading = true;
    });
    String url = RouteApi().routeGet(name: "login");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String tk = await PushNotificationService(context: context).token();
    Map json = {
      "phone": _phoneController.text.toString(),
      "password": _passController.text.toString(),
      "notification": tk,
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      if (body['role'] == 'USER') {
        if (int.parse(body['state'].toString()) == 0) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', _phoneController.text.toString());
          _saveToken(token: body['access_token']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountVerifyPage("fromRegisterPage"),
            ),
          );
        } else if (int.parse(body['state'].toString()) == 1) {
          _saveToken(token: body['access_token']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreenPage(),
            ),
          );
        } else if (int.parse(body['state'].toString()) == 2) {
          setState(() {
            _chekPhone = true;
            phoneError = _data['SuspendedAccount'];
          });
        }
      } else {
        if (int.parse(body['state'].toString()) == 0) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', _phoneController.text.toString());
          _saveToken(token: body['access_token']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgentPendingAccountPage(),
            ),
          );
        } else if (int.parse(body['state'].toString()) == 1) {
          _saveToken(token: body['access_token']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgentMainScreenPage(),
            ),
          );
        } else if (int.parse(body['state'].toString()) == 2) {
          setState(() {
            _chekPhone = true;
            phoneError = _data['SuspendedAccount'];
          });
        }
      }
    } else {
      setState(() {
        _chekPass = true;
        passError = _data['WrongPassword'];
      });
    }

    setState(() {
      loginLoading = false;
    });
  }

  _saveToken({token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
