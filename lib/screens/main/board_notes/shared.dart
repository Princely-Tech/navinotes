import 'package:navinotes/packages.dart';
import 'vm.dart';

class NotesAppBarActions extends StatelessWidget {
  const NotesAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        SVGImagePlaceHolder(imagePath: Images.pref, size: 16),
        SVGImagePlaceHolder(
          imagePath: Images.settings,
          size: 16,
          color: Apptheme.stormGray,
        ),
        OutlinedChild(
          decoration: BoxDecoration(
            color: Apptheme.electricIndigo,
            shape: BoxShape.circle,
          ),
          child: Text(
            'J',
            style: Apptheme.text.copyWith(
              color: Apptheme.white,
              fontSize: 16.0,
              fontWeight: getFontWeight(600),
            ),
          ),
        ),
      ],
    );
  }
}

class NewNotesButton extends StatelessWidget {
  const NewNotesButton({super.key, required this.isAside});
  final bool isAside;
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotesVm>(
      builder: (context, vm, child) {
        return AppButton(
          color: Apptheme.primaryColor,
          wrapWithFlexible: true,
          mainAxisSize: MainAxisSize.min,
          onTap: vm.gotToCreateNotePage,
          text: isAside ? 'New Note' : 'New Note Page',
          minHeight: 36,
          prefix: Icon(Icons.add, color: Apptheme.white),
          style: Apptheme.text.copyWith(color: Apptheme.white),
        );
      },
    );
  }
}
