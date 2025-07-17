import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/board/empty_dashboard.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/widget/widget.dart';
import 'boards.dart';
import 'appbar.dart';
import 'vm.dart';

class SellerSelectMain extends StatelessWidget {
  const SellerSelectMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerSelectContentVm>(
      builder: (_, vm, _) {
        bool hasData = vm.sessionVm.userBoards.isNotEmpty;
        return Column(
          children: [
            SellerSelectContentAppBar(),
            progressHeader(1),
            Text(
            'Select content to upload',
            style: AppTheme.text.copyWith(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
            ),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(10),
                tabletPadding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding,
                  vertical: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child:
                      hasData
                          ? Column(
                            spacing: 30,
                            children: [SellerSelectBoards()],
                          )
                          : EmptySellerSelectMain(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
