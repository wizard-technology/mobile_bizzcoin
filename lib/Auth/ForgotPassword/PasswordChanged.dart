import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordChangedPage extends StatefulWidget {
  @override
  _PasswordChangedPageState createState() => _PasswordChangedPageState();
}

class _PasswordChangedPageState extends State<PasswordChangedPage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {},
        child: Scaffold(
          backgroundColor: const Color(0xfff2f3f6),
          body: CheckInternetWidget(
            SafeArea(
              child: Container(
                width: screenWidth(context),
                height: screenHeight(context),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth(context) / 2.6,
                        height: screenHeight(context) / 2.6,
                        margin: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            color: const Color(0xfff9bf2d),
                            shape: BoxShape.circle),
                        child: Center(
                            child: Icon(
                          FeatherIcons.check,
                          size: screenHeight(context) / 8,
                          color: Colors.white,
                        )),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 12),
                        child: Text(
                          _data['PasswordChanged'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: screenHeight(context) / 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth(context) / 1.4,
                        height: screenHeight(context) / 18,
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 4.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xfff9bf2d),
                        ),
                        child: FlatButton(
                          onPressed: () => this.onStartShoppingPressed(context),
                          color: const Color(0xfff9bf2d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          child: Text(
                            _data['StartShopping'],
                            style: GoogleFonts.roboto(
                                fontSize: screenHeight(context) / 37,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  //---------------------Methods---------------------//
  void onStartShoppingPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreenPage()),
    );
  }
}
