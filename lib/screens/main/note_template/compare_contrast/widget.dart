import 'package:navinotes/packages.dart';

class WrapperContainerWithTitle extends StatelessWidget {
  const WrapperContainerWithTitle({
    super.key,
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      addBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          ExpandableController(
            largeDesktop: false,
            child: ScrollableController(child: child),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 1.56,
        ),
      ),
    );
  }
}

class ActiveIndicatorWidget extends StatelessWidget {
  const ActiveIndicatorWidget(this.text, {super.key, this.checked = false});
  final bool checked;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: ShapeDecoration(
            color: checked ? const Color(0xFF0075FF) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
              side:
                  checked
                      ? BorderSide.none
                      : BorderSide(width: 0.5, color: Colors.black),
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
