import 'dart:convert';
import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/HomePage/ViewItemPage.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FavorateItem.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
//----------------------------loading----------------------------------//

  bool loading = true;
  List<FavorateItem> data = [];

//----------------------------translator-------------------------------//

//----------------------------overrides-------------------------------//
  @override
  void initState() {
    super.initState();
    _getFavorate(context);
  }

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return loading
        ? Center(
            child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                backgroundColor: const Color(0xfff2f3f6),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          )
        : checkIfFavEmpty == false
            ? Scaffold(
                backgroundColor:
                    loading == false ? const Color(0xfff2f3f6) : Colors.white,
                body: SafeArea(
                  child: Container(
                      width: screenWidth(context),
                      height: screenHeight(context),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          Container(
                            width: screenWidth(context) / 1.1,
                            alignment: _dir
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            margin: EdgeInsets.only(top: 20, bottom: 15),
                            child: Text(
                              _data['Favourites'],
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 25,
                                color: const Color(0xff0c0a0a),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: screenWidth(context),
                            margin: EdgeInsets.only(top: 0, bottom: 15),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              textDirection:
                                  _dir ? TextDirection.ltr : TextDirection.rtl,
                              children: [...data],
                            ),
                          )
                        ],
                      ))),
                ),
              )
            : buildNoItemToFav(context, _data);
  }

//---------------------Widgets---------------------//
  bool checkIfFavEmpty = true;
  Widget buildNoItemToFav(BuildContext context, _data) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.only(top: screenHeight(context) / 5),
            child: Icon(
              FeatherIcons.heart,
              color: const Color(0xfff9bf2d),
              size: 80,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: screenHeight(context) / 8),
            child: Text(
              _data['EmptyFavouriteList'],
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
                _data['WatingForYou'],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: const Color(0xfff9bf2d),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ))
        ]),
      ),
    );
  }

//---------------------Methods---------------------//
  void onItemPressed(BuildContext context, id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewItemPage(id)),
    ).then((val) => _getFavorate(context));
  }

  //---------------------Methods of DB--------------------//
  _getFavorate(BuildContext context) async {
    data.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _language = prefs.getString('lang');
    String token = prefs.getString('token');
    String url = RouteApi().routeGet(name: "favorates");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    Map body = jsonDecode(response.body);
    List favorate = body['favorate'];

    if (statusCode == 200) {
      favorate.forEach((element) {
        if (_language == 'kus') {
          data.add(
            FavorateItem(
              id: element['product']['id'],
              onHeartPressed: () => favorateOnPress(element['product']['id']),
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['product']['p_image']}"),
              name: element['product']['p_name_ku'],
              onItemPressed: () =>
                  onItemPressed(context, element['product']['id']),
            ),
          );
        } else if (_language == 'en') {
          data.add(
            FavorateItem(
              id: element['product']['id'],
              onHeartPressed: () => favorateOnPress(element['product']['id']),
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['product']['p_image']}"),
              name: element['product']['p_name'],
              onItemPressed: () =>
                  onItemPressed(context, element['product']['id']),
            ),
          );
        } else if (_language == 'ar') {
          data.add(
            FavorateItem(
              id: element['product']['id'],
              onHeartPressed: () => favorateOnPress(element['product']['id']),
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['product']['p_image']}"),
              name: element['product']['p_name_ar'],
              onItemPressed: () =>
                  onItemPressed(context, element['product']['id']),
            ),
          );
        } else if (_language == 'per') {
          data.add(
            FavorateItem(
              id: element['product']['id'],
              onHeartPressed: () => favorateOnPress(element['product']['id']),
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['product']['p_image']}"),
              name: element['product']['p_name_pr'],
              onItemPressed: () =>
                  onItemPressed(context, element['product']['id']),
            ),
          );
        } else if (_language == 'kuk') {
          data.add(
            FavorateItem(
              id: element['product']['id'],
              onHeartPressed: () => favorateOnPress(element['product']['id']),
              image: NetworkImage(
                  "${RouteApi().storageUrl}${element['product']['p_image']}"),
              name: element['product']['p_name_kr'],
              onItemPressed: () =>
                  onItemPressed(context, element['product']['id']),
            ),
          );
        }
      });
      setState(() {
        if (data.length > 0) {
          checkIfFavEmpty = false;
        } else {
          checkIfFavEmpty = true;
        }
      });
    }
    setState(() {
      loading = false;
    });
  }

  favorateOnPress(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String url = RouteApi().routeGet(name: "favorate") + '/' + id.toString();
    print(url);
    Response response = await post(url, headers: headers);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      setState(() {
        data.removeWhere((element) => element.id == id);
        if (data.length > 0) {
          checkIfFavEmpty = false;
        } else {
          checkIfFavEmpty = true;
        }
      });
    }
  }
}
