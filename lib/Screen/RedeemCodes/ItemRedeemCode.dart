import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizzcoin_app/RouteApi.dart';

class ItemRedeemCode extends StatelessWidget {
  final url, state, code, currency, price, company;

  const ItemRedeemCode(
      {Key key,
      this.url,
      this.code,
      this.currency,
      this.price,
      this.company,
      this.state})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    bool _dir = _lang.getLanguage()['dir'];
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Directionality(
        textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage("${RouteApi().storageUrl}$url"),
              )),
            ),
            Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth(context) - 155,
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0x4affed75),
                          ),
                          child: Center(
                            child: Icon(
                              FeatherIcons.lock,
                              color: Colors.yellow.shade600,
                              size: 15,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: SelectableText(
                            '$code',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: const Color(0xff0c0a0a),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth(context) - 155,
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0x4affed75),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.visibility,
                              color: Colors.yellow.shade600,
                              size: 15,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: SelectableText(
                            state == 0 ? 'Active' : 'Used',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: const Color(0xff0c0a0a),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth(context) - 155,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            '$price $currency',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          child: Text(
                            '$company',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 11,
                              color: const Color(0xff6a6767),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
