import 'package:bizzcoin_app/Screen/AgentScreens/AgentProfileEdit/AgentProfileEditPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'EditPasswordPage.dart';
import 'EditProfilePage.dart';

class EditPage extends StatefulWidget {
  final checkIfUser;
  EditPage(this.checkIfUser);
  @override
  _EditPageState createState() => _EditPageState(this.checkIfUser);
}

class _EditPageState extends State<EditPage> {
  final checkIfUser;
  _EditPageState(this.checkIfUser);
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
                      child: Column(children: [
                    Container(
                      width: screenWidth(context),
                      margin: EdgeInsets.only(top: screenHeight(context) / 40),
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
                              _data["Edit"],
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
                      onTap: () => this.onProfilePressed(context),
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
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: const Color(0x30ffed75),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            FeatherIcons.user,
                                            color: const Color(0xfff9bf2d),
                                          ),
                                        )),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Text(
                                        _data['Profile'],
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
                              Icon(
                                _dir
                                    ? FeatherIcons.chevronRight
                                    : FeatherIcons.chevronLeft,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => this.onPasswordPressed(context),
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
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Color.fromARGB(
                                              255, 241, 244, 255),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            FeatherIcons.lock,
                                            color: Colors.black,
                                          ),
                                        )),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Text(
                                        _data['Password'],
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
                              Icon(
                                _dir
                                    ? FeatherIcons.chevronRight
                                    : FeatherIcons.chevronLeft,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])))),
        ));
  }

//---------------------Methods---------------------//
  void onProfilePressed(BuildContext context) {
    if (checkIfUser) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditProfilePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgentProfileEditPage()),
      );
    }
  }

  void onPasswordPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPasswordPage()),
    );
  }
}
