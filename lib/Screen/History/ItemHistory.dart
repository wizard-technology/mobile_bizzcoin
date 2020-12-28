import 'package:bizzcoin_app/Service/language.dart';
import 'package:bizzcoin_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemHistory extends StatelessWidget {
  final date, id, price, onClick;

  const ItemHistory(
      {Key key,
      @required this.date,
      @required this.id,
      @required this.price,
      @required this.onClick})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _lang = Provider.of<LanguageService>(context);
    Map _data = _lang.getLanguage()['data'];
    bool _dir = _lang.getLanguage()['dir'];
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        width: screenWidth(context),
        height: 141.0,
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
        child: Column(
          children: [
            Container(
              width: screenWidth(context),
              height: 19.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),
                color: id % 2 == 0
                    ? const Color(0xfffee39a)
                    : const Color(0xff9aa1fe),
              ),
            ),
            Container(
              height: 110.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth(context) - 50,
                    margin: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment:
                          _dir ? Alignment.centerLeft : Alignment.centerRight,
                      child: Text(
                        '${_data['Order']} : $id',
                        textDirection:
                            _dir ? TextDirection.ltr : TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          color: const Color(0xff0c0a0a),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth(context) - 50,
                    child: Directionality(
                      textDirection:
                          _dir ? TextDirection.ltr : TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$price ${_data['Bizz']}',
                            textDirection:
                                _dir ? TextDirection.ltr : TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            width: 66.0,
                            child: Text(
                              '$date',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                color: const Color(0xffcecece),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
