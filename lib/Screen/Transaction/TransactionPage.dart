import 'dart:async';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  final _bizz;
  final _dollar;
  final _address;
  final _url;

  TransactionPage(this._bizz, this._dollar, this._address, this._url);
  @override
  _TransactionPageState createState() =>
      _TransactionPageState(this._bizz, this._dollar, this._address, this._url);
}

class _TransactionPageState extends State<TransactionPage> {
  final _bizz;
  final _dollar;
  final _address;
  final _url;
  _TransactionPageState(this._bizz, this._dollar, this._address, this._url);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    PushNotificationService(context: context).initialise();
    startTimer();
  }

  Map _data;
  bool _dir;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    _data = _lang.getLanguage()['data'];
    _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: const Color(0xfff2f3f6),
      body: loading == false
          ? Container(
              width: screenWidth(context),
              height: screenHeight(context),
              child: SingleChildScrollView(
                  child: Column(children: [
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
                          _data["Transaction"],
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
                SizedBox(
                  height: screenHeight(context) / 8,
                ),
                Container(
                  width: screenWidth(context) / 1.2,
                  height: 350,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                NetworkImage("${RouteApi().storageUrl}$_url"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenWidth(context) / 1.2,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => this.onCopyPressed(context),
                              child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color(0x30ffed75),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FeatherIcons.copy,
                                      color: const Color(0xfff9bf2d),
                                      size: 18,
                                    ),
                                  )),
                            ),
                            Container(
                              height: 35,
                              width: screenWidth(context) / 1.5,
                              margin: EdgeInsets.only(
                                left: 5,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SelectableText(
                                    '$_address',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      color: const Color(0xff0c0a0a),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: screenWidth(context) / 1.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "${_bizz.toStringAsFixed(3)} bizz",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: const Color(0xff0c0a0a),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "${_dollar.toStringAsFixed(2)}\$",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: const Color(0xff0c0a0a),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: screenWidth(context) / 1.2,
                  child: Center(
                    child: Text(
                      _data['ExpiryDate'] + " $_minutes : $_second",
                      textDirection:
                          _dir ? TextDirection.ltr : TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: const Color(0xff0c0a0a),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) / 20,
                ),
                // Container(
                //   width: screenWidth(context) / 1.4,
                //   height: screenHeight(context) / 18,
                //   margin: EdgeInsets.only(bottom: screenHeight(context) / 30),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: const Color(0xff0c0a0a),
                //   ),
                //   child: FlatButton(
                //     onPressed: ,
                //     color: const Color(0xff0c0a0a),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(4)),
                //     ),
                //     textColor: Colors.white,
                //     padding: EdgeInsets.all(0),
                //     child: Text(
                //       _data["BetaVer"],
                //       style: GoogleFonts.roboto(
                //           fontSize: screenHeight(context) / 37,
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ])))
          : Container(
              width: screenWidth(context),
              height: screenHeight(context),
              color: Colors.white,
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/BizzPaymentlogo.png"))),
                ),
              ),
            ),
    );
  }

  //---------------------Widgets---------------------//
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            content: Container(
              margin: EdgeInsets.all(10),
              child: Directionality(
                textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => this.onRetryPressed(context),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000.0),
                          color: const Color(0x30ffed75),
                        ),
                        child: Icon(
                          FeatherIcons.rotateCcw,
                          color: const Color(0xfff9bf2d),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Text(
                        _data['TransactionTimeout'].toString(),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialogDone() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            content: Container(
              margin: EdgeInsets.all(10),
              child: Directionality(
                textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => this.onRetryPressed(context),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000.0),
                          color: const Color(0x30ffed75),
                        ),
                        child: Icon(
                          FeatherIcons.checkCircle,
                          color: const Color(0xfff9bf2d),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    // Container(
                    //   child: Text(
                    //     _data['TransactionTimeout'].toString(),
                    //     style: TextStyle(
                    //         fontFamily: 'Roboto',
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w700,
                    //         fontSize: 16),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //---------------------Methods---------------------//
  bool loading = false;
  // ignore: unused_field
  Timer _timer;
  int _second = 60;
  int _minutes = 7;
  int countMinute = 0;

  void onCopyPressed(BuildContext context) {
    Clipboard.setData(new ClipboardData(text: '$_address')).then((value) {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(_data['CopiedToClipboard']),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            print(1234);
          },
        ),
      ));
    });
  }

  Future<void> startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          setState(() {
            if (_minutes < 1 && _second <= 1) {
              timer.cancel();
              _minutes = 0;
              _second = 0;
              //stop recuest
              _showMyDialog();
            } else {
              _second = _second - 1;
              countMinute++;
            }

            if (countMinute == 60) {
              _second = 60;
              countMinute = 0;
              _minutes--;
            }
          });
        },
      ),
    );
  }

  void onRetryPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  // void onBetaV(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token');

  //   if (token != null) {
  //     String url = RouteApi().routeGet(name: "checkout");
  //     Map<String, String> headers = {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token'
  //     };
  //     Response response = await post(url, headers: headers);
  //     int statusCode = response.statusCode;
  //     // Map body = jsonDecode(response.body);

  //     if (statusCode == 200) {
  //       _showMyDialogDone().then((value) => Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => MainScreenPage()),
  //           ));
  //     }
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => CreateAccountPage()),
  //     );
  //   }
  // }
}
