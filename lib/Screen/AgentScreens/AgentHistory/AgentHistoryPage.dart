import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/RedeemCodes/ItemRedeemCode.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/Service/notification_service.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentHistortyPage extends StatefulWidget {
  @override
  _AgentHistortyPageState createState() => _AgentHistortyPageState();
}

class _AgentHistortyPageState extends State<AgentHistortyPage> {
  bool loading = true;
  List redeems = [];
  @override
  void initState() {
    super.initState();
    getRedeem();
    PushNotificationService(context: context).initialise();
  }

  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageService>(context);
    Map _data = _language.getLanguage()['data'];
    bool _dir = _language.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: SafeArea(
        child: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: !loading
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 25),
                        child: Directionality(
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth(context) / 1.3,
                                  height: 45,
                                  margin: EdgeInsets.only(
                                      top: 10,
                                      right: _dir ? 10 : 0,
                                      left: _dir ? 0 : 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffcecece),
                                  ),
                                  child: TextField(
                                    textAlign:
                                        _dir ? TextAlign.left : TextAlign.right,
                                    controller: _searchController,
                                    onChanged: getRedeemSearchText,
                                    // onSubmitted: getRedeemSearchText,
                                    // onChanged: (value) {
                                    //   if (value.length == 0) {
                                    //     getRedeem();
                                    //   }
                                    // },
                                    autocorrect: false,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          top: _dir ? 13 : 8),
                                      hintText: _data['Search'],
                                      hintStyle:
                                          GoogleFonts.roboto(fontSize: 15),
                                      suffixIcon: _dir
                                          ? GestureDetector(
                                              child: Icon(
                                                FeatherIcons.search,
                                                color: Colors.black,
                                              ),
                                            )
                                          : null,
                                      prefixIcon: !_dir
                                          ? GestureDetector(
                                              child: Icon(
                                                FeatherIcons.search,
                                                color: Colors.black,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme:
                                            ColorScheme.light().copyWith(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          FeatherIcons.calendar,
                                          size: 32,
                                        ),
                                        onPressed: () =>
                                            _selectDate(context, _data, _dir),
                                      ),
                                    ))
                              ],
                            )),
                      ),
                      ...redeems,
                      isHistoryEmpty
                          ? Container(
                              height: screenHeight(context) - 200,
                              child: Center(
                                child: Text(
                                  _data["Empty"],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          : Container()
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
    );
  }

//---------------------Widgets---------------------//
  var selectedDate = DateTime.now();
  _selectDate(BuildContext context, _data, _dir) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        getRedeemSearch(selectedDate);
      });
  }

  bool isHistoryEmpty = false;
  getRedeem() async {
    redeems = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "redeem", type: 'company');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      List redeem = body['redeem'];
      if (statusCode == 200) {
        isHistoryEmpty = false;

        redeem.forEach(
          (element) => redeems.add(
            ItemRedeemCode(
              code: element['rc_code'],
              url: element['rc_qrcode'],
              currency: element['rc_currency'],
              price: element['rc_price'],
              state: element['rc_state'],
              company: element['user']['u_first_name'] +
                  ' ' +
                  element['user']['u_second_name'],
            ),
          ),
        );
      }
    }
    setState(() {
      if (redeems.length == 0) {
        isHistoryEmpty = true;
      }
      loading = false;
    });
  }

  getRedeemSearch(date) async {
    redeems = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String url = RouteApi().routeGet(name: "redeem_search", type: 'company');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      Response response =
          await post(url, headers: headers, body: {'date': date.toString()});
      int statusCode = response.statusCode;
      Map body = jsonDecode(response.body);

      List redeem = body['redeem'];
      if (statusCode == 200) {
        isHistoryEmpty = false;

        redeem.forEach(
          (element) => redeems.add(
            ItemRedeemCode(
              code: element['rc_code'],
              url: element['rc_qrcode'],
              currency: element['rc_currency'],
              price: element['rc_price'],
              state: element['rc_state'],
              company: element['user']['u_first_name'] +
                  ' ' +
                  element['user']['u_second_name'],
            ),
          ),
        );
      }
    }
    setState(() {
      if (redeems.length == 0) {
        isHistoryEmpty = true;
      }
      loading = false;
    });
  }

  bool isSearch = true;
  getRedeemSearchText(date) async {
    if (isSearch) {
      isSearch = false;
      setState(() {
        redeems = [];
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      if (token != null) {
        String url = RouteApi().routeGet(name: "search", type: 'company');
        Map<String, String> headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };

        Response response = await post(url,
            headers: headers, body: {'search': date.toString()});
        int statusCode = response.statusCode;
        Map body = jsonDecode(response.body);

        List redeem = body['redeem'];
        if (statusCode == 200) {
          isHistoryEmpty = false;
          redeem.forEach(
            (element) => redeems.add(
              ItemRedeemCode(
                code: element['rc_code'],
                url: element['rc_qrcode'],
                currency: element['rc_currency'],
                price: element['rc_price'],
                state: element['rc_state'],
                company: element['user']['u_first_name'] +
                    ' ' +
                    element['user']['u_second_name'],
              ),
            ),
          );
        }
      }
      setState(() {
        if (redeems.length == 0) {
          isHistoryEmpty = true;
        }
        loading = false;
        isSearch = true;
      });
    }
  }

//---------------------Methods---------------------//
  TextEditingController _searchController = new TextEditingController();
}
