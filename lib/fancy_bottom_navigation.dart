library fancy_bottom_navigation;

import 'package:flutter/material.dart';

import 'internal/tab_item.dart';
import 'paint/half_clipper.dart';
import 'paint/half_painter.dart';

const double CIRCLE_SIZE = 24;
const double ARC_HEIGHT = 70;
const double ARC_WIDTH = 75;
const double CIRCLE_OUTLINE = 5;
const double SHADOW_ALLOWANCE = 4;
const double BAR_HEIGHT = 50;
const int ANIM_DURATION = 250;

class FancyBottomNavigation extends StatefulWidget {
  FancyBottomNavigation({
    @required this.tabs,
    @required this.onTabChangedListener,
    this.key,
    this.initialSelection = 0,
    this.circleColor,
    this.activeIconColor,
    this.inactiveIconColor,
    this.textColor,
    this.barBackgroundColor,
    this.activeTextColor,
    this.gradient,
  })  : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 5);

  final Function(int position, bool selected) onTabChangedListener;
  final Color circleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color activeTextColor;
  final Color barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;
  final Gradient gradient;

  final Key key;

  @override
  FancyBottomNavigationState createState() => FancyBottomNavigationState();
}

class FancyBottomNavigationState extends State<FancyBottomNavigation>
    with TickerProviderStateMixin, RouteAware, SingleTickerProviderStateMixin {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  Color circleColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;
  Color activeTextColor;

  Matrix4 _transform = Matrix4.translationValues(0, 0, 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].selectedIconData;

    circleColor = (widget.circleColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.circleColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    textColor = (widget.textColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textColor;
    activeTextColor = (widget.activeTextColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.activeTextColor;
    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.inactiveIconColor;
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].selectedIconData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: BAR_HEIGHT + MediaQuery.of(context).padding.bottom,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(color: barBackgroundColor, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.tabs
                .map((t) => TabItem(
                    uniqueKey: t.key,
                    selected: t.key == widget.tabs[currentSelected].key,
                    iconData: t.iconData,
                    title: t.title,
                    iconColor: inactiveIconColor,
                    activeIconColor: activeIconColor,
                    textColor: textColor,
                    activeTextColor: activeTextColor,
                    badge: t.badge,
                    fontSize: t.fontSize,
                    callbackFunction: (uniqueKey, selected) {
                      int selectedIndex = widget.tabs
                          .indexWhere((tabData) => tabData.key == uniqueKey);
                      widget.onTabChangedListener(selectedIndex, selected);
                      _setSelected(uniqueKey);
                      _initAnimationAndStart(_circleAlignX, 1);
                    }))
                .toList(),
          ),
        ),
        Positioned.fill(
          top: -6,
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: _circleIconAlpha == 0
                  ? Duration(milliseconds: 0)
                  : Duration(milliseconds: 100),
              transform: _transform,
              // curve: Cubic(.33,.03,.66,2.49),
              child: Container(
                // color: Colors.blue,
                child: AnimatedAlign(
                  duration: Duration(milliseconds: 0),
                  curve: Curves.easeOut,
                  alignment: Alignment(_circleAlignX, 1),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 15 + MediaQuery.of(context).padding.bottom),
                    child: FractionallySizedBox(
                      widthFactor: 1 / widget.tabs.length,
                      child: GestureDetector(
                        onTap: widget.tabs[currentSelected].onclick,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: CIRCLE_SIZE +
                                  CIRCLE_OUTLINE +
                                  SHADOW_ALLOWANCE,
                              width: CIRCLE_SIZE +
                                  CIRCLE_OUTLINE +
                                  SHADOW_ALLOWANCE,
                              child: ClipRect(
                                clipper: HalfClipper(),
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      width: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                      height: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 白色圆圈背景
                            SizedBox(
                              height: ARC_HEIGHT,
                              width: ARC_WIDTH,
                              child: CustomPaint(
                                painter: HalfPainter(barBackgroundColor),
                              ),
                            ),
                            // 蓝色圆圈
                            Positioned(
                              top: 8,
                              left: 0,
                              right: 0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    height: CIRCLE_SIZE + 6,
                                    width: CIRCLE_SIZE + 6,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: widget.gradient,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(
                                          activeIcon,
                                          color: activeIconColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
    setState(() {
      _circleIconAlpha = 0;
      activeIcon = nextIcon;
      _transform = Matrix4.translationValues(0, 0, 0);
    });
    Future.delayed(Duration(milliseconds: ANIM_DURATION ~/ 8), () {
      setState(() {
        _transform = Matrix4.translationValues(0, -5, 0);
        _circleIconAlpha = 1;
      });
    }).then((_) {
      // setState(() {
      //   _transform = Matrix4.translationValues(0, -4, 0);
      //   _circleIconAlpha = 1;
      // });
    });
    // Future.delayed(Duration(milliseconds: (ANIM_DURATION ~/ 5 * 3)), () {});
  }

  void setPage(int page) {
    widget.onTabChangedListener(page, true);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabData {
  TabData({
    @required this.iconData,
    @required this.selectedIconData,
    @required this.title,
    this.badge,
    this.onclick,
    this.fontSize = 10,
  });

  IconData iconData;
  IconData selectedIconData;
  String title;
  String badge;
  double fontSize;
  Function onclick;
  final UniqueKey key = UniqueKey();
}
