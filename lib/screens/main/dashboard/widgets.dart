import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';

class DashFilterSection extends StatelessWidget {
  const DashFilterSection({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
      side: BorderSide(color: Apptheme.coolGray),
    );
    return Row(
      spacing: 30,
      children: [
        Expanded(
          child: Text(
            title,
            style: Apptheme.text.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              AppButton(
                wrapWithFlexible: true,
                mainAxisSize: MainAxisSize.min,
                prefix: SVGImagePlaceHolder(imagePath: Images.arrowVer),
                onTap: () {},
                color: Apptheme.white,
                style: Apptheme.text.copyWith(color: Apptheme.stormGray),
                minHeight: 29,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                text: 'Sort',
                shape: shape,
              ),
              AppButton(
                wrapWithFlexible: true,
                mainAxisSize: MainAxisSize.min,
                prefix: SVGImagePlaceHolder(imagePath: Images.filter),
                onTap: () {},
                color: Apptheme.white,
                style: Apptheme.text.copyWith(color: Apptheme.stormGray),
                minHeight: 29,
                shape: shape,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                text: 'Filter',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DashboardCreateCard extends StatelessWidget {
  const DashboardCreateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        return CreateCard(
          onTap: vm.goToCreateBoard,
          text: 'Create New Board',
          width: vm.hasData ? double.infinity : 356,
          height: vm.hasData ? null : 237,
        );
      },
    );
  }
}
