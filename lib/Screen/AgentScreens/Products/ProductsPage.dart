import 'dart:convert';

import 'package:bizzcoin_app/RouteApi.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/EditProduct/EditProductPage.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/Products/ProductModel.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool rigisterLoading = false;
  List<ProductsModel> product = [];
  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  bool loading = true;
  bool isProductEmpty = false;
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Scaffold(
      backgroundColor: Colors.white,
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
                                _data["MyProducts"],
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
                        margin: EdgeInsets.all(10),
                        child: Directionality(
                          textDirection:
                              _dir ? TextDirection.ltr : TextDirection.rtl,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              ...product,
                              isProductEmpty
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
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
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

//---------------------Methods---------------------//
  void onProductPressed(BuildContext context, el) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          data: el,
        ),
      ),
    ).whenComplete(() => fetchProduct());
  }

  fetchProduct() async {
    product.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(
        RouteApi().routeGet(name: "products", type: 'company'),
        headers: headers);

    if (response.statusCode == 200) {
      jsonDecode(response.body)['product'].forEach((element) {
        print(element);

        product.add(ProductsModel(
          name: element['pc_name'],
          price: element['pc_price'],
          image: RouteApi().storageUrl + element['images'][0]['ipc_image'],
          onClick: () => onProductPressed(context, element),
        ));
      });
      setState(() {});
    } else {
      throw Exception('Failed to load Channel');
    }
  }
}
