import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bizzpayment extends StatelessWidget {
  final state, price;

  const Bizzpayment({Key key, this.state, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            offset: Offset(0, 15),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: screenWidth(context),
            child: Directionality(
              textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 ${_data['Bizz']}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 30,
                      color: const Color(0xfff9bf2d),
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
                  ),
                  state == null
                      ? Container()
                      : state
                          ? Container(
                              child: Icon(
                                FeatherIcons.trendingUp,
                                color: Colors.green,
                                size: 32,
                              ),
                            )
                          : Container(
                              child: Icon(
                                FeatherIcons.trendingDown,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                  Text(
                    '\$ $price',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 30,
                      color: const Color(0xff0c0a0a),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
