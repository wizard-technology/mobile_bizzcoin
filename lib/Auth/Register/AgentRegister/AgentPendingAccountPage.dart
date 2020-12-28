import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgentPendingAccountPage extends StatefulWidget {
  @override
  _AgentPendingAccountPageState createState() =>
      _AgentPendingAccountPageState();
}

class _AgentPendingAccountPageState extends State<AgentPendingAccountPage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    final _data = _lang.getLanguage()['data'];
    return Scaffold(
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
                    width: screenWidth(context) / 2,
                    height: screenHeight(context) / 2,
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                        color: const Color(0xfff9bf2d), shape: BoxShape.circle),
                    child: Center(
                        child: Icon(
                      FeatherIcons.userCheck,
                      size: 75,
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      _data['AgentPendingAccount'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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

}
