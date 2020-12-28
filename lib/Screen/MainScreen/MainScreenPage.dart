import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AddToCart/AddToCart.dart';
import 'package:bizzcoin_app/Screen/Favourite/FavouritePage.dart';
import 'package:bizzcoin_app/Screen/HomePage/HomePage.dart';
import 'package:bizzcoin_app/Screen/MyAccount/MyAccountPage.dart';
import 'package:bizzcoin_app/Screen/Notification/NotificationPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenPageState();
  }
}

class _MainScreenPageState extends State<MainScreenPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _childrenOnLine;
  _MainScreenPageState() {
    setPages();
  }
  int _currentIndex = 0;
  bool isCart = false;
  bool isNotification = false;
  void setPages() {
    isNotificationAndCheckout();

    _childrenOnLine = [
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: HomePage()),
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: AddToCartPage()),
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: NotificationPage()),
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: FavouritePage()),
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: MyAccount(true)),
    ];
  }

  void _onBottomNavBarTab(int index) {
    isNotificationAndCheckout();

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    isNotificationAndCheckout();
  }

  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageService>(context);
    bool _dir = _language.getLanguage()['dir'];

    return SafeArea(
      child: Scaffold(
        body: CheckInternetWidget(_childrenOnLine[_currentIndex]),
        bottomNavigationBar: new Directionality(
          textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xfff2f3f6),
              selectedItemColor: const Color(0xfff9bf2d),
              unselectedItemColor: Colors.black,
              selectedIconTheme: IconThemeData(
                size: 25,
              ),
              unselectedIconTheme: IconThemeData(
                size: 25,
              ),
              items: <BottomNavigationBarItem>[
                new BottomNavigationBarItem(
                    icon: const Icon(FeatherIcons.home),
                    title: Container(height: 0.0)),
                isCart
                    ? new BottomNavigationBarItem(
                        icon: new Stack(
                          children: <Widget>[
                            new Icon(FeatherIcons.shoppingBag),
                            new Positioned(
                              right: 0,
                              child: new Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.green[800],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Center(
                                  child: new Text(
                                    '',
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        title: Container(height: 0.0))
                    : BottomNavigationBarItem(
                        icon: Icon(FeatherIcons.shoppingBag),
                        title: Container(height: 0.0)),
                isNotification
                    ? new BottomNavigationBarItem(
                        title: Container(height: 0.0),
                        icon: new Stack(
                          children: <Widget>[
                            new Icon(FeatherIcons.bell),
                            new Positioned(
                              right: 0,
                              child: new Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: new Text(
                                  '',
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : BottomNavigationBarItem(
                        icon: Icon(FeatherIcons.bell),
                        title: Container(height: 0.0)),
                new BottomNavigationBarItem(
                    icon: Icon(FeatherIcons.heart),
                    title: Container(height: 0.0)),
                new BottomNavigationBarItem(
                    icon: Icon(FeatherIcons.user),
                    title: Container(height: 0.0)),
              ],
              currentIndex: _currentIndex,
              onTap: _onBottomNavBarTab,
            ),
          ),
        ),
      ),
    );
  }

  isNotificationAndCheckout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(
      name: "mainscreen",
    );
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final check = jsonDecode(response.body);
      setState(() {
        isCart = check['cart'];
        isNotification = check['notification'];
      });
    }
  }
}
