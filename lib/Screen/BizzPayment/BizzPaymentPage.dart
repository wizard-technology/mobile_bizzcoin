import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/BizzPayment/BizzComponent.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class BizzPaymentPage extends StatefulWidget {
  @override
  _BizzPaymentPageState createState() => _BizzPaymentPageState();
}

class _BizzPaymentPageState extends State<BizzPaymentPage> {
  Widget _first = Container();
  List<Bizzpayment> _other = [];
  bool loading = true;
  @override
  void initState() {
    getBizzpayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: CheckInternetWidget(
        Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: const Color(0xfff2f3f6),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                    )
                  ],
                )
              : SingleChildScrollView(
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
                                'Bizzpayment',
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
                        width: screenWidth(context),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 50),
                        alignment:
                            _dir ? Alignment.centerLeft : Alignment.centerRight,
                        child: Text(
                          _data['TodayValue'],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 32,
                            color: const Color(0xff0c0a0a),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      _first,
                      _other.length > 0
                          ? Container(
                              width: screenWidth(context),
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 50),
                              alignment: _dir
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                _data['Previous'],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 32,
                                  color: const Color(0xff0c0a0a),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      ..._other,
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  getBizzpayment() async {
    String url = RouteApi().routeGet(name: "bizzcoin");

    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    Response response = await get(
      url,
      headers: headers,
    );
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    List bizz = body['bizzcoin'];
    if (statusCode == 200) {
      bool f = true;
      bizz.forEach((value) {
        if (f) {
          _first = Bizzpayment(
            price: body['now'],
            state: bizz.length > 0 ? value['bz_price'] < body['now'] : null,
          );
          f = false;
        }
        _other.add(Bizzpayment(
          price: value['bz_price'],
          state: value['bz_trading'] == 1,
        ));
      });
      setState(() {
        loading = false;
      });
    }
  }
}
