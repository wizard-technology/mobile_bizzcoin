import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteApi {
  String main_url = 'http://192.168.1.10/';
  String user = 'http://192.168.1.10/api/';
  String company = 'http://192.168.1.10/company/';
  String storage = 'http://192.168.1.10/storage/';
  String get storageUrl {
    return storage;
  }

  double reciprocal(dynamic d) => d / 1;

  Map<String, Map<String, String>> routeApi = {
    'user': {
      'history_item': 'history\/item\/',
      'login': 'login',
      'logout': 'logout',
      'signup': 'signup',
      'verify': 'verify',
      'changepassword': 'password',
      'profile': 'user',
      'update': 'update',
      'forget': 'forgetpassword',
      'verify_reset_password': 'verify_reset_password',
      'change_password': 'change_password',
      'home': 'home',
      'product': 'product',
      'productUser': 'product\/user',
      'help': 'send\/report',
      'get_help': 'get\/report',
      'favorate': 'favorate',
      'favorates': 'favorates',
      'addToCart': 'addToCart',
      'cart': 'cart',
      'deleteCart': 'cart\/delete',
      'amount': 'cart\/amount',
      'onSearch': 'product\/get\/',
      'product_types': 'product\/type\/',
      'bizzcoin': 'bizzcoin',
      'terms': 'terms',
      'payment': 'payment',
      'company': 'company',
      'checkout': 'checkout',
      'history': 'history',
      'product_subcategory': 'product\/subcategory\/',
      'types': 'types',
      'subcategory': 'subcategory\/get\/',
      'grouped': 'grouped\/get\/',
      'product_grouped': 'product\/grouped\/get\/',
      'product_company': 'product\/company\/get',
      'redeem_payment': 'payment\/redeem',
      'mainscreen': 'mainscreen',
      'open_notification': 'open\/notification',
      'get_redeem': 'get\/redeem\/code',
    },
    'company': {
      'city': 'city',
      'register': 'register',
      'profile': 'user',
      'company': 'company\/user',
      'update': 'update\/company',
      'uploadimage': 'upload\/image',
      'addProduct': 'product\/company\/add',
      'updateProduct': 'product\/company\/update',
      'deleteProduct': 'product\/company\/delete',
      'addImage': 'product\/company\/image',
      'products': 'products',
      'redeem_search': 'search\/redeem\/code',
      'redeem': 'get\/redeem\/code',
      'scan': 'scan\/redeem\/code',
      'search': 'search\/redeem\/search',
    },
  };
  String routeGet({String type = 'user', @required String name}) {
    return type == 'user'
        ? (user + routeApi[type][name].toString())
        : (company + routeApi[type][name].toString());
  }

  Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('lang');
    return lang;
  }

  getLangTranslate() async {
    String l = await getLanguage();
    if (l == "arabic") {
      return "ar";
    } else if (l == "persian") {
      return "fa";
    } else if (l == "kurmanji") {
      return "ku";
    }
  }
}
