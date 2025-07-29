import 'package:navinotes/packages.dart';

class NotesAppBarActions extends StatelessWidget {
  const NotesAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        SVGImagePlaceHolder(imagePath: Images.pref, size: 16),
        IconButton(
          onPressed: NavigationHelper.navigateToSettings,
          icon: SVGImagePlaceHolder(
            imagePath: Images.settings,
            size: 16,
            color: AppTheme.stormGray,
          ),
        ),
        ProfilePic(size: 32),
      ],
    );
  }
}

class NewNotesButton extends StatelessWidget {
  const NewNotesButton({super.key, required this.isAside});
  final bool isAside;
  @override
  
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (context, vm, child) {
        return AppButton(
          // color: AppTheme.primaryColor,
          wrapWithFlexible: true,
          mainAxisSize: MainAxisSize.min,
          onTap: () => vm.gotToCreateNotePage(),
          text: isAside ? 'New Note' : 'New Note Page',
          minHeight: 36,
          prefix: Icon(Icons.add, color: AppTheme.white),
          style: AppTheme.text.copyWith(color: AppTheme.white),
        );
      },
    );
  }
}
