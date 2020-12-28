import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'UploadImagePage.dart';

class AgentRegisterPage extends StatefulWidget {
  @override
  _AgentRegisterPageState createState() => _AgentRegisterPageState();
}

class _AgentRegisterPageState extends State<AgentRegisterPage> {
  bool rigisterLoading = false;
  @override
  void initState() {
    super.initState();
    futureCity = fetchCity();
  }

  @override
  Widget build(BuildContext context) {
    // rigisterLoading = false;
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
                          _data["AgentRegister"],
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
                  height: 45.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _nameController,
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data['Name'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkName == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _data['EmptyName'],
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
                  child: Directionality(
                    textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                    child: FutureBuilder<List<CityModel>>(
                      future: futureCity,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton(
                            underline: Container(),
                            value: _selectedCityList,
                            isExpanded: true,
                            icon: Padding(
                              padding: EdgeInsets.only(
                                  right: _dir ? 12 : 0, left: !_dir ? 12 : 0),
                              child: Icon(FeatherIcons.chevronDown),
                            ),
                            items: snapshot.data
                                .map((code) => new DropdownMenuItem(
                                    value: code.id,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: _dir ? 14 : 14,
                                          left: _dir ? 8 : 14),
                                      child: Container(
                                          alignment: _dir
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: new Text(code.name)),
                                    )))
                                .toList(),
                            onChanged: (change) {
                              setState(() {
                                _selectedCityList = change;
                              });
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                                height: 10,
                                width: 10,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                _checkCity == true
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
                                "$cityError",
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
                    controller: _streetController,
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data['Street'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkStreet == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _data['EmptyStreet'],
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 85.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _descriptionController,
                    autocorrect: false,
                    autofocus: false,
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 8, right: 8, top: 5),
                      hintText: _data['Description'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkDescription == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _data['EmptyDescription'],
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
                !rigisterLoading
                    ? Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 15, bottom: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  Future<List<CityModel>> futureCity;

  int _selectedCityList = 0;
  bool _checkPhone = false;
  bool _checkCity = false;
  bool _checkPass = false;
  bool _checkRePass = false;
  bool _checkName = false;
  bool _checkEmail = false;
  bool _checkStreet = false;
  bool _checkDescription = false;
  String phoneError = "";
  String passError = "";
  String rePassError = "";
  String emailError = "";
  String cityError = "";

  bool _obscureText = true;
  bool _obscureTextRe = true;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _rePassController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  void onRegisterPressed(BuildContext context, _data) {
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
    if (_selectedCityList == 0) {
      setState(() {
        _checkCity = true;
        cityError = _data['EmptyPassword'];
      });
    }
    if (_descriptionController.text.toString().isEmpty) {
      setState(() {
        _checkDescription = true;
      });
    } else {
      setState(() {
        _checkDescription = false;
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

    if (_nameController.text.toString().isEmpty) {
      setState(() {
        _checkName = true;
      });
    } else {
      setState(() {
        _checkName = false;
      });
    }

    if (_streetController.text.toString().isEmpty) {
      setState(() {
        _checkStreet = true;
      });
    } else {
      setState(() {
        _checkStreet = false;
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

//Code heare
    if (!_checkEmail &&
        !_checkName &&
        !_checkStreet &&
        !_checkPass &&
        !_checkRePass &&
        !_checkPhone) {
      _register();
    }
  }

  Future<List<CityModel>> fetchCity() async {
    List<CityModel> str = [CityModel(id: 0, name: "City")];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _language = prefs.getString('lang').toString();
    final response =
        await http.get(RouteApi().routeGet(name: "city", type: 'company'));
    if (response.statusCode == 200) {
      jsonDecode(response.body)['city'].forEach((element) {
        if (_language == 'kus') {
          str.add(CityModel(id: element['id'], name: element['ct_name_ku']));
        } else if (_language == 'en') {
          str.add(CityModel(id: element['id'], name: element['ct_name']));
        } else if (_language == 'per') {
          str.add(CityModel(id: element['id'], name: element['ct_name_pr']));
        } else if (_language == 'ar') {
          str.add(CityModel(id: element['id'], name: element['ct_name_ar']));
        } else if (_language == 'kuk') {
          str.add(CityModel(id: element['id'], name: element['ct_name_kr']));
        }
      });
      return str;
    } else {
      throw Exception('Failed to load Channel');
    }
  }

  _register() async {
    setState(() {
      rigisterLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = RouteApi().routeGet(name: "register", type: 'company');
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String tk = await PushNotificationService(context: context).token();
    print(tk);
    Map json = {
      "company_name": _nameController.text.toString(),
      "phone_account": _phoneController.text.toString(),
      "email": _emailController.text.toString(),
      "password": _passController.text.toString(),
      "password_confirmation": _rePassController.text.toString(),
      "address": _streetController.text.toString(),
      "city": _selectedCityList.toString(),
      "information": _descriptionController.text.toString(),
      "notification": tk,
    };

    final response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    print(body);
    if (statusCode == 200) {
      prefs.setString('token', body['access_token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UploadImagePage()),
      );
    } else {}
    setState(() {
      rigisterLoading = false;
    });
  }
}

class CityModel {
  final id, name;

  CityModel({@required this.id, @required this.name});
}
