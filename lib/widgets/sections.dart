import 'package:navinotes/packages.dart';

class RoyalGoldHeaderSection extends StatelessWidget {
  const RoyalGoldHeaderSection({
    super.key,
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Apptheme.text.copyWith(
            color: Apptheme.royalGold,
            fontSize: 18.0,
            fontFamily: Apptheme.fontPlayfairDisplay,
          ),
        ),
        Divider(color: Apptheme.royalGold.withAlpha(0x4C), height: 20),
        Padding(padding: const EdgeInsets.only(top: 8.0), child: child),
      ],
    );
  }
}