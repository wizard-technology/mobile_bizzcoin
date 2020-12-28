import 'dart:convert';

import 'package:bizzcoin_app/Auth/AccountVerifyPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool sendLoading = false;
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
                          _data['ForgotPassword'],
                          textDirection:
                              _dir ? TextDirection.ltr : TextDirection.rtl,
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: screenWidth(context) / 1.5,
                    margin: EdgeInsets.only(top: screenHeight(context) / 8),
                    child: Text(
                      _data['PhoneSendChangePassword'],
                      textDirection:
                          !_dir ? TextDirection.ltr : TextDirection.rtl,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                        fontFamily: ".SF NS Text",
                      ),
                      textAlign: _dir ? TextAlign.left : TextAlign.right,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: 15),
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
                      hintText: _data["PhoneNumber"],
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
                !sendLoading
                    ? Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xfff9bf2d),
                        ),
                        child: FlatButton(
                          onPressed: () =>
                              this.onSendCodePressed(context, _data),
                          color: const Color(0xfff9bf2d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          child: Text(
                            _data['SendCode'],
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
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xfff9bf2d),
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
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  bool _chekPhone = false;
  String phoneError = "";
  TextEditingController _phoneController = new TextEditingController();
  void onSendCodePressed(BuildContext context, _data) {
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
      if (!_chekPhone) {
        _sendPhone(_data);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AccountVerifyPage("fromForgotPage")),
        );
      }
    }
  }

  _sendPhone(_data) async {
    setState(() {
      sendLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = RouteApi().routeGet(name: "forget");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Map json = {
      "phone": _phoneController.text.toString(),
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      prefs.setString('phone', _phoneController.text.toString());
    } else {
      setState(() {
        _chekPhone = true;
        phoneError = _data['IncorrectPhone'];
      });
    }
    setState(() {
      sendLoading = false;
    });
  }
}
