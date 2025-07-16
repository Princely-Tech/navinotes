import 'package:navinotes/packages.dart';

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
                  _relatedResources(),
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
      child: Column(
        spacing: 10,
        children: [
          _resourceItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.pdf,
              size: 15,
              color: AppTheme.coralRed,
            ),
            title: 'Cell Biology Textbook Ch.3',
          ),
          _resourceItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.youtube,
              size: 15,
              color: AppTheme.coralRed,
            ),
            title: 'Cell Organelles Video',
          ),
          _resourceItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.hook,
              size: 15,
              color: AppTheme.strongBlue,
            ),
            title: 'Interactive Cell Model',
          ),
        ],
      ),
    );
  }

  Widget _resourceItem({required Widget icon, required String title}) {
    return Row(
      spacing: 5,
      children: [
        icon,
        Expanded(
          child: Text(
            'Cell Biology Textbook Ch.3',
            style: TextStyle(
              color: const Color(0xFF2563EB),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mindMap() {
    return _section(
      title: 'Mind Map',
      button: AppButton.text(onTap: () {}, text: 'View'),
      child: CustomCard(
        decoration: BoxDecoration(
          color: AppTheme.lightAsh,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            CustomCard(
              addCardShadow: true,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Column(
                spacing: 3,
                children: [
                  SVGImagePlaceHolder(
                    imagePath: Images.share,
                    size: 22,
                    color: AppTheme.steelMist,
                  ),
                  Text(
                    'Cell Structure Connections',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flashcards() {
    return _section(
      title: 'Flashcards',
      button: AppButton.text(
        onTap: () => NavigationHelper.push(Routes.flashCards),
        text: 'Create',
      ),
      child: CustomCard(
        decoration: BoxDecoration(
          color: AppTheme.lightAsh,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          children: [
            CustomCard(
              addCardShadow: true,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Text(
                'What are the main functions of mitochondria?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  onTap: () {},
                  text: 'Flip',
                  color: AppTheme.lightGray,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  minHeight: 25,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  style: TextStyle(
                    color: const Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppButton(
                  onTap: () {},
                  text: 'Next',
                  color: AppTheme.lightGray,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  minHeight: 25,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  style: TextStyle(
                    color: const Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              'Card 1 of 8',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timer() {
    return _section(
      title: 'Pomodoro Timer',
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
              '25:00',
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
                  onTap: () {},
                  text: 'Start',
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  minHeight: 25,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppButton(
                  onTap: () {},
                  text: 'Reset',
                  color: AppTheme.lightGray,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  minHeight: 25,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  style: TextStyle(
                    color: const Color(0xFF374151),
                    fontSize: 14,
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
                    fontSize: 14,
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
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),
      ),
    );
  }
}
