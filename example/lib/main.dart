import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

import 'second_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fancy Bottom Navigation"),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.cyanAccent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Center(
              child: _getPage(currentPage),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint("12312");
              },
              child: Container(
                color: Colors.red,
                height: 50,
                width: double.infinity,
                child: Text('data'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
            selectedIconData: Icons.home,
            iconData: Icons.nature,
            title: "首页",
            // onclick: () {
            //   final FancyBottomNavigationState fState =
            //       bottomNavigationKey.currentState;
            //   fState.setPage(2);
            // },
          ),
          TabData(
            iconData: Icons.search,
            title: "搜索",
            onclick: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SecondPage())),
            selectedIconData: Icons.nature,
          ),
          TabData(
            iconData: Icons.shopping_cart,
            selectedIconData: Icons.nature,
            title: "消息",
            badge: '10',
          ),
          TabData(
              iconData: Icons.near_me,
              selectedIconData: Icons.nature,
              title: "我的"),
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        activeIconColor: Colors.white,
        activeTextColor: Color(0xff4D91F7),
        inactiveIconColor: Color(0xff999999),
        // circleColor: Color(0xff4D91F7),
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xff69ADF9),
        //     Color(0xff4C91F6),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        textColor: Color(0xff999999),
        onTabChangedListener: (position, index) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[Text("Hello"), Text("World")],
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the home page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            RaisedButton(
              child: Text(
                "Change to page 3",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              },
            )
          ],
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the search page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            )
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the basket page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ],
        );
    }
  }
}
