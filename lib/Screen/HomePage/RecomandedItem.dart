import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Recomanded extends StatelessWidget {
  Recomanded(
      {@required this.onItemPressed,
      this.image,
      @required this.name,
      @required this.price});
  final String name;
  final double price;
  final dynamic image;
  final Function onItemPressed;
  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageService>(context);
    bool _dir = _language.getLanguage()['dir'];
    return CheckInternetWidget(
      Container(
        margin: EdgeInsets.only(right: _dir ? 15 : 0, left: _dir ? 0 : 15),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onItemPressed,
          child: Column(
            children: [
              Container(
                width: checkIfIpad(context) == true
                    ? screenWidth(context) / 3.5
                    : screenWidth(context) / 2.2,
                height: checkIfIpad(context) == true ? 120 : 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffcecece),
                    image: DecorationImage(
                        image:
                            image ?? AssetImage("assets/BizzPaymentlogo.png"),
                        fit: BoxFit.fill)),
              ),
              Container(
                width: checkIfIpad(context) == true
                    ? screenWidth(context) / 3.5
                    : screenWidth(context) / 2.2,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _dir ? '$name' : '$price\$',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: const Color(0xff0c0a0a),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      _dir ? '$price\$' : '$name',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: const Color(0xff0c0a0a),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}