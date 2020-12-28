import 'dart:convert';
import 'package:bizzcoin_app/Auth/CreateAccount/CreateAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpCenterPage extends StatefulWidget {
  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  String _textSuccess;
  String _textError;
  _HelpCenterPageState();
  ScrollController _controller;

  bool sendLoading = false;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getMessage();
  }

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
              controller: _controller,
              child: Column(children: [
                Align(
                  alignment:
                      _dir ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.only(
                        top: screenHeight(context) / 40, bottom: 50),
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
                            _data['Help'],
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
                ),
                !loading
                    ? (_checkIfSendText == true
                        ? Container(
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth(context) / 1.2,
                                  height: 180.0,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffcecece),
                                  ),
                                  child: TextField(
                                    textAlign:
                                        _dir ? TextAlign.left : TextAlign.right,
                                    controller: _textController,
                                    autocorrect: false,
                                    autofocus: false,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: _data['writeHere'],
                                      hintStyle:
                                          GoogleFonts.roboto(fontSize: 15),
                                    ),
                                  ),
                                ),
                                _checkText == true
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
                                                _textError ??
                                                    _data[
                                                        'PleaseEnterSomeText'],
                                                textAlign: _dir
                                                    ? TextAlign.left
                                                    : TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                        ))
                                    : SizedBox(),
                                !sendLoading
                                    ? Container(
                                        width: screenWidth(context) / 1.2,
                                        height: 40.0,
                                        margin: EdgeInsets.only(
                                            top: 35, bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color:
                                              Color.fromARGB(255, 249, 186, 28),
                                        ),
                                        child: FlatButton(
                                          onPressed: () =>
                                              this.onSendPressed(context),
                                          color:
                                              Color.fromARGB(255, 249, 186, 28),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                          ),
                                          textColor: Colors.white,
                                          padding: EdgeInsets.all(0),
                                          child: Text(
                                            _data['Send'],
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: screenWidth(context) / 1.2,
                                        height: 40.0,
                                        margin: EdgeInsets.only(
                                            top: 35, bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color:
                                              Color.fromARGB(255, 249, 186, 28),
                                        ),
                                        child: Center(
                                            child: Container(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                const Color(0xfff9bf2d),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ))),
                                _checkTextSuccess == true
                                    ? Center(
                                        child: Container(
                                          width: screenWidth(context) / 1.2,
                                          child: Center(
                                            child: Text(
                                              _textSuccess,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        : readSendedText(context))
                    : Container(
                        height: screenHeight(context) / 1.5,
                        child: Center(
                            child: Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        )),
                      )
              ]),
            ),
          ),
        ),
      ),
    );
  }

//---------------------Widgets---------------------//
  Widget readSendedText(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    return Container(
      child: Column(
        children: [
          ...message,
          Container(
            margin: EdgeInsets.only(top: screenHeight(context) / 10),
            child: CupertinoButton(
                child: Text(
                  _data['SendAnotherMessage'],
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color(0xff0c0a0a),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  setState(() {
                    _checkIfSendText = true;
                  });
                }),
          ),
        ],
      ),
    );
  }

//---------------------Methods---------------------//
  bool _checkText = false;
  bool _checkTextSuccess = false;
  bool _checkIfSendText = false;
  List message = [];
  TextEditingController _textController = new TextEditingController();
  void onSendPressed(BuildContext context) {
    setState(() {
      if (_textController.text.isEmpty) {
        _checkText = true;
      } else {
        _checkText = false;
        _checkIfSendText = true;
      }
      // loading = true;
    });
    if (!_checkText) {
      sendMessage();
    }
  }

  sendMessage() async {
    setState(() {
      loading = true;
      sendLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "help");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map json = {'information': _textController.text.toString()};
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);
      if (statusCode == 200) {
        setState(() {
          _textSuccess = body['message'][0];
          _textController.text = '';
          _checkTextSuccess = true;
          _checkIfSendText = false;
        });
        getMessage();
      } else {
        setState(() {
          _textError = body['errors']['information'][0];
          _checkText = true;
        });
      }
    }
    setState(() {
      sendLoading = false;
      loading = false;
    });
  }

  getMessage() async {
    message.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String dir = prefs.getString('lang');
    bool _dir;
    if (dir == 'kus') {
      _dir = false;
    } else if (dir == 'kuk') {
      _dir = true;
    } else if (dir == 'per') {
      _dir = false;
    } else if (dir == 'ar') {
      _dir = false;
    } else {
      _dir = true;
    }

    if (token != null) {
      String url = RouteApi().routeGet(name: "get_help");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Response response = await get(
        url,
        headers: headers,
      );
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);
      if (statusCode == 200) {
        body['report'].forEach((element) {
          if (element['h_from'] == 0) {
            message.add(Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xfff9bf2d),
              ),
              child: SizedBox(
                width: 308.0,
                child: Text(
                  '${element['h_info']}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w300,
                    height: 1.375,
                  ),
                  textAlign: _dir ? TextAlign.left : TextAlign.right,
                  textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                ),
              ),
            ));
          } else {
            message.add(Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xfff2f3f6),
              ),
              child: SizedBox(
                width: 308.0,
                child: Text(
                  '${element['h_info']}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xff0c0a0a),
                    fontWeight: FontWeight.w300,
                    height: 1.375,
                  ),
                  textAlign: _dir ? TextAlign.left : TextAlign.right,
                  textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                ),
              ),
            ));
          }
        });
        _controller = ScrollController();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        });
        setState(() {
          if (message.length == 0) {
            _checkIfSendText = true;
          }
          loading = false;
        });
      }
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountPage()),
      );
    }
  }
}
