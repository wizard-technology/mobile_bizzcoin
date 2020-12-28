import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/RedeemCodes/ItemRedeemCode.dart';

class RedeemCodesPage extends StatefulWidget {
  @override
  _RedeemCodesPageState createState() => _RedeemCodesPageState();
}

class _RedeemCodesPageState extends State<RedeemCodesPage> {
  List redeems = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getRedeem();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
        backgroundColor: const Color(0xfff2f3f6),
        body: CheckInternetWidget(
          loading
              ? Container(
                  width: screenWidth(context),
                  height: screenHeight(context),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Container(
                          width: screenWidth(context),
                          margin:
                              EdgeInsets.only(top: screenHeight(context) / 20),
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
                                  _data["RedeemCodes"],
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
                        SizedBox(
                          height: 20,
                        ),
                        ...redeems,
                        isRedeemCodeEmpty
                            ? Container(
                                height: screenHeight(context) - 150,
                                child: Center(
                                  child: Text(
                                    _data["Empty"],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            : Container()
                      ])))
              : Center(
                  child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: const Color(0xfff2f3f6),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                )),
        ));
  }

//---------------------Methods---------------------//
  bool isRedeemCodeEmpty = false;
  getRedeem() async {
    setState(() {
      loading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "get_redeem");
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      List redeem = body['redeem'];
      if (statusCode == 200) {
        redeem.forEach(
          (element) => redeems.add(
            ItemRedeemCode(
              code: element['rc_code'],
              url: element['rc_qrcode'],
              currency: element['rc_currency'],
              price: element['rc_price'],
              state: element['rc_state'],
              company: element['company']['company']['co_name'],
            ),
          ),
        );
        if (redeem.length == 0) {
          isRedeemCodeEmpty = true;
        }
      }
    }
    setState(() {
      loading = true;
    });
  }
}
