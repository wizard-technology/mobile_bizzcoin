import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/History/ViewHistoryPage.dart';
import 'package:bizzcoin_app/Screen/Notification/NotificationItem.dart';
import 'package:bizzcoin_app/Screen/Setting/HelpCenter/HelpCenterPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
//----------------------------loading----------------------------------//

  bool loading = false;
  List<NotificationItem> notif = [];
//----------------------------translator-------------------------------//

//----------------------------overrides-------------------------------//
  @override
  void initState() {
    super.initState();
    isOpenedNotification();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor:
          loading == false ? const Color(0xfff2f3f6) : Colors.white,
      body: CheckInternetWidget(
        loading == false
            ? SafeArea(
                child: checkIfNotificationEmpty == true
                    ? Container(
                        width: screenWidth(context),
                        height: screenHeight(context),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth(context) / 1.1,
                                alignment: _dir
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                margin: EdgeInsets.only(top: 20, bottom: 15),
                                child: Text(
                                  _data['Notification'],
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 25,
                                    color: const Color(0xff0c0a0a),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ...notif
                            ],
                          ),
                        ),
                      )
                    : buildNoItemToNotification(context, _data),
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
      ),
    );
  }

  //---------------------Widgets---------------------//
  bool checkIfNotificationEmpty = false;
  Widget buildNoItemToNotification(BuildContext context, _data) {
    return Container(
        width: screenWidth(context),
        height: screenHeight(context),
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Container(
                margin: EdgeInsets.only(top: screenHeight(context) / 5),
                child: Icon(
                  FeatherIcons.bell,
                  color: const Color(0xfff9bf2d),
                  size: 80,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight(context) / 8),
                child: Text(
                  _data['EmptyNotificationList'],
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
                    _data['NotificationsHere'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: const Color(0xfff9bf2d),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ))
            ])));
  }

  void onReportNotifactionPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpCenterPage()),
    );
  }

  void onAcceptNotifactionPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewHistoryPage()),
    );
  }

  void onSuccessNotifactionPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewHistoryPage()),
    );
  }

  isOpenedNotification() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(
        name: "open_notification",
      );
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        Map body = jsonDecode(response.body);
        body['notification'].forEach((element) {
          notif.add(NotificationItem(
            title: element['noti_title'],
            datetime: convertStrToDate(element['created_at']),
            icon: element['noti_type'] == 0
                ? FeatherIcons.messageSquare
                : element['noti_type'] != 4
                    ? FeatherIcons.package
                    : FeatherIcons.checkSquare,
            onClick: () => element['noti_type'] == 0
                ? Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCenterPage()),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewHistoryPage(
                        id: element['noti_id_opened'],
                      ),
                    ),
                  ),
          ));
        });
      }
    }
    setState(() {
      if (notif.isNotEmpty) {
        checkIfNotificationEmpty = true;
      }
      loading = false;
    });
  }
  //---------------------Methods of DB--------------------//

}
