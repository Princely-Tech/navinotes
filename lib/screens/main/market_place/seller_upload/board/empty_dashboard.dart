import 'package:navinotes/packages.dart';
import 'vm.dart';

class EmptySellerSelectMain extends StatelessWidget {
  const EmptySellerSelectMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<SellerSelectContentVm>(
      builder: (_, vm, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcome(),
            ],
          ),
        );
      },
    );
  }

 Widget _welcome() {
    return Consumer<SessionManager>(
      builder: (_, sessionManager, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            Text(
              'Hello ${sessionManager.getName()},',
              style: AppTheme.text.copyWith(
                color: AppTheme.graphite,
                fontSize: 22.29,
                fontWeight: getFontWeight(700),
                height: 1.33,
              ),
            ),
            Text(
              'You do not have any content yet. Create one to before listing in market place.',
              style: AppTheme.text.copyWith(
                color: AppTheme.stormGray,
                height: 1.50,
              ),
            ),
          ],
        );
      },
    );
  }
}
