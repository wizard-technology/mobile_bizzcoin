import 'dart:convert';

import 'package:bizzcoin_app/Auth/ForgotPassword/PasswordChanged.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool changeLoading = false;
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
                              _data["NewPassword"],
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
                      width: screenWidth(context) / 1.5,
                      height: 45.0,
                      margin: EdgeInsets.only(top: screenHeight(context) / 6),
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
                    _checkPass == true
                        ? Align(
                            alignment:
                                _dir ? Alignment.topLeft : Alignment.topRight,
                            child: Center(
                              child: Container(
                                  width: screenWidth(context) / 1.5,
                                  alignment: _dir
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  margin: EdgeInsets.only(
                                      top: 5, left: 0, right: 0),
                                  child: Text(
                                    "$passError",
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
                        controller: _rePassController,
                        autocorrect: false,
                        autofocus: false,
                        obscureText: _obscureTextRe,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 8, right: 8, top: _dir ? 13 : 8),
                          hintText: _data["ConfirmPassword"],
                          hintStyle: GoogleFonts.roboto(fontSize: 15),
                          suffixIcon: _dir
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureTextRe == false
                                          ? _obscureTextRe = true
                                          : _obscureTextRe = false;
                                    });
                                  },
                                  child: Icon(
                                    _obscureTextRe == false
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
                                      _obscureTextRe == false
                                          ? _obscureTextRe = true
                                          : _obscureTextRe = false;
                                    });
                                  },
                                  child: Icon(
                                    _obscureTextRe == false
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    _checkRePass == true
                        ? Align(
                            alignment:
                                _dir ? Alignment.topLeft : Alignment.topRight,
                            child: Center(
                              child: Container(
                                  width: screenWidth(context) / 1.5,
                                  alignment: _dir
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  margin: EdgeInsets.only(
                                      top: 5, left: 0, right: 0),
                                  child: Text(
                                    "$rePassError",
                                    textAlign:
                                        _dir ? TextAlign.left : TextAlign.right,
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ))
                        : SizedBox(),
                    !changeLoading
                        ? Container(
                            width: screenWidth(context) / 1.5,
                            height: 40.0,
                            margin: EdgeInsets.only(top: 25, bottom: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xff0c0a0a),
                            ),
                            child: FlatButton(
                              onPressed: () =>
                                  this.onChangePressed(context, _data),
                              color: const Color(0xfff9bf2d),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              textColor: Colors.white,
                              padding: EdgeInsets.all(0),
                              child: Text(
                                _data["Change"],
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
                            margin: EdgeInsets.only(top: 25, bottom: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xff0c0a0a),
                            ),
                            child: Center(
                                child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: const Color(0xfff9bf2d),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )),
                          ),
                  ]))),
        ));
  }

  //---------------------Methods---------------------//
  bool _checkPass = false;
  bool _checkRePass = false;
  String passError = "";
  String rePassError = "";
  bool _obscureText = true;
  bool _obscureTextRe = true;
  TextEditingController _passController = new TextEditingController();
  TextEditingController _rePassController = new TextEditingController();
  void onChangePressed(BuildContext context, _data) {
    if (_passController.text.toString().isEmpty) {
      setState(() {
        _checkPass = true;
        passError = _data['EmptyPassword'];
      });
    } else if (_passController.text.toString().length < 8) {
      _checkPass = true;
      passError = _data['SmallPassword'];
    } else {
      setState(() {
        _checkPass = false;
      });
    }

    if (_rePassController.text.toString().isEmpty) {
      setState(() {
        _checkRePass = true;
        rePassError = _data['EmptyRe-password'];
      });
    } else if (_rePassController.text.toString() !=
        _passController.text.toString()) {
      _checkRePass = true;
      rePassError = _data['PasswordsNotSamePasswordsNotSame'];
    } else {
      setState(() {
        _checkRePass = false;
      });
    }

    //Code heare
    if (!_checkPass && !_checkRePass) {
      _resetPassword();
    }
  }

  _resetPassword() async {
    setState(() {
      changeLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = RouteApi().routeGet(name: "change_password");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String tk = await PushNotificationService(context: context).token();

    Map json = {
      "phone": prefs.getString('phone'),
      "code": prefs.getString('code'),
      "password": _passController.text.toString(),
      "password_confirmation": _rePassController.text.toString(),
      "notification": tk,
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      prefs.remove('phone');
      prefs.remove('code');
      prefs.setString('token', body['access_token']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasswordChangedPage()),
      );
    } else {}
    setState(() {
      changeLoading = false;
    });
  }
}
