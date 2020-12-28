import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/Products/ProductsPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  final data;

  const EditProductPage({Key key, this.data}) : super(key: key);
  @override
  _EditProductPageState createState() => _EditProductPageState(this.data);
}

class _EditProductPageState extends State<EditProductPage> {
  final data;
  _EditProductPageState(this.data);
  @override
  void initState() {
    super.initState();
    _nameController.text = data['pc_name'];
    _priceController.text = data['pc_price'].toString();
    _descriptionController.text = data['pc_disc'];
    data['images'].forEach((img) {
      imgList.add(RouteApi().storageUrl + img['ipc_image']);
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
                          _data["EditProduct"],
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
                      Positioned(
                        right: 30,
                        top: 30,
                        child: InkWell(
                          onTap: () =>
                              this.onDeletePressed(context, _data, _dir),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: Colors.black38,
                            ),
                            child: Center(
                              child: Icon(
                                FeatherIcons.trash2,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth(context),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: screenWidth(context) / 1.7,
                            height: 45.0,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xfff2f3f6),
                            ),
                            child: TextField(
                              textAlign:
                                  _dir ? TextAlign.left : TextAlign.right,
                              controller: _nameController,
                              autocorrect: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 8, right: 8),
                                hintText: _data['ProductName'],
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          _checkName == true
                              ? Align(
                                  alignment: _dir
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  child: Center(
                                    child: Container(
                                        width: screenWidth(context) / 1.7,
                                        margin: EdgeInsets.only(
                                            top: 5, left: 0, right: 0),
                                        child: Text(
                                          _data['EmptyProductName'],
                                          textAlign: _dir
                                              ? TextAlign.left
                                              : TextAlign.right,
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ))
                              : SizedBox(),
                        ],
                      ),
                      Column(children: [
                        Container(
                          width: screenWidth(context) / 3.7,
                          height: 45.0,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xfff2f3f6),
                          ),
                          child: TextField(
                            textAlign: _dir ? TextAlign.left : TextAlign.right,
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            autocorrect: false,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 8, right: 8),
                              hintText: _data['Price'],
                              hintStyle: GoogleFonts.roboto(
                                  fontSize: 15, color: Colors.grey),
                            ),
                          ),
                        ),
                        _checkPrice == true
                            ? Align(
                                alignment: _dir
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Center(
                                  child: Container(
                                      width: screenWidth(context) / 3.7,
                                      margin: EdgeInsets.only(
                                          top: 5, left: 0, right: 0),
                                      child: Text(
                                        _data["EmptyPrice"],
                                        textAlign: _dir
                                            ? TextAlign.left
                                            : TextAlign.right,
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ))
                            : SizedBox(),
                      ])
                    ],
                  ),
                ),
                Container(
                  width: screenWidth(context),
                  height: 85.0,
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xfff2f3f6),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _descriptionController,
                    autocorrect: false,
                    autofocus: false,
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 8, right: 8, top: 5),
                      hintText: _data['Description'],
                      hintStyle:
                          GoogleFonts.roboto(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                ),
                _checkDescription == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context),
                              margin:
                                  EdgeInsets.only(top: 5, left: 20, right: 20),
                              child: Text(
                                _data['EmptyDescription'],
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context),
                  height: 40.0,
                  margin:
                      EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xff0c0a0a),
                  ),
                  child: FlatButton(
                    onPressed: () => this.onSavePressed(context),
                    color: const Color(0xff0c0a0a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Text(
                      _data["Save"],
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
        ),
      ),
    );
  }

//---------------------Widget---------------------//
  void buildDeleteAlert(BuildContext context, _data, _dir) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
          child: AlertDialog(
            title: Text(_data["DeleteProductTitle"]),
            content: Text(_data["DeleteProductDescription"]),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                textColor: Colors.black,
                child: Text(_data["Back"]),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                color: Colors.black12,
                textColor: Colors.red,
                child: Text(_data["Delete"]),
                onPressed: () => delete(context),
              ),
            ],
          ),
        );
      },
    );
  }

  //---------------------Methods---------------------//
  int _current = 0;
  List imgList = [
    // "assets/wach.png",
    // "assets/KurdistanFlag.png",
    // "assets/iraq.png"
  ];

  TextEditingController _priceController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  bool _checkPrice = false;
  bool _checkName = false;
  bool _checkDescription = false;
  void onSavePressed(BuildContext context) {
    setState(() {
      if (_descriptionController.text.isEmpty) {
        _checkDescription = true;
      } else {
        _checkDescription = false;
      }

      if (_priceController.text.isEmpty) {
        _checkPrice = true;
      } else {
        _checkPrice = false;
      }

      if (_nameController.text.isEmpty) {
        _checkName = true;
      } else {
        _checkName = false;
      }

      if (_checkDescription == false &&
          _checkPrice == false &&
          _checkName == false) {
        update(context);
      }
    });
  }

  update(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "updateProduct", type: 'company');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {
      "id": data['id'].toString(),
      "name": _nameController.text.toString(),
      "disc": _descriptionController.text.toString(),
      "price": _priceController.text.toString(),
    };

    final response = await http.post(url, headers: headers, body: json);
    Map body = jsonDecode(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      print(body);
    }
    print(response.statusCode);
  }

  delete(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "deleteProduct", type: 'company');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {
      "id": data['id'].toString(),
    };
    final response = await http.post(url, headers: headers, body: json);
    Map body = jsonDecode(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductsPage()),
      );
    }
    print(body);
  }

  void onDeletePressed(BuildContext context, _data, _dir) {
    buildDeleteAlert(
      context,
      _data,
      _dir,
    );
  }
}
