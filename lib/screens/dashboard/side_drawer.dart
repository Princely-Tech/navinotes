import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/components.dart';

class DashboardSideBar extends StatelessWidget {
  const DashboardSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Apptheme.white,
        border: Border(right: BorderSide(width: 2, color: Apptheme.lightGray)),
      ),
      child: Column(
        spacing: 15,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Apptheme.lightGray)),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              spacing: 10,
              children: [
                SVGImagePlaceHolder(imagePath: Images.logoSquare, size: 40),
                Expanded(
                  child: Text(
                    'NeuroNote',
                    overflow: TextOverflow.ellipsis,
                    style: Apptheme.text.copyWith(
                      color: Apptheme.strongBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ScrollableController(
                child: Column(
                  children: [
                    _item(
                      title: 'Dashboard',
                      icon: Images.home,
                      isActive: true,
                    ),
                    _item(title: 'Recent Notes', icon: Images.recent),
                    _item(title: 'Flashcards', icon: Images.flashCards),
                    _item(title: 'Pomodoro Timer', icon: Images.timer),
                    _item(title: 'Settings', icon: Images.settings),
                  ],
                ),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }
Widget _footer(){
  return Column(children: [],)
}
  Widget _item({
    required String title,
    required String icon,
    bool isActive = false,
    // required String route,
  }) {
    final color = isActive ? Apptheme.strongBlue : Apptheme.defaultBlack;
    Radius radius = Radius.circular(100);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: SVGImagePlaceHolder(imagePath: icon, size: 18, color: color),
        selected: isActive,
        selectedTileColor: Apptheme.iceBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: radius,
            bottomRight: radius,
          ),
        ),
        title: Text(
          title,
          style: Apptheme.text.copyWith(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
