import 'dart:convert';
import 'package:bizzcoin_app/Auth/CreateAccount/CreateAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/Transaction/TransactionPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'Cart.dart';

class AddToCartPage extends StatefulWidget {
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  @override
  void initState() {
    super.initState();
    getCart();
  }

  bool checkOut = false;
  List<Cart> data = new List<Cart>();
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return !loading
        ? Scaffold(
            backgroundColor: const Color(0xfff2f3f6),
            body: !checkIfCartEmpty
                ? buildNoItemToCart(context, _dir, _data)
                : CheckInternetWidget(
                    Container(
                      width: screenWidth(context),
                      height: screenHeight(context),
                      child: !xLoading
                          ? SingleChildScrollView(
                              child: Column(
                              children: [
                                Container(
                                  width: screenWidth(context) / 1.2,
                                  alignment: _dir
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Text(
                                    _data['Cart'],
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 25,
                                      color: const Color(0xff0c0a0a),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                ...data
                              ],
                            ))
                          : Center(
                              child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: const Color(0xfff2f3f6),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            )),
                    ),
                  ),
            bottomNavigationBar: checkIfCartEmpty
                ? Container(
                    width: screenWidth(context),
                    height: screenHeight(context) / 4.5,
                    decoration: BoxDecoration(
                        color: Color(0xcecececece),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth(context) / 1.4,
                          margin: EdgeInsets.only(top: 30),
                          child: Directionality(
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                !loading
                                    ? Text(
                                        '${_dollarPrice.toStringAsFixed(2)}\$ Total',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 20,
                                          color: const Color(0xff0c0a0a),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    : loadingWidget(
                                        context, screenWidth(context) / 4, 13),
                                !loading
                                    ? Text(
                                        '${_bizzPrice.toStringAsFixed(3)} Bizz',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 20,
                                          color: const Color(0xff0c0a0a),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    : loadingWidget(
                                        context, screenWidth(context) / 4, 13),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth(context) / 1.4,
                          height: screenHeight(context) / 18,
                          margin: EdgeInsets.only(
                              bottom: screenHeight(context) / 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xff0c0a0a),
                          ),
                          child: !_checkoutLoading
                              ? FlatButton(
                                  onPressed: checkOut
                                      ? null
                                      : () => this
                                          .onCheckOutPressed(context, _data),
                                  color: const Color(0xff0c0a0a),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    _data["CheckOut"],
                                    style: GoogleFonts.roboto(
                                        fontSize: screenHeight(context) / 37,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Center(
                                  child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: const Color(0xfff2f3f6),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                )),
                        ),
                      ],
                    ))
                : null,
          )
        : Center(
            child: Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              backgroundColor: const Color(0xfff2f3f6),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ));
  }

//---------------------Widgets---------------------//
  bool checkIfCartEmpty = true;
  Widget buildNoItemToCart(BuildContext context, _dir, _data) {
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
                FeatherIcons.shoppingBag,
                color: const Color(0xfff9bf2d),
                size: 80,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight(context) / 8),
              child: Text(
                _data["EmptyCart"],
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
                  _data['GoStartShoping'],
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: const Color(0xfff9bf2d),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }

  bool loading = true;
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

  double _bizzPrice;
  double _dollarPrice;
  void onPlusPressed(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    List<Cart> secondList = data
        .map((item) => new Cart(
              id: item.id,
              name: item.name,
              countItem: item.countItem,
              image: item.image,
              itemPrice: item.itemPrice,
              bizzPrice: item.bizzPrice,
              finalPrice: item.finalPrice,
              onXPressed: item.onXPressed,
              onPlusPressed: item.onPlusPressed,
              onMinusPressed: item.onMinusPressed,
            ))
        .toList();

    String url = RouteApi().routeGet(name: "amount");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {'doc': id.toString(), 'tran': 'p'};
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);

