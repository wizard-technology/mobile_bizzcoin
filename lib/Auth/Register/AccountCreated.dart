import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountCreatedPage extends StatefulWidget {
  @override
  _AccountCreatedPageState createState() => _AccountCreatedPageState();
}

class _AccountCreatedPageState extends State<AccountCreatedPage> {
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
                          FeatherIcons.userCheck,
                          size: 60,
                        )),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 25),
                        child: Text(
                          _data['AccountReady'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: screenHeight(context) / 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
              width: screenWidth(context),
              height: screenHeight(context) / 3,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 186, 28),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Center(
                child: Container(
                  width: screenWidth(context) / 1.4,
                  height: screenHeight(context) / 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xfff2f3f6),
                  ),
                  child: FlatButton(
                    onPressed: () => this.onStartShoppingPressed(context),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    textColor: Colors.black,
                    padding: EdgeInsets.all(0),
                    child: Text(
                      _data["StartShopping"],
                      style: GoogleFonts.roboto(
                          fontSize: screenHeight(context) / 37,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
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
