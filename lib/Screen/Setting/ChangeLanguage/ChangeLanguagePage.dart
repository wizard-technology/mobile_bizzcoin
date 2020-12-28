import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Translate/translate.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguagePage extends StatefulWidget {
  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: CheckInternetWidget(
        SafeArea(
          child: Container(
            width: screenWidth(context),
            height: screenHeight(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    _dir ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 150,
                    margin: EdgeInsets.only(
                        top: screenHeight(context) / 40, bottom: 50),
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
                            _data['language'],
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
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => this.onEnglishPressed(context, _lang),
                    child: Container(
                      width: screenWidth(context),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image:
                                                AssetImage("assets/usa.png"))),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "English",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _checkOnEnglishPressed == true
                                ? Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                        color: const Color(0xfff9bf2d),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(
                                      FeatherIcons.check,
                                      color: Colors.white,
                                      size: 33,
                                    )))
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => this.onArabicPressed(context, _lang),
                    child: Container(
                      width: screenWidth(context),
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image:
                                                AssetImage("assets/iraq.png"))),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "Arabic",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _checkOnArabicPressed == true
                                ? Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                        color: const Color(0xfff9bf2d),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(
                                      FeatherIcons.check,
                                      color: Colors.white,
                                      size: 33,
                                    )))
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => this.onPersianPressed(context, _lang),
                    child: Container(
                      width: screenWidth(context),
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image:
                                                AssetImage("assets/iran.png"))),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "Persian",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _checkOnParsianPressed == true
                                ? Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                        color: const Color(0xfff9bf2d),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(
                                      FeatherIcons.check,
                                      color: Colors.white,
                                      size: 33,
                                    )))
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => this.onKurdishSoraniPressed(context, _lang),
                    child: Container(
                      width: screenWidth(context),
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/KurdistanFlag.png"))),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "Kurdish(Sorani)",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _checkOnKurdishSoraniPressed == true
                                ? Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                        color: const Color(0xfff9bf2d),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(
                                      FeatherIcons.check,
                                      color: Colors.white,
                                      size: 33,
                                    )))
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => this.onKurdishKurmanjiPressed(context, _lang),
                    child: Container(
                      width: screenWidth(context),
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 70.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/KurdistanFlag.png"))),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      "Kurdish(Kurmanji)",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _checkOnKurdishKurmanjiPressed == true
                                ? Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                        color: const Color(0xfff9bf2d),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(
                                      FeatherIcons.check,
                                      color: Colors.white,
                                      size: 33,
                                    )))
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//---------------------Methods---------------------//
  bool _checkOnEnglishPressed = false;
  bool _checkOnArabicPressed = false;
  bool _checkOnParsianPressed = false;
  bool _checkOnKurdishKurmanjiPressed = false;
  bool _checkOnKurdishSoraniPressed = false;
  void onEnglishPressed(BuildContext context, lang) async {
    setState(() {
      _checkOnEnglishPressed = true;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', "en");
    lang.setLanguage(language["en"]);
  }

  void onArabicPressed(BuildContext context, lang) async {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = true;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', "ar");
    lang.setLanguage(language["ar"]);
  }

  void onPersianPressed(BuildContext context, lang) async {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = true;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', "per");
    lang.setLanguage(language["per"]);
  }

  void onKurdishKurmanjiPressed(BuildContext context, lang) async {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = true;
      _checkOnKurdishSoraniPressed = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', "kuk");
    lang.setLanguage(language["kuk"]);
  }

  void onKurdishSoraniPressed(BuildContext context, lang) async {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', "kus");
    lang.setLanguage(language["kus"]);
  }

  void getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    setState(() {
      if (prefs.getString('lang') == 'kus') {
        _checkOnKurdishSoraniPressed = true;
      } else if (prefs.getString('lang') == 'kuk') {
        _checkOnKurdishKurmanjiPressed = true;
      } else if (prefs.getString('lang') == 'per') {
        _checkOnParsianPressed = true;
      } else if (prefs.getString('lang') == 'ar') {
        _checkOnArabicPressed = true;
      } else {
        _checkOnEnglishPressed = true;
      }
    });
  }
}
