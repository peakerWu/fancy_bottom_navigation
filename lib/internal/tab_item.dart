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
    this.badge,
  });

  final UniqueKey uniqueKey;
  final String title;
  final String badge;
  final IconData iconData;
  final IconData selectedIconData;
  final bool selected;
  final Function(UniqueKey uniqueKey, bool selected) callbackFunction;
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
        onTap: () {
          callbackFunction(uniqueKey, selected);
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
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Icon(
                        iconData,
                        color: selected ? activeIconColor : iconColor,
                        // size: 22,
                      ),
                      (badge != null && badge.length > 0)
                          ? Positioned(
                              top: -2,
                              right: -4,
                              child: Container(
                                alignment: Alignment.center,
                                constraints:
                                    BoxConstraints(maxHeight: 16, maxWidth: 16),
                                decoration: BoxDecoration(
                                  color: Color(0xffFF3B30),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  badge,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
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
