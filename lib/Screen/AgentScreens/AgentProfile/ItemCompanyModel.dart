import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCompanyModel extends StatelessWidget {
  final name, price, onClick, image;

  const ItemCompanyModel(
      {Key key, this.name, this.price, this.onClick, this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    bool _dir = _lang.getLanguage()['dir'];
    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onClick,
        child: Column(
          children: [
            Container(
              width: checkIfIpad(context) == true
                  ? screenWidth(context) / 3.5
                  : screenWidth(context) / 2.3,
              height: checkIfIpad(context) == true ? 220 : 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xffcecece),
                image: DecorationImage(
                    image: NetworkImage("$image"), fit: BoxFit.fitHeight),
              ),
            ),
            Container(
              width: checkIfIpad(context) == true
                  ? screenWidth(context) / 3.5
                  : screenWidth(context) / 2.3,
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
    );
  }
}
