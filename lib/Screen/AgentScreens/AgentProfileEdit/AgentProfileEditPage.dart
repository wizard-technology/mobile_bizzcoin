import 'dart:convert';
import 'dart:io';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class AgentProfileEditPage extends StatefulWidget {
  @override
  _AgentProfileEditPageState createState() => _AgentProfileEditPageState();
}

class _AgentProfileEditPageState extends State<AgentProfileEditPage> {
  String imageUrl;
  @override
  void initState() {
    super.initState();
    account();
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
                          _data["EditAccount"],
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
                  onTap: () => this.onUploadPressed(context),
                  child: Container(
                    width: screenWidth(context) / 3,
                    height: screenHeight(context) / 6,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                        border: Border.all(
                            width: 1.0, color: const Color(0xfff9bf2d)),
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: image != null
                                ? FileImage(image)
                                : imageUrl == null
                                    ? AssetImage('assets/BizzPaymentlogo.png')
                                    : NetworkImage(imageUrl))),
                    child: Center(
                      child: Icon(FeatherIcons.userPlus,
                          size: 40, color: const Color(0xfff9bf2d)),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _nameController,
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data['Name'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkName == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _data['EmptyName'],
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      // ignore: deprecated_member_use
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data['PhoneNumber'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkPhone == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                "$phoneError",
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _emailController,
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data["Email"],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkEmail == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              alignment:
                                  _dir ? Alignment.topLeft : Alignment.topRight,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                "$emailError",
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                    width: screenWidth(context) / 1.5,
                    height: 45.0,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffcecece),
                    ),
                    child: Directionality(
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        child: DropdownButton(
                          underline: Container(),
                          value: _selectedCityList,
                          isExpanded: true,
                          icon: Padding(
                            padding: EdgeInsets.only(
                                right: _dir ? 12 : 0, left: !_dir ? 12 : 0),
                            child: Icon(FeatherIcons.chevronDown),
                          ),
                          items: _cityList
                              .map((code) => new DropdownMenuItem(
                                  value: code.id,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: _dir ? 14 : 14,
                                        left: _dir ? 8 : 14),
                                    child: Container(
                                        alignment: _dir
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                        child: new Text(code.name)),
                                  )))
                              .toList(),
                          onChanged: (change) {
                            setState(() {
                              _selectedCityList = change;
                            });
                          },
                        ))),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 45.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                  ),
                  child: TextField(
                    textAlign: _dir ? TextAlign.left : TextAlign.right,
                    controller: _streetController,
                    autocorrect: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      hintText: _data['Street'],
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkStreet == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _data['EmptyStreet'],
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                Container(
                  width: screenWidth(context) / 1.5,
                  height: 85.0,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
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
                      hintStyle: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                ),
                _checkDescription == true
                    ? Align(
                        alignment:
                            _dir ? Alignment.topLeft : Alignment.topRight,
                        child: Center(
                          child: Container(
                              width: screenWidth(context) / 1.5,
                              margin:
                                  EdgeInsets.only(top: 5, left: 0, right: 0),
                              child: Text(
                                _data['EmptyDescription'],
                                textAlign:
                                    _dir ? TextAlign.left : TextAlign.right,
                                style: TextStyle(color: Colors.red),
                              )),
                        ))
                    : SizedBox(),
                !updateLoading
                    ? Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 15, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff0c0a0a),
                        ),
                        child: FlatButton(
                          onPressed: () => this.onEditPressed(context, _data),
                          color: const Color(0xff0c0a0a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          child: Text(
                            _data["Update"],
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container(
                        width: screenWidth(context) / 1.5,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff0c0a0a),
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
                        ))),
                _checkUpdate
                    ? Center(
                        child: Container(
                          width: screenWidth(context) / 1.5,
                          margin: EdgeInsets.only(top: 5, left: 0, right: 0),
                          child: Center(
                            child: Text(
                              _data["UpdateSuccess"],
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  List<CityModel> _cityList = [CityModel(id: 0, name: 'City')];
  int _selectedCityList = 0;
  bool _checkPhone = false;
  bool _checkName = false;
  bool _checkEmail = false;
  bool _checkStreet = false;
  bool _checkDescription = false;
  String phoneError = "";
  String emailError = "";
  // bool _obscureText = true;
  // bool _obscureTextRe = true;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  bool updateLoading = false;
  bool _checkUpdate = false;
  File image;
  Future<void> onUploadPressed(BuildContext context) async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = _image;
      });
    }
  }

  void onEditPressed(BuildContext context, _data) {
    if (_phoneController.text.toString().isEmpty) {
      setState(() {
        _checkPhone = true;
        phoneError = _data['EmptyPhone'];
      });
    } else if (_phoneController.text.toString().length != 11) {
      setState(() {
        _checkPhone = true;
        phoneError = _data['IncorrectPhone'];
      });
    } else {
      setState(() {
        _checkPhone = false;
      });
    }

    if (_nameController.text.toString().isEmpty) {
      setState(() {
        _checkName = true;
      });
    } else {
      setState(() {
        _checkName = false;
      });
    }

    if (_streetController.text.toString().isEmpty) {
      setState(() {
        _checkStreet = true;
      });
    } else {
      setState(() {
        _checkStreet = false;
      });
    }

    if (_descriptionController.text.toString().isEmpty) {
      setState(() {
        _checkDescription = true;
      });
    } else {
      setState(() {
        _checkDescription = false;
      });
    }

    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    if (_emailController.text.toString().isEmpty) {
      setState(() {
        _checkEmail = true;
        emailError = _data['EmptyEmail'];
      });
    } else if (!regExp.hasMatch(_emailController.text.toString())) {
      _checkEmail = true;
      emailError = _data['IncorrectEmail'];
    } else {
      setState(() {
        _checkEmail = false;
      });
    }

//Code heare
    if (!_checkEmail &&
        !_checkName &&
        !_checkDescription &&
        !_checkStreet &&
        !_checkPhone) {
      setState(() {
        updateLoading = true;
      });
      save(context);
    }
  }

  save(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "update", type: 'company');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map json = {
      "company_name": _nameController.text.toString(),
      "phone_account": _phoneController.text.toString(),
      "email": _emailController.text.toString(),
      "address": _streetController.text.toString(),
      "city": _selectedCityList.toString(),
      "information": _descriptionController.text.toString(),
    };
    if (image != null) {
      upload(image);
    }
    final response = await http.post(url, headers: headers, body: json);
    // Map body = jsonDecode(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      setState(() {
        _checkUpdate = true;
      });
    }
    setState(() {
      updateLoading = false;
    });
  }

  account() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "company", type: 'company');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String _language = prefs.getString('lang').toString();
    final response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    if (statusCode == 200) {
      setState(() {
        jsonDecode(response.body)['city'].forEach((element) {
          if (_language == 'kus') {
            _cityList
                .add(CityModel(id: element['id'], name: element['ct_name_ku']));
          } else if (_language == 'en') {
            _cityList
                .add(CityModel(id: element['id'], name: element['ct_name']));
          } else if (_language == 'per') {
            _cityList
                .add(CityModel(id: element['id'], name: element['ct_name_pr']));
          } else if (_language == 'ar') {
            _cityList
                .add(CityModel(id: element['id'], name: element['ct_name_ar']));
          } else if (_language == 'kuk') {
            _cityList
                .add(CityModel(id: element['id'], name: element['ct_name_kr']));
          }
        });
        imageUrl =
            RouteApi().storageUrl + body['company']['company']['co_image'];
        _nameController.text = body['company']['company']['co_name'];
        _phoneController.text = body['company']['company']['co_phone'];
        _emailController.text = body['company']['u_email'];
        _streetController.text = body['company']['company']['co_address'];
        _descriptionController.text = body['company']['company']['co_info'];
        _selectedCityList = int.parse(body['company']['u_city']);
      });
    }
  }

  upload(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    // open a bytestream

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri =
        Uri.parse(RouteApi().routeGet(name: "uploadimage", type: 'company'));

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    // add file to multipart
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

class CityModel {
  final id, name;

  CityModel({@required this.id, @required this.name});
}
