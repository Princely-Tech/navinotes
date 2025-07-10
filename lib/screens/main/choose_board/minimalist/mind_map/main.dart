import 'package:navinotes/packages.dart';
import 'vm.dart';

class MinimalistMindMapMain extends StatelessWidget {
  const MinimalistMindMapMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MinimalistMindMapVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mind map coming soon...',
                    style: AppTheme.text.copyWith(
                      fontSize: 30.0,
                      color: AppTheme.asbestos,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
