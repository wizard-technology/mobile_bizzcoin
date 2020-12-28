import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedeemCodeScanPage extends StatefulWidget {
  @override
  _RedeemCodeScanPageState createState() => _RedeemCodeScanPageState();
}

class _RedeemCodeScanPageState extends State<RedeemCodeScanPage> {
  bool redeemCodeLoading = false;
  bool pinCodeLoading = false;
  var name, price;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    if (_authorizedOrNot == "Not Authorized") {
      _authorizeNow();
      return Scaffold(
        body: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Locked',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    color: const Color(0xff0c0a0a),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Touch fiingerprint sensor or faceid',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: const Color(0xff0c0a0a),
                ),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xcecececece),
        body: CheckInternetWidget(Container(
          width: screenWidth(context),
          height: screenHeight(context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/mobilebackground.png'))),
          child: InkWell(
            onTap: () => this.scan(_data),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/qr_code.png'))),
                ),
                Container(
                    width: 150,
                    margin: EdgeInsets.only(top: 15, right: 10),
                    child: Text(
                      _data['Tap'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        )),
        bottomNavigationBar: Container(
          width: screenWidth(context),
          height: screenHeight(context) / 4,
          decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: screenWidth(context) / 1.2,
                    height: 45.0,
                    margin: EdgeInsets.only(top: screenHeight(context) / 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffffffff),
                    ),
                    child: TextField(
                      textAlign: _dir ? TextAlign.left : TextAlign.right,
                      controller: _redeemCodeController,
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        hintText: _data['Code'],
                        hintStyle: GoogleFonts.roboto(fontSize: 15),
                      ),
                    ),
                  ),
                  _checkRedeemCode == true
                      ? Align(
                          alignment:
                              _dir ? Alignment.topLeft : Alignment.topRight,
                          child: Center(
                            child: Container(
                                width: screenWidth(context) / 1.2,
                                alignment: _dir
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                margin:
                                    EdgeInsets.only(top: 5, left: 0, right: 0),
                                child: Text(
                                  "${_data['EmptyCode']}",
                                  textAlign:
                                      _dir ? TextAlign.left : TextAlign.right,
                                  style: TextStyle(color: Colors.red),
                                )),
                          ))
                      : SizedBox(),
                ],
              ),
              !redeemCodeLoading
                  ? Container(
                      width: screenWidth(context) / 1.2,
                      height: screenHeight(context) / 18,
                      margin:
                          EdgeInsets.only(bottom: screenHeight(context) / 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff0c0a0a),
                      ),
                      child: FlatButton(
                        onPressed: () =>
                            this.onRedeemCodePressed(context, _data, _dir),
                        color: const Color(0xff0c0a0a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        textColor: Colors.white,
                        padding: EdgeInsets.all(0),
                        child: Text(
                          _data["RedeemCode"],
                          style: GoogleFonts.roboto(
                              fontSize: screenHeight(context) / 37,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(
                      width: screenWidth(context) / 1.2,
                      height: screenHeight(context) / 18,
                      margin:
                          EdgeInsets.only(bottom: screenHeight(context) / 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff0c0a0a),
                      ),
                      child: Center(
                          child: Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ))),
            ],
          ),
        ),
      );
    }
  }

