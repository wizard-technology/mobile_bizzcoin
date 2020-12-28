import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatefulWidget {
  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
        backgroundColor: const Color(0xfff2f3f6),
        body: CheckInternetWidget(Container(
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
                            _data["AppInfo"],
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
                    width: screenWidth(context),
                    height: screenHeight(context) - 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth(context) / 2.5,
                                height: screenHeight(context) / 5,
                                margin: EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage(
                                        'assets/BizzPaymentlogo.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Bizz Payment',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: screenHeight(context) / 25,
                                    color: const Color(0xff0c0a0a),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'V 1.0.0',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            color: const Color(0xfff9bf2d),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                'Designed and Developed By ',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: const Color(0xff0c0a0a),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (await canLaunch(
                                      'https://tacogroup.org/')) {
                                    await launch('https://tacogroup.org/');
                                  } else {
                                    throw 'Could not launch https//www.tacogroup.org';
                                  }
                                },
                                child: Text(
                                  'TACO Group',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: const Color(0xfff9bf2d),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ])))));
  }
}
