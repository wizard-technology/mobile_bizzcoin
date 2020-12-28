import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 186, 28),
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
                    width: screenWidth(context) / 2,
                    height: screenHeight(context) / 4,
                    margin: EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/BizzPaymentlogo.png"),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight(context) / 15),
                    child: Text(
                      _data["Welcome"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: screenHeight(context) / 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: screenHeight(context) / 25, bottom: 5),
                    child: Text(
                      _data['FutureOnlineShopping'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: screenHeight(context) / 35,
                          color: Colors.white,
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
          height: screenHeight(context) / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Center(
            child: Container(
              width: screenWidth(context) / 1.4,
              height: screenHeight(context) / 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 249, 186, 28),
              ),
              child: FlatButton(
                onPressed: () => this.onGetStartPressed(context),
                color: Color.fromARGB(255, 249, 186, 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  _data["GetStart"],
                  style: GoogleFonts.roboto(
                      fontSize: screenHeight(context) / 37,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )),
    );
  }

  //---------------------Methods---------------------//
  void onGetStartPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreenPage()),
    );
  }
}
