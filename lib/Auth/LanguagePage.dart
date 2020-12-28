import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Translate/translate.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight(context) / 5,
                  alignment: Alignment.center,
                  child: Text(
                    'Choose Language',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      color: const Color(0xfff9bf2d),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => this.onEnglishPressed(context),
                  child: Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image: AssetImage("assets/usa.png"))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
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
                  onTap: () => this.onArabicPressed(context),
                  child: Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/iraq.png"))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
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
                  onTap: () => this.onPersianPressed(context),
                  child: Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/iran.png"))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
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
                  onTap: () => this.onKurdishSoraniPressed(context),
                  child: Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/KurdistanFlag.png"))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
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
                  onTap: () => this.onKurdishKurmanjiPressed(context),
                  child: Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/KurdistanFlag.png"))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
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
                Container(
                  width: screenWidth(context),
                  height: 40.0,
                  margin:
                      EdgeInsets.only(top: 70, bottom: 15, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xfff9bf2d),
                  ),
                  child: FlatButton(
                    onPressed: () => this.onNextPressed(context, _lang),
                    color: const Color(0xfff9bf2d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "Next",
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
  bool _checkOnEnglishPressed = true;
  bool _checkOnArabicPressed = false;
  bool _checkOnParsianPressed = false;
  bool _checkOnKurdishKurmanjiPressed = false;
  String _language = "en";
  bool _checkOnKurdishSoraniPressed = false;
  void onEnglishPressed(BuildContext context) {
    setState(() {
      _checkOnEnglishPressed = true;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = false;
      _language = "en";
    });
  }

  void onArabicPressed(BuildContext context) {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = true;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = false;
      _language = "ar";
    });
  }

  void onPersianPressed(BuildContext context) {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = true;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = false;
      _language = "per";
    });
  }

  void onKurdishKurmanjiPressed(BuildContext context) {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = true;
      _checkOnKurdishSoraniPressed = false;
      _language = "kuk";
    });
  }

  void onKurdishSoraniPressed(BuildContext context) {
    setState(() {
      _checkOnEnglishPressed = false;
      _checkOnArabicPressed = false;
      _checkOnParsianPressed = false;
      _checkOnKurdishKurmanjiPressed = false;
      _checkOnKurdishSoraniPressed = true;
      _language = "kus";
    });
  }

  void onNextPressed(BuildContext context, _lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang.setLanguage(language["$_language"]);
      prefs.setString('lang', _language);
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreenPage()),
    );
  }
}