//---------------------Widgets---------------------//

  buildAlertBox(BuildContext context, _data, _dir, _state) {
    return showDialog(
        context: context, // user must tap button!
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: screenWidth(context),
                height: screenHeight(context) / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth(context),
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
                                _data["Back"],
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
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 15),
                        child: Text(
                          _state
                              ? _data['Successful']
                              : _data['SomethingWrong'],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 28,
                            color: _state
                                ? const Color(0xff81d877)
                                : const Color(0xffe30606),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: screenHeight(context) / 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                _state
                                    ? ('$price' + " " + _data['Deposited'])
                                    : _data['TryAgian'],
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: _state ? 25 : 27,
                                    color: const Color(0xff0c0a0a),
                                    fontWeight:
                                        _state ? null : FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _state
                                ? Container(
                                    child: Text(
                                      '${_data['From']} : $name',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                      textDirection: _dir
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  buildPinCodeAlertBox(BuildContext context, _data, _dir) {
    return showDialog(
        context: context, // user must tap button!
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: screenWidth(context),
                height: screenHeight(context) / 2.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth(context),
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
                                _data["Back"],
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
                        margin: EdgeInsets.only(top: 15, right: 5, left: 5),
                        child: Align(
                          alignment: _dir
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            _data['EnterPinCode'],
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 25,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w700,
                            ),
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: screenWidth(context) / 1.2,
                            height: 45.0,
                            margin: EdgeInsets.only(
                                top: screenHeight(context) / 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xfff2f3f6),
                            ),
                            child: TextField(
                              textAlign:
                                  _dir ? TextAlign.left : TextAlign.right,
                              controller: _pinCodeController,
                              autocorrect: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 8, right: 8),
                                hintText: _data['PinCode'],
                                hintStyle: GoogleFonts.roboto(fontSize: 15),
                              ),
                            ),
                          ),
                          _checkPinCode == true
                              ? Align(
                                  alignment: _dir
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  child: Center(
                                    child: Container(
                                        width: screenWidth(context) / 1.2,
                                        alignment: _dir
                                            ? Alignment.topLeft
                                            : Alignment.topRight,
                                        margin: EdgeInsets.only(
                                            top: 5, left: 0, right: 0),
                                        child: Text(
                                          "${_data['EnterPinCode']}",
                                          textAlign: _dir
                                              ? TextAlign.left
                                              : TextAlign.right,
                                          textDirection: _dir
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ))
                              : SizedBox(),
                        ],
                      ),
                      !pinCodeLoading
                          ? Container(
                              width: screenWidth(context) / 1.2,
                              height: screenHeight(context) / 18,
                              margin: EdgeInsets.only(
                                  top: screenHeight(context) / 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xfff9bf2d),
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    onPinCodePressed(context, _data, _dir);
                                  });
                                },
                                color: const Color(0xfff9bf2d),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                textColor: Colors.white,
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  _data["Transfer"],
                                  style: GoogleFonts.roboto(
                                      fontSize: screenHeight(context) / 37,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              width: screenWidth(context) / 1.2,
                              height: screenHeight(context) / 18,
                              margin: EdgeInsets.only(
                                  bottom: screenHeight(context) / 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xff0c0a0a),
                              ),
                              child: Center(
                                  child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

//---------------------Authoriz---------------------//
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _authorizedOrNot = "Not Authorized";
  bool _canCheckBiometrics = true;
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    _checkBiometrics();
    if (_canCheckBiometrics) {
      bool isAuthorized = false;
      try {
        isAuthorized = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Please authenticate to complete your transaction",
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        print(e);
      }

      if (!mounted) return;

      setState(() {
        if (isAuthorized) {
          _authorizedOrNot = "Authorized";
        } else {
          _authorizedOrNot = "Not Authorized";
        }
      });
    }
  }

//---------------------Qr Scan---------------------//
  Future scan(_data) async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _data['Cancel'].toString(),
          "flash_on": _data['FlashOn'].toString(),
          "flash_off": _data['FlashOff'].toString(),
        },
        restrictFormat: BarcodeFormat.values.toList()
          ..removeWhere((e) => e == BarcodeFormat.unknown),
        useCamera: -1,
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 0.00,
          useAutoFocus: true,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);
      setState(() {
        _redeemCodeController.text = result.rawContent.toString();
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
    }
  }

  //---------------------Methods---------------------//
  TextEditingController _redeemCodeController = new TextEditingController();
  bool _checkRedeemCode = false;
  TextEditingController _pinCodeController = new TextEditingController();
  bool _checkPinCode = false;
  void onRedeemCodePressed(BuildContext context, _data, _dir) {
    setState(() {
      if (_redeemCodeController.text.isEmpty) {
        _checkRedeemCode = true;
      } else {
        _checkRedeemCode = false;
      }

      if (_checkRedeemCode == false) {
        onQrCode(context, _data, _dir);
      } else {
        buildAlertBox(context, _data, _dir, false);
      }
    });
  }

  void onPinCodePressed(BuildContext context, _data, _dir) {
    setState(() {
      if (_pinCodeController.text.isEmpty) {
        _checkPinCode = true;
      } else {
        _checkPinCode = false;
      }
      pinCodeLoading = true;
      if (_checkPinCode == false) {
        buildAlertBox(context, _data, _dir, true);
      } else {
        buildAlertBox(context, _data, _dir, false);
      }
      pinCodeLoading = false;
    });
  }

  onQrCode(BuildContext context, _data, _dir) async {
    setState(() {
      redeemCodeLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "scan", type: 'company');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Map json = {
        "code": _redeemCodeController.text.toString(),
      };
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      if (statusCode == 200) {
        name = body['redeem']['user']['u_first_name'] +
            ' ' +
            body['redeem']['user']['u_second_name'];
        price = body['redeem']['rc_price'];
        _redeemCodeController.text = '';
        buildAlertBox(context, _data, _dir, true);
      } else {
        buildAlertBox(context, _data, _dir, false);
      }
    }
    setState(() {
      redeemCodeLoading = false;
    });
  }
}
