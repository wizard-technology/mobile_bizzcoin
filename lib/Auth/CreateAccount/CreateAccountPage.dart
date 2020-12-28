import 'package:bizzcoin_app/Auth/Login/LoginPage.dart';
import 'package:bizzcoin_app/Auth/Register/RegisterPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CheckInternetWidget(
        Container(
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
                      child: Center(
                        child: Icon(
                          FeatherIcons.userPlus,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    _data['CreateAnAccount'],
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
                  child: Text(
                    _data['ToStartShopping'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: screenHeight(context) / 35,
                      color: const Color(0xff0c0a0a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 40.0,
                  margin: EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xfff9bf2d),
                  ),
                  child: FlatButton(
                    onPressed: () => this.onCreateAccountPressed(context),
                    color: const Color(0xfff9bf2d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Text(
                      _data["CreateAccount"],
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: CupertinoButton(
                      child: Text(
                        _data["Login"],
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: const Color(0xff0c0a0a),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => this.onLoginPressed(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreateAccountPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void onLoginPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
