import 'package:bizzcoin_app/Screen/AgentScreens/AgentHistory/AgentHistoryPage.dart';
import 'package:bizzcoin_app/Screen/AgentScreens/RedeemCodeScanPage/RedeemCodeScanPage.dart';
import 'package:bizzcoin_app/Screen/MyAccount/MyAccountPage.dart';
import 'package:bizzcoin_app/Service/check_connection.dart';
import 'package:bizzcoin_app/Service/language.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AgentMainScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AgentMainScreenPageState();
  }
}

class _AgentMainScreenPageState extends State<AgentMainScreenPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _childrenOnLine;
  _AgentMainScreenPageState() {
    setPages();
  }

  int _currentIndex = 0;
  void setPages() {
    _childrenOnLine = [
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: RedeemCodeScanPage()),
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: AgentHistortyPage()),
      WillPopScope(
          onWillPop: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: MyAccount(false)),
    ];
  }

  void _onBottomNavBarTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageService>(context);
    bool _dir = _language.getLanguage()['dir'];

    return SafeArea(
      child: Scaffold(
        body: CheckInternetWidget(_childrenOnLine[_currentIndex]),
        bottomNavigationBar: new Directionality(
          textDirection: _dir ? TextDirection.ltr : TextDirection.rtl,
          child: Container(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xfff2f3f6),
              selectedItemColor: const Color(0xfff9bf2d),
              unselectedItemColor: Colors.black,
              selectedIconTheme: IconThemeData(
                size: 25,
              ),
              unselectedIconTheme: IconThemeData(
                size: 25,
              ),
              items: <BottomNavigationBarItem>[
                new BottomNavigationBarItem(
                    icon: const Icon(FeatherIcons.maximize),
                    title: Container(height: 0.0)),
                new BottomNavigationBarItem(
                    icon: const Icon(FeatherIcons.rotateCcw),
                    title: Container(height: 0.0)),
                new BottomNavigationBarItem(
                    icon: Icon(FeatherIcons.user),
                    title: Container(height: 0.0)),
              ],
              currentIndex: _currentIndex,
              onTap: _onBottomNavBarTab,
            ),
          ),
        ),
      ),
    );
  }
}
