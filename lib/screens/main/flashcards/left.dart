import 'package:navinotes/packages.dart';
import 'vm.dart';

class FlashCardsMobileCreationLeft extends StatelessWidget {
  const FlashCardsMobileCreationLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsMobileCreationVm>(
      builder: (_, vm, _) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [_creationMode(), _deckManagement(vm)],
                  ),
                ), 
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _deckManagement(FlashCardsMobileCreationVm vm) {
    final labelStyle = AppTheme.text.copyWith(
      color: AppTheme.steelMist,
      fontSize: 12.0,
    );
    return _sections(
      title: 'Deck Management',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          CustomInputField(
            label: 'Deck Name',
            controller: TextEditingController(text: 'Neuroscience Basics'),
            labelStyle: labelStyle,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  'Cards in deck:',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.stormGray,
                    height: 1.0,
                  ),
                ),
              ),
              Text(
                '12',
                style: AppTheme.text.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Categories/Tags',
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                ),
              ),

              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  ...vm.tagFields.map((tagField) {
                    final controller = tagField.controller;
                    final focusNode = tagField.focusNode;

                    return ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (_, value, _) {
                        final style = AppTheme.text.copyWith(
                          color: const Color(0xFF1E40AF),
                          fontSize: 12.0,
                        );
                        final textWidth =
                            calculateTextWidth(value.text, style) + 30;
                        return WidthLimiter(
                          mobile: textWidth,
                          child: CustomInputField(
                            focusNode: focusNode,
                            controller: controller,
                            fillColor: AppTheme.paleBlue,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: BorderSide(color: AppTheme.paleBlue),
                            ),
                            style: style,
                            constraints: BoxConstraints(maxHeight: 30),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  AppButton(
                    onTap: vm.addTagField,
                    text: 'Add tag',
                    mainAxisSize: MainAxisSize.min,
                    color: AppTheme.lightAsh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    minHeight: 25,
                    prefix: Icon(
                      Icons.add,
                      color: AppTheme.defaultBlack,
                      size: 18,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    style: AppTheme.text.copyWith(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),

          CustomInputField(
            label: 'Spaced Repetition',
            controller: TextEditingController(text: 'Standard (1-3-7 days)'),
            selectItems: ['Standard (1-3-7 days)'],
            suffixIcon: Icon(Icons.keyboard_arrow_down),
            labelStyle: labelStyle,
          ),
        ],
      ),
    );
  }

  Widget _creationMode() {
    return _sections(
      title: 'Creation Mode',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          _creationModeItem(title: 'Manual Creation', isActive: true),
          _creationModeItem(title: 'AI-Assisted'),
          _creationModeItem(title: 'Import from Notes'),
          _creationModeItem(title: 'Batch Creation'),
        ],
      ),
    );
  }

  Widget _creationModeItem({required String title, bool isActive = false}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.vividRose : null,
            border: Border.all(
              color: isActive ? AppTheme.transparent : AppTheme.coolGray,
            ),
            shape: BoxShape.circle,
          ),
        ),
        selected: isActive,
        selectedTileColor: AppTheme.iceBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: isActive ? AppTheme.pastelBlue : AppTheme.coolGray,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.text.copyWith(
            fontWeight: isActive ? getFontWeight(500) : null,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _sections({required Widget child, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.darkSlateGray,
            fontSize: 16.0,
            fontWeight: getFontWeight(600),
          ),
        ),
        child,
      ],
    );
  }
}
