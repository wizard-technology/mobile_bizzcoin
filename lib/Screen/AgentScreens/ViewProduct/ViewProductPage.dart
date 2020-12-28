import 'dart:convert';

import 'package:bizzcoin_app/Auth/CreateAccount/CreateAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/Transaction/TransactionRedeem.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewProductPage extends StatefulWidget {
  final data;

  const ViewProductPage({Key key, this.data}) : super(key: key);
  @override
  _ViewProductPageState createState() => _ViewProductPageState(this.data);
}

class _ViewProductPageState extends State<ViewProductPage> {
  final data;
  bool buyLoading = false;

  _ViewProductPageState(this.data);
  @override
  void initState() {
    super.initState();
    print(data);
    data['images'].forEach((el) {
      imgList.add(RouteApi().storageUrl + el['ipc_image']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: CheckInternetWidget(
        Container(
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
                          "${data['pc_name']}",
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
                  child: Stack(
                    children: [
                      CarouselSlider.builder(
                          itemCount: imgList.length,
                          itemBuilder: (BuildContext context, int itemIndex) =>
                              Container(
                                width: screenWidth(context),
                                height: screenHeight(context) / 1.9,
                                margin: EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color(0xfff2f3f6),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(imgList[itemIndex]))),
                              ),
                          options: CarouselOptions(
                            height: screenHeight(context) / 1.9,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          )),
                      Container(
                        height: screenHeight(context) / 1.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (var i = 0; i < imgList.length; i++)
                              Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == i
                                        ? Colors.white
                                        : Color.fromRGBO(0, 0, 0, 0.4)),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth(context),
                  margin: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Directionality(
                    textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth(context) / 1.8,
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: '${data['pc_name']}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 22,
                                  color: const Color(0xff0c0a0a),
                                )),
                            textAlign: _dir ? TextAlign.left : TextAlign.right,
                          ),
                        ),
                        Container(
                          child: Text(
                            '${data['pc_price']}\$',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 22,
                              color: const Color(0xff0c0a0a),
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: _dir ? TextAlign.left : TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      width: 323.0,
                      height: 96.0,
                      child: Text(
                        '${data['pc_disc']}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: const Color(0xff0c0a0a),
                          height: 1.4375,
                        ),
                        textAlign: _dir ? TextAlign.left : TextAlign.right,
                      ),
                    )),
                !buyLoading
                    ? Container(
                        width: screenWidth(context),
                        height: screenHeight(context) / 18,
                        margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                            top: screenHeight(context) / 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xfff9bf2d),
                        ),
                        child: FlatButton(
                          onPressed: () => this.onBuyPressed(context),
                          color: const Color(0xfff9bf2d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          child: Text(
                            _data["Buy"],
                            style: GoogleFonts.roboto(
                                fontSize: screenHeight(context) / 37,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container(
                        width: screenWidth(context),
                        height: screenHeight(context) / 18,
                        margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                            top: screenHeight(context) / 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xfff9bf2d),
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
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//---------------------Methods---------------------//
  int _current = 0;
  List imgList = [];
  void onBuyPressed(BuildContext context) {
    setState(() {
      buyLoading = true;
    });
    buy();
  }

  buy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {
      'company': data['pc_company'].toString(),
      'amount': data['pc_price'].toString()
    };
    final response = await http.post(
        RouteApi().routeGet(name: "redeem_payment"),
        headers: headers,
        body: json);
    Map body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionRedeem(
              double.parse(body['bizz'].toString()),
              double.parse(body['dollar'].toString()),
              jsonDecode(body['result'])['address'].toString(),
              body['qr']),
        ),
      );
    } else if (response.statusCode == 401) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountPage()),
      );
    }
    print(response.body);
    setState(() {
      buyLoading = false;
    });
  }
}
