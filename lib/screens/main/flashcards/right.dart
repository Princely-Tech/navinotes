import 'package:navinotes/packages.dart';

class FlashcardsRight extends StatelessWidget {
  const FlashcardsRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
