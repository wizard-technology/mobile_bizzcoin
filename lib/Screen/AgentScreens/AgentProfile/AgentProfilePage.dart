import 'dart:convert';

import 'package:bizzcoin_app/Auth/CreateAccount/CreateAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/AgentProfile/ItemCompanyModel.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/ViewProduct/ViewProductPage.dart';
import 'package:bizzcoin_app/Screen/Transaction/TransactionRedeem.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class AgentProfilePage extends StatefulWidget {
  final id, name, com, address, image, phone, information;

  const AgentProfilePage(
      {Key key,
      @required this.id,
      @required this.name,
      @required this.address,
      @required this.image,
      @required this.phone,
      @required this.information,
      this.com})
      : super(key: key);
  @override
  _AgentProfilePageState createState() => _AgentProfilePageState(
        this.id,
        this.name,
        this.address,
        this.image,
        this.phone,
        this.information,
        this.com,
      );
}

class _AgentProfilePageState extends State<AgentProfilePage> {
  final id, name, com, address, image, phone, information;

  _AgentProfilePageState(this.id, this.name, this.address, this.image,
      this.phone, this.information, this.com);
  bool buyLoading = false;
  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: CheckInternetWidget(
        !loading
            ? Container(
                width: screenWidth(context),
                height: screenHeight(context),
                child: Stack(
                  children: [
                    Container(
                      width: screenWidth(context),
                      height: _checkAboutPressed
                          ? screenHeight(context) - 225
                          : screenHeight(context),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth(context),
                              margin: EdgeInsets.only(
                                  top: screenHeight(context) / 20),
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
                                    _dir
                                        ? Icon(CupertinoIcons.back)
                                        : Container(),
                                    SizedBox(
                                      width: _dir ? 5 : 0,
                                    ),
                                    Text(
                                      name,
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
                              margin: EdgeInsets.only(top: 50),
                              child: Column(
                                children: [
                                  image == null
                                      ? Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: const Color(0xffffa200),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${name.toString().toUpperCase()[0]}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 30,
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: const Color(0xffffa200),
                                            image: DecorationImage(
                                              image: NetworkImage(image),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                  Container(
                                    width: 130,
                                    margin: EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text(
                                      '$name',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth(context),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10, top: 30),
                              child: Directionality(
                                textDirection: _dir
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () => this.onShopPressed(context),
                                      child: Container(
                                        width: screenWidth(context) / 2.2,
                                        child: Column(
                                          children: [
                                            Text(
                                              _data['Shop'],
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18,
                                                color: _checkShopPressed
                                                    ? const Color(0xfff9bf2d)
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            _checkShopPressed
                                                ? Container(
                                                    width:
                                                        screenWidth(context) /
                                                            2.2,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff9bf2d),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () => this.onAboutPressed(context),
                                      child: Container(
                                        width: screenWidth(context) / 2.2,
                                        child: Column(
                                          children: [
                                            Text(
                                              _data['About'],
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18,
                                                color: _checkAboutPressed
                                                    ? const Color(0xfff9bf2d)
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            _checkAboutPressed
                                                ? Container(
                                                    width:
                                                        screenWidth(context) /
                                                            2.2,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff9bf2d),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            _checkShopPressed
                                ? buildShopTap(context, _data, _dir)
                                : buildAboutTab(context, _data, _dir),
                          ],
                        ),
                      ),
                    ),
                    _checkAboutPressed
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 215,
                              width: screenWidth(context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                color: Colors.grey.shade400,
                              ),
                              child: Column(
                                crossAxisAlignment: _dir
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20, left: 15),
                                    child: Text(
                                      _data['BuyRedeemCode'],
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18,
                                        color: const Color(0xff0c0a0a),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: screenWidth(context),
                                          height: 45.0,
                                          margin: EdgeInsets.only(
                                              top: screenHeight(context) / 30),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: const Color(0xffffffff),
                                          ),
                                          child: TextField(
                                            textAlign: _dir
                                                ? TextAlign.left
                                                : TextAlign.right,
                                            controller: _amountController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              // ignore: deprecated_member_use
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            autocorrect: false,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              hintText: _data['Amount'],
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        _checkAmount == true
                                            ? Align(
                                                alignment: _dir
                                                    ? Alignment.topLeft
                                                    : Alignment.topRight,
                                                child: Center(
                                                  child: Container(
                                                      width:
                                                          screenWidth(context),
                                                      alignment: _dir
                                                          ? Alignment.topLeft
                                                          : Alignment.topRight,
                                                      margin: EdgeInsets.only(
                                                          top: 5,
                                                          left: 0,
                                                          right: 0),
                                                      child: Text(
                                                        "${_data['EmptyAmount']}",
                                                        textAlign: _dir
                                                            ? TextAlign.left
                                                            : TextAlign.right,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                ))
                                            : SizedBox(),
                                        !buyLoading
                                            ? Container(
                                                width: screenWidth(context),
                                                height:
                                                    screenHeight(context) / 18,
                                                margin: EdgeInsets.only(
                                                    bottom: 10,
                                                    top: screenHeight(context) /
                                                        35),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xfff9bf2d),
                                                ),
                                                child: FlatButton(
                                                  onPressed: () => this
                                                      .onBuyPressed(context),
                                                  color:
                                                      const Color(0xfff9bf2d),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                  textColor: Colors.white,
                                                  padding: EdgeInsets.all(0),
                                                  child: Text(
                                                    _data["Buy"],
                                                    style: GoogleFonts.roboto(
                                                        fontSize: screenHeight(
                                                                context) /
                                                            37,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: screenWidth(context),
                                                height:
                                                    screenHeight(context) / 18,
                                                margin: EdgeInsets.only(
                                                    bottom: 10,
                                                    top: screenHeight(context) /
                                                        35),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xfff9bf2d),
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.black,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
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
              )),
      ),
    );
  }

//----------------------------Widgets------------------------------//
  bool isShopEmpty = false;
  Widget buildShopTap(BuildContext context, _data, _dir) {
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 20),
      child: Directionality(
        textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            ...listItem,
            !isShopEmpty
                ? Container(
                    height: screenHeight(context) - 410,
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
      ),
    );
  }

  Widget buildAboutTab(BuildContext context, _data, _dir) {
    return Container(
      child: Column(
        children: [
          Container(
            width: screenWidth(context),
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Directionality(
              textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0x4affed75),
                    ),
                    child: Center(
                      child: Icon(
                        FeatherIcons.mapPin,
                        color: Colors.yellow.shade800,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      child: Text(
                    '$address',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: const Color(0xff0c0a0a),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (await canLaunch('tel:$phone')) {
                await launch('tel:$phone');
              } else {
                throw 'Could not launch 07511183226';
              }
            },
            child: Container(
              width: screenWidth(context),
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Directionality(
                textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                child: Row(
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0x4affed75),
                      ),
                      child: Center(
                        child: Icon(
                          FeatherIcons.phone,
                          color: Colors.yellow.shade800,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        child: Text(
                      '$phone',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: const Color(0xff0c0a0a),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ))
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: Text(
              '$information',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: const Color(0xff000000),
                height: 1.5714285714285714,
              ),
              textAlign: _dir ? TextAlign.left : TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

//--------------------Methods-------------------//
  TextEditingController _amountController = new TextEditingController();
  bool _checkAmount = false;
  bool _checkShopPressed = true;
  List<ItemCompanyModel> listItem = [];

  bool _checkAboutPressed = false;
  void onBuyPressed(BuildContext context) {
    setState(() {
      if (_amountController.text.isEmpty) {
        _checkAmount = true;
      } else {
        _checkAmount = false;
        buy();
      }
    });
  }

  void onShopPressed(BuildContext context) {
    setState(() {
      _checkAboutPressed = false;
      _checkShopPressed = true;
    });
  }

  void onAboutPressed(BuildContext context) {
    setState(() {
      _checkAboutPressed = true;
      _checkShopPressed = false;
    });
  }

  void onProductPressed(BuildContext context, el) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProductPage(
          data: el,
        ),
      ),
    );
  }

  fetchProduct() async {
    listItem.clear();
    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    final response = await http.get(
        RouteApi().routeGet(name: "product_company") + '/$id',
        headers: headers);

    if (response.statusCode == 200) {
      jsonDecode(response.body)['product'].forEach((element) {
        listItem.add(ItemCompanyModel(
          name: element['pc_name'],
          price: element['pc_price'],
          image: RouteApi().storageUrl + element['images'][0]['ipc_image'],
          onClick: () => onProductPressed(context, element),
        ));
      });
      print(listItem);
    } else {
      throw Exception('Failed to load Channel');
    }
    setState(() {
      if (listItem.isNotEmpty) {
        isShopEmpty = true;
      }
      loading = false;
    });
  }

  buy() async {
    setState(() {
      buyLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {
      'company': com.toString(),
      'amount': _amountController.text.toString()
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
    setState(() {
      buyLoading = false;
    });
    print(response.body);
  }
}
