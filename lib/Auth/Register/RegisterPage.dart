import 'dart:convert';
import 'package:bizzcoin_app/Auth/Register/AgentRegister/AgentRegisterPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../AccountVerifyPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool rigisterLoading = false;
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
                          _data["Register"],
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
                  margin: EdgeInsets.only(top: 0),
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
                  margin: EdgeInsets.only(
                    top: screenHeight(context) / 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: screenWidth(context) / 3.2,
                            margin: EdgeInsets.only(right: 5),
                            height: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xffcecece),
                            ),
                            child: TextField(
                              textAlign:
                                  _dir ? TextAlign.left : TextAlign.right,
                              controller: _dir
                                  ? _firstNameController
                                  : _lastNameController,
                              autocorrect: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 8, right: 8),
                                hintText: !_dir
                                    ? _data['LastName']
                                    : _data['FirstName'],
                                hintStyle: GoogleFonts.roboto(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: screenWidth(context) / 3,
                            margin: EdgeInsets.only(left: 2),
                            height: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xffcecece),
                            ),
                            child: TextField(
                              textAlign:
                                  _dir ? TextAlign.left : TextAlign.right,
                              controller: !_dir
                                  ? _firstNameController
                                  : _lastNameController,
                              autocorrect: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 8, right: 8),
                                hintText: _dir
                                    ? _data['LastName']
                                    : _data['FirstName'],
                                hintStyle: GoogleFonts.roboto(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _checkFirstName == true || _checkLastName
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _checkFirstName == true
                                    ? _data['EmptyFirstName']
                                    : _data['EmptyLastName'],
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
                _checkPhone == true
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
                    controller: _emailController,
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data["Email"],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkEmail == true
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
                                "$emailError",
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
                _checkPass == true
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
                              alignment:
                                  _dir ? Alignment.topLeft : Alignment.topRight,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                "$rePassError",
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context) / 1.5,
                  margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                  child: Directionality(
                    textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          child: Checkbox(
                              value: _acceptTerms,
                              activeColor: const Color(0xfff9bf2d),
                              onChanged: (bool newValue) {
                                setState(() {
                                  _acceptTerms = newValue;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () => this.onTermsPressed(context),
                          child: Text(
                            _data['AcceptTerms'],
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: const Color(0xff0c0a0a),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _checkAcceptTerms
                    ? Container(
                        width: screenWidth(context) / 1.5,
                        margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                        child: Text(
                          _data['EmptyTerms'],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 11,
                            color: Colors.red,
                          ),
                          textAlign: _dir ? TextAlign.left : TextAlign.right,
                        ))
                    : Container(),
                !rigisterLoading
                    ? Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff0c0a0a),
                        ),
                        child: FlatButton(
                          onPressed: () =>
                              this.onRegisterPressed(context, _data),
                          color: const Color(0xff0c0a0a),
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
                    : Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 15),
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
                        _data["IamAgent"],
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: const Color(0xff0c0a0a),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => this.onIamAgentPressed(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  bool _checkPhone = false;
  bool _checkPass = false;
  bool _checkRePass = false;
  bool _checkFirstName = false;
  bool _checkLastName = false;
  bool _checkEmail = false;
  String phoneError = "";
  String passError = "";
  String rePassError = "";
  String emailError = "";
  bool _obscureText = true;
  bool _obscureTextRe = true;
  bool _checkAcceptTerms = false;
  bool _acceptTerms = false;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _rePassController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  void onRegisterPressed(BuildContext context, _data) {
    setState(() {
      if (_acceptTerms == false) {
        _checkAcceptTerms = true;
      } else {
        _checkAcceptTerms = false;
      }
    });
    if (_phoneController.text.toString().isEmpty) {
      setState(() {
        _checkPhone = true;
        phoneError = _data['EmptyPhone'];
      });
    } else if (_phoneController.text.toString().length != 11) {
      setState(() {
        _checkPhone = true;
        phoneError = _data['IncorrectPhone'];
      });
    } else {
      setState(() {
        _checkPhone = false;
      });
    }

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

    if (_firstNameController.text.toString().isEmpty) {
      setState(() {
        _checkFirstName = true;
      });
    } else {
      setState(() {
        _checkFirstName = false;
      });
    }

    if (_lastNameController.text.toString().isEmpty) {
      setState(() {
        _checkLastName = true;
      });
    } else {
      setState(() {
        _checkLastName = false;
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
      rePassError = _data['PasswordsNotSame'];
    } else {
      setState(() {
        _checkRePass = false;
      });
    }

    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    if (_emailController.text.toString().isEmpty) {
      setState(() {
        _checkEmail = true;
        emailError = _data['EmptyEmail'];
      });
    } else if (!regExp.hasMatch(_emailController.text.toString())) {
      _checkEmail = true;
      emailError = _data['IncorrectEmail'];
    } else {
      setState(() {
        _checkEmail = false;
      });
    }

    // //Code heare
    if (!_checkEmail &&
        !_checkFirstName &&
        !_checkLastName &&
        !_checkPass &&
        !_checkRePass &&
        !_checkPhone &&
        _acceptTerms) {
      _login();
    }
  }

  void onIamAgentPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgentRegisterPage()),
    );
  }

  _login() async {
    setState(() {
      rigisterLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = RouteApi().routeGet(name: "signup");
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String tk = await PushNotificationService(context: context).token();

    Map json = {
      "first_name": _firstNameController.text.toString(),
      "second_name": _lastNameController.text.toString(),
      "phone": _phoneController.text.toString(),
      "email": _emailController.text.toString(),
      "password": _passController.text.toString(),
      "password_confirmation": _rePassController.text.toString(),
      "notification": tk,
    };
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      prefs.setString('token', body['access_token']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AccountVerifyPage("fromRegisterPage")),
      );
    } else {
      setState(() {
        _checkEmail = body['errors']['email'] == null ? false : true;
        _checkPhone = body['errors']['phone'] == null ? false : true;
        emailError =
            body['errors']['email'] == null ? '' : body['errors']['email'][0];
        phoneError =
            body['errors']['phone'] == null ? '' : body['errors']['phone'][0];
      });
    }
    setState(() {
      rigisterLoading = false;
    });
  }

  Future<void> onTermsPressed(BuildContext context) async {
    if (await canLaunch(RouteApi().main_url + 'terms-and-conditions')) {
      await launch(RouteApi().main_url + 'terms-and-conditions');
    } else {
      throw 'Could not launch 07511183226';
    }
  }
}