    if (statusCode == 200) {
      secondList[secondList.indexWhere((element) => element.id == id)]
          .countItem = body['cart']['c_amount'];
      secondList[secondList.indexWhere((element) => element.id == id)]
          .finalPrice = body['cart']['c_price_all'];
      secondList[secondList.indexWhere((element) => element.id == id)]
          .bizzPrice = body['cart']['c_price_all'] / body['bizzcoin'];
      _bizzPrice = body['total'] / 1;
      _dollarPrice = body['dollar'] / 1;
      setState(() {
        data = [...secondList];
      });
    }
  }

  onMinusPressed(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    List<Cart> secondList = data
        .map((item) => new Cart(
              id: item.id,
              name: item.name,
              countItem: item.countItem,
              image: item.image,
              itemPrice: item.itemPrice,
              bizzPrice: item.bizzPrice,
              finalPrice: item.finalPrice,
              onXPressed: item.onXPressed,
              onPlusPressed: item.onPlusPressed,
              onMinusPressed: item.onMinusPressed,
            ))
        .toList();
    int count = secondList[secondList.indexWhere((element) => element.id == id)]
        .countItem;
    if (count > 1) {
      String url = RouteApi().routeGet(name: "amount");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Map json = {'doc': id.toString(), 'tran': 'm'};
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      if (statusCode == 200) {
        List<Cart> secondList = data
            .map((item) => new Cart(
                  id: item.id,
                  name: item.name,
                  countItem: item.countItem,
                  image: item.image,
                  itemPrice: item.itemPrice,
                  bizzPrice: item.bizzPrice,
                  finalPrice: item.finalPrice,
                  onXPressed: item.onXPressed,
                  onPlusPressed: item.onPlusPressed,
                  onMinusPressed: item.onMinusPressed,
                ))
            .toList();
        secondList[secondList.indexWhere((element) => element.id == id)]
            .countItem = body['cart']['c_amount'];
        secondList[secondList.indexWhere((element) => element.id == id)]
            .finalPrice = body['cart']['c_price_all'];
        secondList[secondList.indexWhere((element) => element.id == id)]
            .bizzPrice = body['cart']['c_price_all'] / body['bizzcoin'];
        _bizzPrice = body['total'] / 1;
        _dollarPrice = body['dollar'] / 1;

        setState(() {
          data = [...secondList];
        });
      }
    }
  }

  bool xLoading = false;
  onXPressed(id) async {
    setState(() {
      xLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "deleteCart");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {'doc': id.toString()};
    Response delete = await post(url, headers: headers, body: json);
    int statusCodeDelete = delete.statusCode;
    Map bodyDelete = jsonDecode(delete.body);
    if (statusCodeDelete == 200) {
      setState(() {
        data.removeWhere((element) => element.id == id);
        checkIfCartEmpty = data.isNotEmpty;
        _bizzPrice = data.length > 0 ? bodyDelete['total'] : 0.0;
      });
    }

    setState(() {
      xLoading = false;
    });
  }

  bool _checkoutLoading = false;
  void onCheckOutPressed(BuildContext context, data) async {
    setState(() {
      _checkoutLoading = true;
      checkOut = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "payment");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Response response = await post(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);
      print(url);
      if (statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionPage(_bizzPrice, _dollarPrice,
                jsonDecode(body['result'])['address'].toString(), body['qr']),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => WebviewPayment(
        //       url: jsonDecode(body['result'])['url'].toString(),
        //     ),
        //   ),
        // );
      } else {
        String _language = prefs.getString('lang').toString();

        if (_language == 'kus') {
          _showMyDialog(body['product']['p_name_ku'], false, data);
        } else if (_language == 'en') {
          _showMyDialog(body['product']['p_name'], true, data);
        } else if (_language == 'per') {
          _showMyDialog(body['product']['p_name_pr'], false, data);
        } else if (_language == 'ar') {
          _showMyDialog(body['product']['p_name_ar'], false, data);
        } else if (_language == 'kuk') {
          _showMyDialog(body['product']['p_name_kr'], true, data);
        }
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountPage()),
      );
    }
    setState(() {
      _checkoutLoading = false;
      checkOut = false;
    });
  }

  getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _language = prefs.getString('lang').toString();
    String token = prefs.getString('token');

    if (token != null) {
      String url = RouteApi().routeGet(name: "cart");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      if (statusCode == 200) {
        List cart = body['cart'];
        _bizzPrice = body['total'] / 1;
        _dollarPrice = body['dollar'] / 1;
        setState(() {
          checkIfCartEmpty = cart.isNotEmpty;
          cart.forEach((element) {
            if (_language == 'kus') {
              data.add(
                Cart(
                  id: element['id'],
                  name: element['product']['p_name_ku'],
                  countItem: element['c_amount'],
                  image: NetworkImage(
                      "${RouteApi().storageUrl}${element['product']['p_image']}"),
                  itemPrice: element['c_price'] / 1,
                  bizzPrice: (element['c_price_all'] / body['bizzcoin']),
                  finalPrice: element['c_price_all'] / 1,
                  onXPressed: () => onXPressed(element['id']),
                  onPlusPressed: () => onPlusPressed(element['id']),
                  onMinusPressed: () => onMinusPressed(element['id']),
                ),
              );
            } else if (_language == 'en') {
              data.add(
                Cart(
                  id: element['id'],
                  name: element['product']['p_name'],
                  countItem: element['c_amount'],
                  image: NetworkImage(
                      "${RouteApi().storageUrl}${element['product']['p_image']}"),
                  itemPrice: element['c_price'] / 1,
                  bizzPrice: (element['c_price_all'] / body['bizzcoin']),
                  finalPrice: element['c_price_all'] / 1,
                  onXPressed: () => onXPressed(element['id']),
                  onPlusPressed: () => onPlusPressed(element['id']),
                  onMinusPressed: () => onMinusPressed(element['id']),
                ),
              );
            } else if (_language == 'per') {
              data.add(
                Cart(
                  id: element['id'],
                  name: element['product']['p_name_pr'],
                  countItem: element['c_amount'],
                  image: NetworkImage(
                      "${RouteApi().storageUrl}${element['product']['p_image']}"),
                  itemPrice: element['c_price'] / 1,
                  bizzPrice: (element['c_price_all'] / body['bizzcoin']),
                  finalPrice: element['c_price_all'] / 1,
                  onXPressed: () => onXPressed(element['id']),
                  onPlusPressed: () => onPlusPressed(element['id']),
                  onMinusPressed: () => onMinusPressed(element['id']),
                ),
              );
            } else if (_language == 'ar') {
              data.add(
                Cart(
                  id: element['id'],
                  name: element['product']['p_name_ar'],
                  countItem: element['c_amount'],
                  image: NetworkImage(
                      "${RouteApi().storageUrl}${element['product']['p_image']}"),
                  itemPrice: element['c_price'] / 1,
                  bizzPrice: (element['c_price_all'] / body['bizzcoin']),
                  finalPrice: element['c_price_all'] / 1,
                  onXPressed: () => onXPressed(element['id']),
                  onPlusPressed: () => onPlusPressed(element['id']),
                  onMinusPressed: () => onMinusPressed(element['id']),
                ),
              );
            } else if (_language == 'kuk') {
              data.add(
                Cart(
                  id: element['id'],
                  name: element['product']['p_name_kr'],
                  countItem: element['c_amount'],
                  image: NetworkImage(
                      "${RouteApi().storageUrl}${element['product']['p_image']}"),
                  itemPrice: element['c_price'] / 1,
                  bizzPrice: (element['c_price_all'] / body['bizzcoin']),
                  finalPrice: element['c_price_all'] / 1,
                  onXPressed: () => onXPressed(element['id']),
                  onPlusPressed: () => onPlusPressed(element['id']),
                  onMinusPressed: () => onMinusPressed(element['id']),
                ),
              );
            }
          });
        });
      }
    } else {
      setState(() {
        checkIfCartEmpty = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _showMyDialog(name, dir, data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            content: Container(
              margin: EdgeInsets.all(10),
              child: Directionality(
                textDirection: dir ? TextDirection.ltr : TextDirection.rtl,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => {Navigator.of(context).pop()},
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
                        "${data['OutOfStock']} " + name,
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
}
