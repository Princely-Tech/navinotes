import 'package:navinotes/packages.dart';
import 'vm.dart';

class NoteCreationRight extends StatelessWidget {
  const NoteCreationRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          Expanded(
            child: ScrollableController(
              mobilePadding: EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timer(),

                  _flashcards(),
                  _mindMap(),
                  // _relatedResources(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _relatedResources() {
    return _section(
      title: 'Related Resources',
      showBottomBorder: false,
      child: Center(
        child: Text('No related resources yet', style: AppTheme.text),
      ),
      // child: Column(
      //   spacing: 10,
      //   children: [
      //     _resourceItem(
      //       icon: SVGImagePlaceHolder(
      //         imagePath: Images.pdf,
      //         size: 15,
      //         color: AppTheme.coralRed,
      //       ),
      //       title: 'Cell Biology Textbook Ch.3',
      //     ),
      //     _resourceItem(
      //       icon: SVGImagePlaceHolder(
      //         imagePath: Images.youtube,
      //         size: 15,
      //         color: AppTheme.coralRed,
      //       ),
      //       title: 'Cell Organelles Video',
      //     ),
      //     _resourceItem(
      //       icon: SVGImagePlaceHolder(
      //         imagePath: Images.hook,
      //         size: 15,
      //         color: AppTheme.strongBlue,
      //       ),
      //       title: 'Interactive Cell Model',
      //     ),
      //   ],
      // ),
    );
  }

  Widget _mindMap() {
    return _section(
      title: 'Mind Map',
      child: CustomCard(
        decoration: BoxDecoration(
          color: AppTheme.lightAsh,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(10),
      ),
    );
  }

  Widget _flashcards() {
    return _section(
      title: 'FlashCards',
      button: AppButton.text(
        onTap: () => NavigationHelper.push(Routes.flashCards),
        text: 'all',
      ),
      child: CustomCard(
        decoration: BoxDecoration(
          color: AppTheme.lightAsh,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }

  Widget _timer() {
    return Consumer<PomodoroTimer>(
      builder: (_, pomodoroVm, _) {
        bool isRunning = pomodoroVm.isRunning;
        return _section(
          title: 'Timer',
          child: CustomCard(
            decoration: BoxDecoration(
              color: AppTheme.lightAsh,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              spacing: 10,
              children: [
                Text(
                  formatTime(pomodoroVm.elapsedSeconds),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      onTap: isRunning ? pomodoroVm.stop : pomodoroVm.start,
                      text: isRunning ? 'Pause' : 'Start',
                      wrapWithFlexible: true,
                      mainAxisSize: MainAxisSize.min,
                      minHeight: 25,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppButton(
                      onTap: pomodoroVm.reset,
                      text: 'Reset',
                      color: AppTheme.lightGray,
                      wrapWithFlexible: true,
                      mainAxisSize: MainAxisSize.min,
                      minHeight: 25,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      style: TextStyle(
                        color: const Color(0xFF374151),
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    bool showBottomBorder = true,
    Widget? button,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border:
            showBottomBorder
                ? Border(bottom: BorderSide(color: AppTheme.lightGray))
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF374151),
                    fontSize: 14.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ),
              if (isNotNull(button)) button!,
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Text(
        'Study Tools',
        style: TextStyle(
          color: const Color(0xFF1F2937),
          fontSize: 16.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),
      ),
    );
  }
}
