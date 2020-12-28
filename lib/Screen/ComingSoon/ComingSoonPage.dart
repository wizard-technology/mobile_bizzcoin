import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CominSoonPage extends StatefulWidget {
  @override
  _CominSoonPagePageState createState() => _CominSoonPagePageState();
}

class _CominSoonPagePageState extends State<CominSoonPage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/tool.png"))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  _data['WorkingOnFeature'],
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: screenHeight(context) / 25,
                    color: const Color(0xff0c0a0a),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: screenWidth(context) / 1.2,
                height: 40.0,
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color(0xfff9bf2d),
                ),
                child: FlatButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop() == true) {
                      Navigator.of(context).pop(context);
                    } else {}
                  },
                  color: const Color(0xfff9bf2d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    _data["Back"],
                    style: GoogleFonts.roboto(
                        fontSize: 16,
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        height: 30,
        child: Center(
          child: Text(
            _data["BetaVersion"],
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
