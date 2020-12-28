import 'package:flutter/material.dart';

class CompanyItem extends StatelessWidget {
  final onClick, index, name, image;

  const CompanyItem({Key key, this.onClick, this.index, this.name, this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            image == null
                ? Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: index % 2 == 0
                          ? const Color(0xff7f2dbd)
                          : const Color(0xffffa200),
                    ),
                    child: Center(
                      child: Text(
                        '${name.toString().toUpperCase()[0]}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 30,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                : Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xffffa200),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            Container(
              width: 130,
              margin: EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                '$name',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: const Color(0xff0c0a0a),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
