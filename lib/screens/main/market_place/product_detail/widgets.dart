import 'package:navinotes/packages.dart';

class ExpandableSection extends StatefulWidget {
  const ExpandableSection({
    super.key,
    required this.title,
    required this.items,
  });
  final String title;
  final List<String> items;
  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool expanded = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _divider(),
        InkWell(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTheme.text.copyWith(
                      fontSize: 16.0,
                      fontWeight: getFontWeight(500),
                      height: 1.0,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: AppTheme.darkSlateGray,
                ),
              ],
            ),
          ),
        ),

        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children:
                  widget.items
                      .map(
                        (str) => Text(
                          str,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.darkSlateGray,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }

  Widget _divider() {
    return Divider(height: 1.0, color: AppTheme.lightAsh);
  }
}
