import 'dart:convert';
import 'package:bizzcoin_app/Auth/CreateAccount/CreateAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RecomandedItem.dart';

class ViewItemPage extends StatefulWidget {
  final _id;
  ViewItemPage(this._id);
  @override
  _ViewItemPageState createState() => _ViewItemPageState(this._id);
}

class _ViewItemPageState extends State<ViewItemPage> {
  final _id;
  _ViewItemPageState(this._id);
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

//----------------------------loading----------------------------------//

  bool loading = true;
  bool addToCartLoading = false;
  bool favLoading = false;
  List<Recomanded> recomanded = [];

//----------------------------overrides-------------------------------//
  @override
  void initState() {
    super.initState();
    getInformationItemFromDB();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: const Color(0xfff2f3f6),
      body: CheckInternetWidget(
        SafeArea(
          child: Container(
            width: screenWidth(context),
            height: screenHeight(context),
            child: loading == false
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth(context),
                          margin:
                              EdgeInsets.only(top: screenHeight(context) / 40),
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
                                  "$title",
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
                          width: screenWidth(context) / 1.2,
                          height: screenHeight(context) / 5,
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffcecece),
                            image: DecorationImage(
                              image: image ??
                                  AssetImage("assets/BizzPaymentlogo.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth(context) / 1.2,
                          margin: EdgeInsets.only(top: 15),
                          alignment: _dir
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            '$title',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 22,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: screenWidth(context) / 1.2,
                          height: 40,
                          margin: EdgeInsets.only(top: 20),
                          child: Directionality(
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$price\$',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    color: const Color(0xff0c0a0a),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                !favLoading
                                    ? IconButton(
                                        icon: Icon(
                                          icon,
                                          color: Colors.black,
                                        ),
                                        onPressed: () =>
                                            this.onHeartPressed(context))
                                    : Center(
                                        child: Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              const Color(0xfff2f3f6),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.amber),
                                        ),
                                      ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth(context) / 1.2,
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                            "$description",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: const Color(0xff0c0a0a),
                            ),
                            textAlign: _dir ? TextAlign.left : TextAlign.right,
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                          ),
                        ),
                        !addToCartLoading
                            ? Container(
                                width: screenWidth(context) / 1.2,
                                height: 40.0,
                                margin: EdgeInsets.only(top: 40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xfff9bf2d),
                                ),
                                child: FlatButton(
                                  onPressed: () =>
                                      this.onAddToCartPressed(context),
                                  color: const Color(0xfff9bf2d),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    _data['AddToCart'],
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
                                margin: EdgeInsets.only(top: 40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xfff9bf2d),
                                ),
                                child: Center(
                                    child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: const Color(0xfff9bf2d),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )),
                              ),
                        Container(
                          width: screenWidth(context) / 1.2,
                          margin: EdgeInsets.only(
                            top: 40,
                          ),
                          alignment: _dir
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            _data['Recommendations'],
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: screenWidth(context),
                          margin: EdgeInsets.only(
                              top: 15,
                              bottom: 35,
                              left: _dir ? screenWidth(context) / 12 : 0,
                              right: _dir ? 0 : screenWidth(context) / 12),
                          child: Directionality(
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [...recomanded],
                              ),
                            ),
                          ),
                        )
                      ],
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
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  void onHeartPressed(BuildContext context) {
    favorateOnPress();
  }

  void onAddToCartPressed(BuildContext context) async {
    setState(() {
      addToCartLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountPage()),
      );
    } else {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Map json = {'product': this._id.toString()};
      String url = RouteApi().routeGet(name: "addToCart");
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);
      if (statusCode == 200) {
        onCopyPressed(context, body['message'][0]);
      }
    }
    setState(() {
      addToCartLoading = false;
    });
  }

  void onCopyPressed(BuildContext context, text) {
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewItemPage(id)),
    );
  }

  //---------------------Methods of DB--------------------//
  String title = '', description = '';
  double price = 0;
  IconData icon = FeatherIcons.heart;
  var image;
  getInformationItemFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _language = prefs.getString('lang').toString();
    String token = prefs.getString('token');

    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    String url = token == null
        ? RouteApi().routeGet(name: "product") + '/' + this._id.toString()
        : RouteApi().routeGet(name: "productUser") + '/' + this._id.toString();

    Response response = await get(url, headers: headers);
    Map body = jsonDecode(response.body);
    body['recomanded'].forEach((element) {
      recomanded.add(
        Recomanded(
          name: element['product']['p_name'],
          price: RouteApi().reciprocal(element['product']['p_price']),
          onItemPressed: () => onItemPressed(context, element['product']['id']),
          image: NetworkImage(
              "${RouteApi().storageUrl}${element['product']['p_image']}"),
        ),
      );
    });
    setState(() {
      if (_language == 'kus') {
        title = body['product']['p_name_ku'];
        description = body['product']['p_info_ku'];
        if (token != null) {
          icon = body['favorate']
              ? FontAwesomeIcons.solidHeart
              : FeatherIcons.heart;
        }
        image = NetworkImage(
            "${RouteApi().storageUrl}${body['product']['p_image']}");
        price = RouteApi().reciprocal(body['product']['p_price']);
      } else if (_language == 'en') {
        title = body['product']['p_name'];
        description = body['product']['p_info'];
        if (token != null) {
          icon = body['favorate']
              ? FontAwesomeIcons.solidHeart
              : FeatherIcons.heart;
        }
        image = NetworkImage(
            "${RouteApi().storageUrl}${body['product']['p_image']}");
        price = RouteApi().reciprocal(body['product']['p_price']);
      } else if (_language == 'kuk') {
        title = body['product']['p_name_kr'];
        description = body['product']['p_info_kr'];
        if (token != null) {
          icon = body['favorate']
              ? FontAwesomeIcons.solidHeart
              : FeatherIcons.heart;
        }
        image = NetworkImage(
            "${RouteApi().storageUrl}${body['product']['p_image']}");
        price = RouteApi().reciprocal(body['product']['p_price']);
      } else if (_language == 'ar') {
        title = body['product']['p_name_ar'];
        description = body['product']['p_info_ar'];
        if (token != null) {
          icon = body['favorate']
              ? FontAwesomeIcons.solidHeart
              : FeatherIcons.heart;
        }
        image = NetworkImage(
            "${RouteApi().storageUrl}${body['product']['p_image']}");
        price = RouteApi().reciprocal(body['product']['p_price']);
      } else if (_language == 'per') {
        title = body['product']['p_name_pr'];
        description = body['product']['p_info_pr'];
        if (token != null) {
          icon = body['favorate']
              ? FontAwesomeIcons.solidHeart
              : FeatherIcons.heart;
        }
        image = NetworkImage(
            "${RouteApi().storageUrl}${body['product']['p_image']}");
        price = RouteApi().reciprocal(body['product']['p_price']);
      }
      loading = false;
    });
  }

  favorateOnPress() async {
    setState(() {
      favLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountPage()),
      );
    } else {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      String url =
          RouteApi().routeGet(name: "favorate") + '/' + this._id.toString();

      Response response = await post(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);
      if (statusCode == 200) {
        setState(() {
          icon = body['favorate']
              ? FontAwesomeIcons.solidHeart
              : FeatherIcons.heart;
        });
      }
    }
    setState(() {
      favLoading = false;
    });
  }
}
