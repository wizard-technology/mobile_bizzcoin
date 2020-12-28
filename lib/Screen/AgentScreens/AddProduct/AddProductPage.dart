import 'dart:convert';
import 'dart:io';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/Products/ProductsPage.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool addProductLoading = false;
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
                          _data["AddProduct"],
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
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: imagePath.length == 0
                      ? () => this.onAddPhotoPressed(context)
                      : () {},
                  child: Container(
                    width: screenWidth(context),
                    height: screenHeight(context) / 1.9,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xfff2f3f6),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imagePath.length != 0
                                ? FileImage(imagePath[imagePath.length - 1])
                                : AssetImage('assets/image.png'))),
                    child: imagePath.length == 0
                        ? Center(
                            child: Text(
                              _data['AddPhoto'],
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: const Color(0xffcecece),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : Container(),
                  ),
                ),
                imagePath.length != 0
                    ? Container(
                        width: screenWidth(context),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Directionality(
                          textDirection:
                              _dir ? TextDirection.ltr : TextDirection.rtl,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var i = 0; i < imagePath.length; i++)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: i == 0
                                        ? () => this.onPlusPressed(context)
                                        : () => this.onImagePressed(context),
                                    child: Container(
                                        width: screenWidth(context) / 5,
                                        height: screenHeight(context) / 7,
                                        margin: EdgeInsets.only(
                                            right: _dir ? 10 : 0,
                                            left: !_dir ? 10 : 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: const Color(0xfff2f3f6),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: i != 0
                                                  ? FileImage(imagePath[i - 1])
                                                  : AssetImage(
                                                      'assets/image.png')),
                                        ),
                                        child: i == 0
                                            ? Center(
                                                child: Icon(FeatherIcons.plus),
                                              )
                                            : Container()),
                                  )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
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
                !addProductLoading
                    ? Container(
                        width: screenWidth(context),
                        height: 40.0,
                        margin: EdgeInsets.only(
                            top: 15, bottom: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xfff9bf2d),
                        ),
                        child: FlatButton(
                          onPressed: () => this.onAddProductPressed(context),
                          color: const Color(0xfff9bf2d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          child: Text(
                            _data["AddProduct"],
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container(
                        width: screenWidth(context),
                        height: 40.0,
                        margin: EdgeInsets.only(
                            top: 15, bottom: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
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
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  bool _checkPrice = false;
  bool _checkName = false;
  bool _checkDescription = false;
  void onAddProductPressed(BuildContext context) {
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
        addProductLoading = true;
        addProduct(context);
      }
    });
  }

  int indexPath = 0;
  List<File> imagePath = new List<File>();
  Future<void> onAddPhotoPressed(BuildContext context) async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        imagePath.add(_image);
      });
    }
  }

  void onPlusPressed(BuildContext context) {
    onAddPhotoPressed(context);
  }

  void onImagePressed(BuildContext context) {}

  addProduct(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "addProduct", type: 'company');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {
      "name": _nameController.text.toString(),
      "disc": _descriptionController.text.toString(),
      "price": _priceController.text.toString(),
    };

    final response = await http.post(url, headers: headers, body: json);
    Map body = jsonDecode(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      imagePath.forEach((element) {
        upload(element, body['id']);
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProductsPage()),
    );
    setState(() {
      addProductLoading = false;
    });
    print(body);
  }

  upload(File imageFile, id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(RouteApi().routeGet(name: "addImage", type: 'company'));
    print(uri);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields.addAll({"id": id.toString()});
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    // send
    var response = await request.send();
    print(response.statusCode);
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
