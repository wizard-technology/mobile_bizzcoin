import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/History/ItemHistory.dart';
import 'package:bizzcoin_app/Screen/History/ViewHistoryPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List history = [];
  @override
  void initState() {
    getHistory();
    super.initState();
    PushNotificationService(context: context).initialise();
  }

  bool loading = true;
  Map _data;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: !loading
          ? CheckInternetWidget(
              SafeArea(
                child: Container(
                  width: screenWidth(context),
                  height: screenHeight(context),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                            alignment: _dir
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
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
                                    _dir
                                        ? Icon(CupertinoIcons.back)
                                        : Container(),
                                    SizedBox(
                                      width: _dir ? 5 : 0,
                                    ),
                                    Text(
                                      _data['HistroyPurchase'],
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
                            )),
                        ...history
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                backgroundColor: const Color(0xfff2f3f6),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            )),
    );
  }

//---------------------Widgets---------------------//
  bool checkIfHistoryEmpty = false;
  Widget buildNoItemToHistory(BuildContext context, _data) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context) - 150,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.only(top: screenHeight(context) / 5),
            child: Icon(
              FeatherIcons.rotateCcw,
              color: const Color(0xfff9bf2d),
              size: 70,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: screenHeight(context) / 8),
            child: Text(
              _data['EmptyHistoryList'],
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: screenHeight(context) / 30,
                color: const Color(0xff0c0a0a),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: screenHeight(context) / 14),
              child: Text(
                _data['WatingForYou'],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: const Color(0xfff9bf2d),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ))
        ]),
      ),
    );
  }

//---------------------Methods---------------------//
  void onViewHistoryPressed(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewHistoryPage(
          id: index,
        ),
      ),
    );
  }

  getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "history");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      List cart = body['cart'];
      if (statusCode == 200) {
        cart.forEach((element) {
          history.add(ItemHistory(
            date: convertStrToDate(element['created_at']),
            onClick: () => this.onViewHistoryPressed(element['c_doc_id']),
            id: element['c_doc_id'],
            price: element['price'],
          ));
        });
      }
    }
    setState(() {
      if (history.length <= 0) {
        checkIfHistoryEmpty = true;
        history.add(buildNoItemToHistory(context, _data));
      }
      loading = false;
    });
  }
}
