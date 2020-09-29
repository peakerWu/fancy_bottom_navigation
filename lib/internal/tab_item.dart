import 'package:flutter/material.dart';

const double ICON_OFF = -3;
const double ICON_ON = 0;
const double TEXT_OFF = 3;
const double TEXT_ON = 1;
const double ALPHA_OFF = 0;
const double ALPHA_ON = 1;
const int ANIM_DURATION = 250;

class TabItem extends StatelessWidget {
  TabItem({
    @required this.uniqueKey,
    @required this.selected,
    @required this.iconData,
    @required this.title,
    @required this.callbackFunction,
    @required this.textColor,
    @required this.iconColor,
    this.activeTextColor,
    this.activeIconColor,
    this.selectedIconData,
  });

  final UniqueKey uniqueKey;
  final String title;
  final IconData iconData;
  final IconData selectedIconData;
  final bool selected;
  final Function(UniqueKey uniqueKey) callbackFunction;
  final Color textColor;
  final Color activeTextColor;
  final Color iconColor;
  final Color activeIconColor;

  final double iconYAlign = ICON_ON;
  final double textYAlign = TEXT_OFF;
  final double iconAlpha = ALPHA_ON;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: selected
            ? null
            : () {
                callbackFunction(uniqueKey);
              },
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.only(top: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimatedAlign(
                duration: Duration(milliseconds: ANIM_DURATION),
                curve: Curves.easeIn,
                alignment: Alignment(0, (selected) ? ICON_OFF : ICON_ON),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: ANIM_DURATION),
                  opacity: (selected) ? ALPHA_OFF : ALPHA_ON,
                  child: Icon(
                    iconData,
                    color: selected ? activeIconColor : iconColor,
                    // size: 22,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: selected ? activeTextColor : textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
