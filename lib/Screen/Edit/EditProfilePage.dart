import 'dart:convert';

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

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: !loading
          ? CheckInternetWidget(
              SafeArea(
                child: Container(
                  width: screenWidth(context),
                  height: screenHeight(context),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth(context),
                          margin:
                              EdgeInsets.only(top: screenHeight(context) / 30),
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
                                  _data["EditAccount"],
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
                          margin: EdgeInsets.only(
                            top: screenHeight(context) / 10,
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
                                      textAlign: _dir
                                          ? TextAlign.left
                                          : TextAlign.right,
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
                                            : _data["FirstName"],
                                        hintStyle:
                                            GoogleFonts.roboto(fontSize: 15),
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
                                      textAlign: _dir
                                          ? TextAlign.left
                                          : TextAlign.right,
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
                                            : _data["FirstName"],
                                        hintStyle:
                                            GoogleFonts.roboto(fontSize: 15),
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
                                alignment: _dir
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Center(
                                  child: Container(
                                      width: screenWidth(context) / 1.5,
                                      margin: EdgeInsets.only(
                                          top: 5, left: 0, right: 0),
                                      child: Text(
                                        _checkFirstName == true
                                            ? _data['EmptyFirstName']
                                            : _data['EmptyLastName'],
                                        textAlign: _dir
                                            ? TextAlign.left
                                            : TextAlign.right,
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
                            readOnly: true,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 8, right: 8),
                              hintText: _data["PhoneNumber"],
                              hintStyle: GoogleFonts.roboto(fontSize: 15),
                            ),
                          ),
                        ),
                        _checkPhone == true
                            ? Align(
                                alignment: _dir
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Center(
                                  child: Container(
                                      width: screenWidth(context) / 1.5,
                                      margin: EdgeInsets.only(
                                          top: 5, left: 0, right: 0),
                                      child: Text(
                                        "$phoneError",
                                        textAlign: _dir
                                            ? TextAlign.left
                                            : TextAlign.right,
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
                              contentPadding:
                                  EdgeInsets.only(left: 8, right: 8),
                              hintText: _data["Email"],
                              hintStyle: GoogleFonts.roboto(fontSize: 15),
                            ),
                          ),
                        ),
                        _checkEmail == true
                            ? Align(
                                alignment: _dir
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Center(
                                  child: Container(
                                      width: screenWidth(context) / 1.5,
                                      alignment: _dir
                                          ? Alignment.topLeft
                                          : Alignment.topRight,
                                      margin: EdgeInsets.only(
                                          top: 5, left: 0, right: 0),
                                      child: Text(
                                        "$emailError",
                                        textAlign: _dir
                                            ? TextAlign.left
                                            : TextAlign.right,
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ))
                            : SizedBox(),
                        !updateLoading
                            ? Container(
                                width: screenWidth(context) / 1.5,
                                height: 40.0,
                                margin: EdgeInsets.only(top: 35),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Color.fromARGB(255, 249, 186, 28),
                                ),
                                child: FlatButton(
                                  onPressed: () =>
                                      this.onUpdatePressed(context, _data),
                                  color: Color.fromARGB(255, 249, 186, 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    _data["Update"],
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
                                  color: Color.fromARGB(255, 249, 186, 28),
                                ),
                                child: Center(
                                    child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 249, 186, 28),
                                    ),
                                  ),
                                ))),
                        _checkErrorHandler
                            ? Center(
                                child: Container(
                                  width: screenWidth(context) / 1.5,
                                  margin: EdgeInsets.only(
                                      top: 5, left: 0, right: 0),
                                  child: Center(
                                    child: Text(
                                      "$errorHandler",
                                      style: TextStyle(
                                          color: _checkErrorHandlerCol
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                backgroundColor: const Color(0xfff2f3f6),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            )),
    );
  }

  //---------------------Methods---------------------//
  bool _checkPhone = false;
  bool _checkFirstName = false;
  bool _checkLastName = false;
  bool _checkEmail = false;
  bool _checkErrorHandler = false;
  bool _checkErrorHandlerCol = false;
  String passError = "";
  String phoneError = "";
  String rePassError = "";
  String emailError = "";
  String errorHandler = "";
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  // bool _obscureText = true;
  bool updateLoading = false;
  @override
  void initState() {
    super.initState();
    _getAccount();
  }

  void onUpdatePressed(BuildContext context, _data) {
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

    //Code heare
    if (!_checkEmail && !_checkFirstName && !_checkLastName && !_checkPhone) {
      setState(() {
        updateLoading = true;
      });
      _updateInfo();
    }
  }

  _getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "profile");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    if (statusCode == 200) {
      setState(() {
        _emailController.text = body['u_email'];
        _firstNameController.text = body['u_first_name'];
        _lastNameController.text = body['u_second_name'];
        _phoneController.text = body['u_phone'];
      });
    }

    setState(() {
      loading = false;
    });
  }

  _updateInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "update");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map json = {
      "first_name": _firstNameController.text.toString(),
      "second_name": _lastNameController.text.toString(),
      "email": _emailController.text.toString()
    };
    Response response = await put(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    if (statusCode == 200) {
      setState(() {
        _checkErrorHandlerCol = false;
        _checkErrorHandler = true;
        errorHandler = body['message'];
      });
    } else {
      setState(() {
        _checkEmail = body['errors']['email'] == null ? false : true;
        passError = body['errors']['password'] == null
            ? ''
            : body['errors']['password'];
        emailError =
            body['errors']['email'] == null ? '' : body['errors']['email'][0];

        errorHandler = '';
      });
    }
    setState(() {
      updateLoading = false;
    });
    print(body);
  }
}
