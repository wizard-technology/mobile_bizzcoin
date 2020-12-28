import 'dart:convert';
import 'package:bizzcoin_app/Auth/CreateAccount/CreateAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/AddProduct/AddProductPage.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/Products/ProductsPage.dart';
import 'package:bizzcoin_app/Screen/BizzPayment/BizzPaymentPage.dart';
import 'package:bizzcoin_app/Screen/Edit/EditPage.dart';
import 'package:bizzcoin_app/Screen/History/HistoryPage.dart';
import 'package:bizzcoin_app/Screen/MainScreen/MainScreenPage.dart';
import 'package:bizzcoin_app/Screen/RedeemCodes/RedeemCodes.dart';
import 'package:bizzcoin_app/Screen/Setting/SettingPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

class MyAccount extends StatefulWidget {
  final checkIfUser;
  MyAccount(this.checkIfUser);
  @override
  _MyAccountState createState() => _MyAccountState(this.checkIfUser);
}

class _MyAccountState extends State<MyAccount> {
  final checkIfUser;
  _MyAccountState(this.checkIfUser);
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 244, 255),
      body: checkIfLogin == null || checkIfUser == null
          ? CheckInternetWidget(Center(
              child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                backgroundColor: const Color(0xfff2f3f6),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            )))
          : CheckInternetWidget(
              checkIfLogin || !checkIfUser
                  ? Column(
                      children: [
                        name != 'Fullname'
                            ? Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(
                                    left: 20,
                                    top: screenHeight(context) / 10,
                                    right: 20),
                                child: Text(
                                  "$name",
                                  textAlign:
                                      _dir ? TextAlign.left : TextAlign.right,
                                  style: GoogleFonts.roboto(
                                      fontSize: screenHeight(context) / 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(
                                    left: 20,
                                    top: screenHeight(context) / 10,
                                    right: 20),
                                child: loadingWidget(
                                    context, screenWidth(context) / 3, 13)),
                        phone != '07*********'
                            ? Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Directionality(
                                    textDirection: _dir
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$phone",
                                          textAlign: _dir
                                              ? TextAlign.left
                                              : TextAlign.right,
                                          style: GoogleFonts.roboto(
                                            fontSize:
                                                screenHeight(context) / 35,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(FeatherIcons.edit),
                                          onPressed: () => this
                                              .onEditAccountPressed(context),
                                        )
                                      ],
                                    )),
                              )
                            : Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                ),
                                child: loadingWidget(
                                    context, screenWidth(context) / 1.3, 13)),
                      ],
                    )
                  : buildIfNotLogin(context, _data, _dir),
            ),
      bottomNavigationBar: Container(
        width: screenWidth(context),
        height: screenHeight(context) / 1.7,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Container(
          height: screenHeight(context) / 1.7,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth(context) / 1.2,
                  child: Column(
                    children: [
                      !checkIfUser
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => this.onMyProductsPressed(context),
                              child: Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(top: 30),
                                child: Directionality(
                                  textDirection: _dir
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color:
                                                      const Color(0x30ffed75),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    FeatherIcons.grid,
                                                    color:
                                                        const Color(0xfff9bf2d),
                                                  ),
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                _data['MyProducts'],
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xff0c0a0a),
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
                            )
                          : Container(),
                      !checkIfUser
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => this.onAddProductPressed(context),
                              child: Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(top: 10),
                                child: Directionality(
                                  textDirection: _dir
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Color.fromARGB(
                                                      255, 241, 244, 255),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    FeatherIcons.plus,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                _data['AddProduct'],
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xff0c0a0a),
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
                            )
                          : Container(),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => this.onBizzPymentPressed(context),
                        child: Container(
                          width: screenWidth(context),
                          margin: EdgeInsets.only(top: 10),
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
                                              FeatherIcons.creditCard,
                                              color: const Color(0xfff9bf2d),
                                            ),
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          _data['BizzcoinPrice'],
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
                        onTap: () => this.onSettingPressed(context),
                        child: Container(
                          width: screenWidth(context),
                          margin: EdgeInsets.only(top: 10),
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
                                              FeatherIcons.settings,
                                              color: Colors.black,
                                            ),
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          _data['Setting'],
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
                      checkIfUser
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => this.onHistoryPressed(context),
                              child: Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(top: 10),
                                child: Directionality(
                                  textDirection: _dir
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color:
                                                      const Color(0x30ffed75),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    FeatherIcons.rotateCcw,
                                                    color:
                                                        const Color(0xfff9bf2d),
                                                  ),
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                _data['HistroyPurchase'],
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xff0c0a0a),
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
                            )
                          : Container(),
                      checkIfUser
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => this.onRedeemcodesPressed(context),
                              child: Container(
                                width: screenWidth(context),
                                margin: EdgeInsets.only(top: 10),
                                child: Directionality(
                                  textDirection: _dir
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Color.fromARGB(
                                                      255, 241, 244, 255),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    FeatherIcons.maximize,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                _data['RedeemCodes'],
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xff0c0a0a),
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
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: checkIfUser
                      ? screenHeight(context) / 17
                      : screenHeight(context) / 10.5,
                ),
                name == 'Fullname'
                    ? Container()
                    : checkIfLogin != null || checkIfUser != null
                        ? InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => this.onLogoutPressed(context),
                            child: Container(
                              width: screenWidth(context) / 1.2,
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: Directionality(
                                textDirection: _dir
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                  FeatherIcons.logOut,
                                                  color: Colors.black,
                                                ),
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Text(
                                              _data['Logout'],
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
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                SizedBox(
                  height: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//---------------------Methods---------------------//
  bool checkIfLogin;

  Widget buildIfNotLogin(BuildContext context, _data, _dir) {
    return Container(
      width: screenWidth(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                _data['Welcome'],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 27,
                  color: const Color(0xff0c0a0a),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _dir ? 10 : 5),
              child: Text(
                _data['WelcomeForBuy'],
                textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: const Color(0xff0c0a0a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: screenWidth(context) / 1.5,
              height: 40.0,
              margin: EdgeInsets.only(top: _dir ? 15 : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xff0c0a0a),
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountPage()),
                  );
                },
                color: const Color(0xff0c0a0a),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                child: Text(
                  _data["CreateAnAccount"],
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loadingWidget(BuildContext context, width, height) {
    return SkeletonAnimation(
      child: Container(
        width: double.parse(width.toString()),
        height: double.parse(height.toString()),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey[300]),
      ),
    );
  }
//---------------------Methods---------------------//

  String name = 'Fullname';
  String phone = '07*********';
  @override
  void initState() {
    super.initState();

    _getAccount();
  }

  void onEditAccountPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage(checkIfUser)),
    );
  }

  void onMyProductsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductsPage()),
    );
  }

  void onBizzPymentPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BizzPaymentPage()),
    );
  }

  void onSettingPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }

  void onAddProductPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage()),
    );
  }

  void onHistoryPressed(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              token == null ? CreateAccountPage() : HistoryPage()),
    );
  }

  void onRedeemcodesPressed(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              token == null ? CreateAccountPage() : RedeemCodesPage()),
    );
  }

  void onLogoutPressed(BuildContext context) {
    _logout();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreenPage()),
    );
  }

  _getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    // prefs.clear();
    if (token != null) {
      String url = RouteApi().routeGet(name: "profile");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Response response = await get(url, headers: headers);
      Map body = jsonDecode(response.body);
      setState(() {
        name = body['u_first_name'] + ' ' + body['u_second_name'];
        if (body['u_first_name'] == 'Company') {
          name = body['u_second_name'];
        }
        phone = body['u_phone'];
        checkIfLogin = true;
      });
    } else {
      setState(() {
        checkIfLogin = false;
      });
    }
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "logout");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        prefs.remove('token');
      }
    }
  }
}
