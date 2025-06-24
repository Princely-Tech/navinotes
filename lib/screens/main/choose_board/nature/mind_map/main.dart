import 'package:navinotes/packages.dart';
import 'vm.dart';

class BoardNatureMindMapMain extends StatelessWidget {
  const BoardNatureMindMapMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNatureMindMapVm>(
      builder: (_, vm, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mind map coming soon...',
              style: AppTheme.text.copyWith(
                fontSize: 30.0,
                fontFamily: AppTheme.fontCrimsonText,
                color: AppTheme.coffee,
                height: 1.33,
              ),
            ),
          ],
        );
      },
    );
  }
}
