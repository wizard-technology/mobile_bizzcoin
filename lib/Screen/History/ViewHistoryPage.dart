import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/History/ViewOneItem.dart';
import 'package:bizzcoin_app/Screen/ViewItemBuy/ViewItemBuy.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewHistoryPage extends StatefulWidget {
  final id;
  const ViewHistoryPage({Key key, this.id}) : super(key: key);

  @override
  _ViewHistoryPageState createState() => _ViewHistoryPageState(this.id);
}

class _ViewHistoryPageState extends State<ViewHistoryPage> {
  List product = [];
  final id;
  _ViewHistoryPageState(this.id);
  @override
  void initState() {
    getProduct();
    super.initState();
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
                                  _data['OrderDetail'],
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
                    ...product
                  ])))),
        ));
  }

//---------------------Methods---------------------//

  void onItemPressed(BuildContext context, data, type, bizz) async {
    String lang = await RouteApi().getLanguage();
    if (lang == 'kus') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewItemBuyPgae(
            date: convertStrToDate(data['created_at']),
            info: type ? data['info']['ci_code'] : '',
            name: type
                ? data['info']['product']['p_name_ku']
                : data['product']['p_name_ku'],
            price: type
                ? data['info']['product']['p_price']
                : data['product']['p_price'],
            bizz: bizz,
            image:
                "${RouteApi().storageUrl}${type ? data['info']['product']['p_image'] : data['product']['p_image']}",
          ),
        ),
      );
    } else if (lang == 'en') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewItemBuyPgae(
            date: convertStrToDate(data['created_at']),
            info: type ? data['info']['ci_code'] : "",
            name: type
                ? data['info']['product']['p_name']
                : data['product']['p_name'],
            price: type
                ? data['info']['product']['p_price']
                : data['product']['p_price'],
            bizz: bizz,
            image:
                "${RouteApi().storageUrl}${type ? data['info']['product']['p_image'] : data['product']['p_image']}",
          ),
        ),
      );
    } else if (lang == 'kuk') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewItemBuyPgae(
            date: convertStrToDate(data['created_at']),
            info: type ? data['info']['ci_code'] : data['info']['ci_code'],
            name: type
                ? data['info']['product']['p_name_kr']
                : data['info']['product']['p_name_kr'],
            price: type
                ? data['info']['product']['p_price']
                : data['info']['product']['p_price'],
            bizz: bizz,
            image:
                "${RouteApi().storageUrl}${type ? data['info']['product']['p_image'] : data['product']['p_image']}",
          ),
        ),
      );
    } else if (lang == 'ar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewItemBuyPgae(
            date: convertStrToDate(data['created_at']),
            info: type ? data['info']['ci_code'] : '',
            name: type
                ? data['info']['product']['p_name_ar']
                : data['product']['p_name_ar'],
            price: type
                ? data['info']['product']['p_price']
                : data['product']['p_price'],
            bizz: bizz,
            image:
                "${RouteApi().storageUrl}${type ? data['info']['product']['p_image'] : data['product']['p_image']}",
          ),
        ),
      );
    } else if (lang == 'per') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewItemBuyPgae(
            date: convertStrToDate(data['created_at']),
            info: type ? data['info']['ci_code'] : '',
            name: type
                ? data['info']['product']['p_name_pr']
                : data['product']['p_name_pr'],
            price: type
                ? data['info']['product']['p_price']
                : data['product']['p_price'],
            bizz: bizz,
            image:
                "${RouteApi().storageUrl}${type ? data['info']['product']['p_image'] : data['product']['p_image']}",
          ),
        ),
      );
    }
  }

  getProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "history_item") + id.toString();
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      String lang = await RouteApi().getLanguage();

      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);
      List pro = body['product'];
      bool type = body['type'];
      if (statusCode == 200) {
        print(body);
        if (body['type']) {
          pro.forEach((element) {
            if (lang == 'kus') {
              product.add(OneItemView(
                date: convertStrToDate(element['info']['created_at']),
                name: element['info']['product']['p_name_ku'],
                price: element['info']['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['info']['product']['p_image']}",
              ));
            } else if (lang == 'en') {
              product.add(OneItemView(
                date: convertStrToDate(element['info']['created_at']),
                name: element['info']['product']['p_name'],
                price: element['info']['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['info']['product']['p_image']}",
              ));
            } else if (lang == 'kuk') {
              product.add(OneItemView(
                date: convertStrToDate(element['info']['created_at']),
                name: element['info']['product']['p_name_kr'],
                price: element['info']['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['info']['product']['p_image']}",
              ));
            } else if (lang == 'ar') {
              product.add(OneItemView(
                date: convertStrToDate(element['info']['created_at']),
                name: element['info']['product']['p_name_ar'],
                price: element['info']['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['info']['product']['p_image']}",
              ));
            } else if (lang == 'per') {
              product.add(OneItemView(
                date: convertStrToDate(element['info']['created_at']),
                name: element['info']['product']['p_name_pr'],
                price: element['info']['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['info']['product']['p_image']}",
              ));
            }
          });
        } else {
          pro.forEach((element) {
            if (lang == 'kus') {
              product.add(OneItemView(
                date: convertStrToDate(element['created_at']),
                name: element['product']['p_name_ku'],
                price: element['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['product']['p_image']}",
              ));
            } else if (lang == 'en') {
              product.add(OneItemView(
                date: convertStrToDate(element['created_at']),
                name: element['product']['p_name'],
                price: element['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['product']['p_image']}",
              ));
            } else if (lang == 'kuk') {
              product.add(OneItemView(
                date: convertStrToDate(element['created_at']),
                name: element['product']['p_name_kr'],
                price: element['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['product']['p_image']}",
              ));
            } else if (lang == 'ar') {
              product.add(OneItemView(
                date: convertStrToDate(element['created_at']),
                name: element['product']['p_name_ar'],
                price: element['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['product']['p_image']}",
              ));
            } else if (lang == 'per') {
              product.add(OneItemView(
                date: convertStrToDate(element['created_at']),
                name: element['product']['p_name_pr'],
                price: element['product']['p_price'],
                onClick: () =>
                    onItemPressed(context, element, type, body['bizzcoin']),
                image:
                    "${RouteApi().storageUrl}${element['product']['p_image']}",
              ));
            }
          });
        }
        setState(() {});
      }
    }
  }
}
