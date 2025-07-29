import 'package:navinotes/packages.dart';
import 'vm.dart';

double itemSpacing = 30;
const hintStyle = TextStyle(
  color: const Color(0xFFADAEBC),
  fontSize: 16.0,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  height: 1.50,
);
final labelStyle = TextStyle(
  color: const Color(0xFF374151),
  fontSize: 14.0,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);

class PrelabReportScreen extends StatelessWidget {
  const PrelabReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteLabReportVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            _header(),
            _selectSection(),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(15),
                child: Column(
                  spacing: 15,
                  children: [
                    _titleSection(),
                    ResponsiveSection(
                      mobile: Column(
                        spacing: itemSpacing,
                        children: [
                          _objectiveTheoryResult(),
                          _variableReferenceSafety(),
                        ],
                      ),
                      desktop: Row(
                        spacing: itemSpacing,
                        children: [
                          Expanded(child: _objectiveTheoryResult()),
                          WidthLimiter(
                            mobile: 255,
                            largeDesktop: 400,
                            child: _variableReferenceSafety(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _variableReferenceSafety() {
    return Column(
      children: [
        //
      ],
    );
  }

  Widget _objectiveTheoryResult() {
    return Column(
      spacing: itemSpacing,
      children: [
        // _objective(),
        // _theory(),
        _expectedResult(),
      ],
    );
  }

  Widget _expectedResult() {
    return _section(
      title: 'Expected Results',
      headerRight: Icon(Icons.more_vert, color: const Color(0xFF9CA3AF)),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            label: 'Prediction',
            hintText:
                'Based on preliminary observations, I expect the unknown acid to have a concentration between 0.1-0.2 M. The titration curve should show...',
            labelStyle: labelStyle,
            hintStyle: hintStyle,
          ),
          //
        ],
      ),
    );
  }

  Widget _theory() {
    return _section(
      title: 'Background Theory',
      headerRight: QuillSimpleToolbar(
        controller: QuillController.basic(),
        config: buildCustomToolbarConfig(
          showBoldButton: true,
          showItalicButton: true,
          showLink: true,
          showListBullets: true,
        ),
      ),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.coolGray),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.all(15),
            child: QuillEditor.basic(
              controller: QuillController.basic(),
              config: const QuillEditorConfig(
                placeholder:
                    'In acid-base titration, a solution of known concentration (titrant) is used to determine the concentration of another solution (analyte). The reaction involves the neutralization of an acid with a base...',
                customStyles: DefaultStyles(
                  placeHolder: DefaultTextBlockStyle(
                    hintStyle,
                    HorizontalSpacing.zero,
                    VerticalSpacing.zero,
                    VerticalSpacing.zero,
                    BoxDecoration(),
                  ),
                ),
              ),
            ),
          ),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Key Equations', style: labelStyle),
              CustomCard(
                addBorder: true,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _equationInput(
                      label: 'Acid-Base Neutralization',
                      value: 'HA + NaOH → NaA + H₂O',
                    ),
                    _equationInput(
                      label: 'Concentration Calculation',
                      value: 'C₁V₁ = C₂V₂',
                    ),
                    AppButton.text(
                      onTap: () {},
                      text: 'Add Equation',
                      prefix: Icon(Icons.add, color: const Color(0xFF0284C7)),
                      color: const Color(0xFF0284C7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _equationInput({required String label, required String value}) {
    return CustomInputField(
      label: label,
      labelRight: Padding(
        padding: const EdgeInsets.all(5),
        child: AppButton.text(
          onTap: () {},
          text: 'Edit',
          color: const Color(0xFF0284C7),
        ),
      ),

      controller: TextEditingController(text: value),
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        height: 1.43,
      ),
      hintStyle: hintStyle,
    );
  }

  Widget _objective() {
    return _section(
      title: 'Experiment Objective',
      headerRight: Icon(Icons.more_vert, color: const Color(0xFF9CA3AF)),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            label: 'What are you trying to determine?',
            labelStyle: labelStyle,
            hintStyle: hintStyle,
            maxLines: 4,
            hintText:
                'To determine the concentration of an unknown acid solution by titration with a standardized base solution...',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Hypothesis',
                style: TextStyle(
                  color: const Color(0xFF374151),
                  fontSize: 14.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              _hypothesisInput(
                hintText:
                    'the unknown acid is titrated with a standardized NaOH solution',
                label: 'If',
              ),
              _hypothesisInput(
                hintText:
                    'the concentration can be calculated from the volume of base required to reach the equivalence point',
                label: 'then',
              ),
            ],
          ),
          CustomInputField(
            label: 'Research Question',
            hintText:
                'What is the molar concentration of the unknown acid solution?',
            labelStyle: labelStyle,
            hintStyle: hintStyle,
          ),
        ],
      ),
    );
  }

  Widget _hypothesisInput({required String label, required String hintText}) {
    return Row(
      spacing: 5,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF4B5563),
            fontSize: 14.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        Expanded(
          child: CustomInputField(
            hintText: hintText,
            labelStyle: labelStyle,
            hintStyle: hintStyle,
          ),
        ),
      ],
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    required Widget headerRight,
  }) {
    return CustomCard(
      padding: EdgeInsets.zero,
      addBorder: true,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              spacing: 15,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.56,
                    ),
                  ),
                ),
                headerRight,
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(15), child: child),
        ],
      ),
    );
  }

  Widget _titleSection() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<NoteLabReportVm>(
          builder: (_, vm, _) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    'Acid-Base Titration',
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: getDeviceResponsiveValue(
                        deviceType: layoutVm.deviceType,
                        mobile: 20,
                        tablet: 25,
                        desktop: 30,
                      ),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                    ),
                  ),
                ),
                VisibleController(
                  mobile: false,
                  tablet: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      spacing: 15,
                      children: [
                        AppButton(
                          onTap: () {},
                          text: 'Preview',
                          mainAxisSize: MainAxisSize.min,
                          prefix: SVGImagePlaceHolder(imagePath: Images.eye2),
                          minHeight: 38,
                          color: AppTheme.white,
                          spacing: 10,
                          textColor: const Color(0xFF374151),
                          borderColor: AppTheme.lightGray,
                        ),
                        AppButton(
                          onTap: vm.goToMethods,
                          text: 'Next: Methods',
                          mainAxisSize: MainAxisSize.min,
                          color: const Color(0xFF0284C7),
                          minHeight: 38,
                          spacing: 10,
                          prefix: Icon(
                            Icons.arrow_forward,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _selectSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextRowSelect(
        items: ['Pre-Lab', 'Methods', 'Data', 'Results'],
        selected: 'Pre-Lab',
        inActiveBorderColor: AppTheme.lightGray,
        borderColor: const Color(0xFF0284C7),
        padding: EdgeInsets.symmetric(vertical: 15),
        selectedTextStyle: TextStyle(
          color: const Color(0xFF0284C7),
          fontSize: 14.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        style: TextStyle(
          color: const Color(0xFF6B7280),
          fontSize: 14.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          AppButton.text(
            wrapWithFlexible: true,
            onTap: NavigationHelper.pop,
            child: Expanded(
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
                  SVGImagePlaceHolder(imagePath: Images.comicalFlask, size: 32),
                  Expanded(
                    child: Text(
                      'Lab Report Builder',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                  ),

                  //
                ],
              ),
            ),
          ),

          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                spacing: 15,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),

                      const Text(
                        'Changes saved',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 14.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  AppButton(
                    onTap: () {},
                    color: Color(0xFFF3F4F6),
                    textColor: Color(0xFF374151),
                    text: 'Export',
                    mainAxisSize: MainAxisSize.min,
                    minHeight: 40,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.upload4,
                      size: 14,
                      color: AppTheme.black,
                    ),
                  ),

                  ProfilePic(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
