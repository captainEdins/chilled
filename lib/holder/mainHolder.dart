import 'package:chilled/holder/pages/home_page.dart';
import 'package:chilled/holder/pages/message.dart';
import 'package:chilled/holder/pages/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:chilled/resources/color.dart';

import 'pages/profile_page.dart';

class MainHolder extends StatefulWidget {
  const MainHolder({Key? key}) : super(key: key);

  @override
  State<MainHolder> createState() => _MainHolderState();
}

class _MainHolderState extends State<MainHolder> {
  late PersistentTabController _controller;


  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: ColorList.primary,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration:  NavBarDecoration(
        colorBehindNavBar: ColorList.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 20),
        curve: Curves.bounceInOut,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.bounceInOut,
        duration: Duration(milliseconds: 20),
      ),
      navBarStyle: NavBarStyle.simple, // Choose the nav bar style with this property.
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        activeColorPrimary: ColorList.white,
        inactiveColorPrimary: ColorList.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.chat_bubble_text_fill),
        activeColorPrimary: ColorList.white,
        inactiveColorPrimary: ColorList.secondary,
      ), PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.doc_text_search),
        activeColorPrimary: ColorList.white,
        inactiveColorPrimary: ColorList.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        activeColorPrimary: ColorList.white,
        inactiveColorPrimary: ColorList.secondary,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const Message(),
      const SettingsPage(),
      const ProfilePage(),
      
    ];
  }



  Widget containerHere(String textHere){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(20.0),
        ),
        Column(
          children:  <Widget>[
            Center(
              child: Text(textHere,
                  style: const TextStyle(
                    fontSize: 21,fontWeight: FontWeight.w900,color: ColorList.green,),textAlign: TextAlign.center
              ),
            ),
          ],
        ),
      ],
    );
  }

}