import 'dart:convert';
import 'dart:io';

import 'package:bizzcoin_app/Auth/Register/AgentRegister/AgentPendingAccountPage.dart';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  bool uploadLoading = false;
  @override
  Widget build(BuildContext context) {
    // uploadLoading = false;
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f6),
      body: CheckInternetWidget(
        SafeArea(
          child: Container(
            width: screenWidth(context),
            height: screenHeight(context),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: screenHeight(context) / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: screenWidth(context) / 2,
                          height: screenHeight(context) / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xfff9bf2d)),
                              image: image != null
                                  ? DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: FileImage(image))
                                  : null),
                          child: image == null
                              ? Center(
                                  child: Icon(FeatherIcons.user,
                                      size: 75, color: const Color(0xfff9bf2d)),
                                )
                              : Container(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          _data['UploadPicture'],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 26,
                            color: const Color(0xff0c0a0a),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        !uploadLoading
                            ? Container(
                                width: screenWidth(context) / 1.5,
                                height: 40.0,
                                margin: EdgeInsets.only(top: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xfff9bf2d),
                                ),
                                child: FlatButton(
                                  onPressed: () =>
                                      this.onUploadPressed(context),
                                  color: const Color(0xfff9bf2d),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    _data["Upload"],
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
                                margin: EdgeInsets.only(top: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xfff9bf2d),
                                ),
                                child: Center(
                                    child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: const Color(0xfff9bf2d),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight(context) / 8,
                  ),
                  Container(
                    child: CupertinoButton(
                      onPressed: () => this.onSkipPressed(context),
                      child: Text(
                        _data['Skip'],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          color: const Color(0xff4d4c4c),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //---------------------Methods---------------------//
  File image;
  Future<void> onUploadPressed(BuildContext context) async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      setState(() {
        uploadLoading = true;
        image = _image;
      });
      upload(image, context);
    }
  }

  upload(File imageFile, context) async {
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
      if (response.statusCode == 200) {
        prefs.setString('token', null);

        setState(() {
          uploadLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AgentPendingAccountPage()),
        );
      }
    });
  }

  void onSkipPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgentPendingAccountPage()),
    );
  }
}
