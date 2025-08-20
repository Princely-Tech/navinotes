import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/ai_file_upload.dart';
import 'package:path/path.dart';
import 'vm.dart';

class NoteAiSection extends StatelessWidget {
  NoteAiSection({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return VisibleController(
          mobile: vm.showAiSection,
          child: Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: WidthLimiter(
              mobile: 255,
              tablet: 400,
              child: Form(
                key: formKey,
                child: CustomCard(
                  addBorder: true,
                  addCardShadow: true,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _header(vm),
                      Expanded(
                        child: ScrollableController(
                          mobilePadding: EdgeInsets.only(bottom: 15),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.lightGray,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    TextRowSelect(
                                      items:
                                          AiSummaryType.values
                                              .map((e) => e.toString())
                                              .toList(),
                                      onSelected: (value) {
                                        vm.updateAiSummaryType(
                                          stringToEnum(
                                            value,
                                            AiSummaryType.values,
                                          ),
                                        );
                                      },
                                      selected:
                                          vm.selectedAiSummaryType.toString(),
                                      fillWidth: true,
                                      borderColor: AppTheme.vividRose,
                                      inActiveBorderColor: AppTheme.lightGray,
                                      selectedTextStyle: TextStyle(
                                        color: const Color(0xFF00555A),
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
                                    Builder(
                                      builder: (context) {
                                        switch (vm.selectedAiSummaryType) {
                                          case AiSummaryType.fromNotes:
                                            return Text(
                                              'Let AI summarize your current note',
                                              style: AppTheme.text.copyWith(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                // color: AppTheme.gray,
                                              ),
                                            );
                                          case AiSummaryType.upload:
                                            return AiSummaryFileUpload();
                                          case AiSummaryType.textInput:
                                            return CustomInputField(
                                              hintText:
                                                  'Enter text to process...',
                                              controller: vm.summaryController,
                                              maxLines: 3,
                                              validator:
                                                  (value) => noNullValidator(
                                                    value: value,
                                                    message:
                                                        'Summary text is required',
                                                  ),
                                              hintStyle: TextStyle(
                                                color: const Color(0xFFADAEBC),
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 1.43,
                                              ),
                                            );
                                        }
                                      },
                                    ),

                                    Column(
                                      spacing: 5,
                                      children: [
                                        _input(
                                          title: 'Summary Length',
                                          controller:
                                              vm.summaryLengthController,
                                          isNumber: true,
                                        ),
                                        _input(
                                          title: 'Focus Area',
                                          controller: vm.focusAreaController,
                                          isNumber: false,
                                        ),
                                        AppButton(
                                          onTap: () {
                                            vm.summarizeContent(
                                              context,
                                              formKey,
                                            );
                                          },
                                          loading: vm.processingSummary,
                                          text: 'Process Content',
                                          minHeight: 40,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isNotNull(vm.summary))
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      _summary(),
                                      _btns(), //TODO return to this
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _btns() {
    final style = TextStyle(
      color: const Color(0xFF374151),
      fontSize: 14.0,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
    );
    final padding = EdgeInsets.symmetric(vertical: 5, horizontal: 15);

    return Consumer<NoteCreationVm>(
      builder: (context, vm, _) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AppButton(
              loading: vm.creatingContent,
              onTap: () async {
                try {
                  await createContentInDb(
                    template: vm.template,
                    context: context,
                    boardId: vm.content!.boardId,
                    setLoading: vm.setCreatingContent,
                    title: 'Ai - ${vm.content!.title}',
                    contentBody: vm.summary,
                  );
                } catch (err) {
                  if (context.mounted) {
                    MessageDisplayService.showErrorMessage(
                      context,
                      'Failed to create note',
                    );
                  }
                }
              },
              text: 'Save as Note',
              color: AppTheme.lightAsh,
              prefix: SVGImagePlaceHolder(
                imagePath: Images.sdCard2,
                color: AppTheme.darkSlateGray,
                size: 16,
              ),
              minHeight: 40,
              style: style,
              padding: padding,
              mainAxisSize: MainAxisSize.min,
            ),
            AppButton(
              onTap: () {},
              text: 'Create FlashCards',
              color: AppTheme.lightAsh,
              prefix: SVGImagePlaceHolder(
                imagePath: Images.stack,
                color: AppTheme.darkSlateGray,
                size: 16,
              ),
              minHeight: 40,
              style: style,
              padding: padding,
              mainAxisSize: MainAxisSize.min,
            ),
            AppButton(
              onTap: () {},
              text: 'Insert to Mind Map',
              color: AppTheme.lightAsh,
              prefix: Icon(Icons.add, color: AppTheme.darkSlateGray),
              minHeight: 40,
              style: style,
              padding: padding,
              mainAxisSize: MainAxisSize.min,
            ),
            AppButton(
              onTap: () {
                Clipboard.setData(ClipboardData(text: vm.summary!)).then((
                  value,
                ) {
                  if (context.mounted) {
                    MessageDisplayService.showMessage(
                      context,
                      'Copied to Clipboard',
                    );
                  }
                });
              },
              text: 'Copy to Clipboard',
              color: AppTheme.lightAsh,
              prefix: SVGImagePlaceHolder(
                imagePath: Images.copy,
                color: AppTheme.darkSlateGray,
                size: 16,
              ),
              minHeight: 40,
              style: style,
              padding: padding,
              mainAxisSize: MainAxisSize.min,
            ),
          ],
        );
      },
    );
  }

  Widget _summary() {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return CustomCard(
          addBorder: true,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: AppTheme.whiteSmoke),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                'Summary',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                vm.summary ?? '',
                style: TextStyle(
                  color: const Color(0xFF374151),
                  fontSize: 14.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _input({
    required String title,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF374151),
              fontSize: 14.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        WidthLimiter(
          mobile: 100,
          child: CustomInputField(
            contentPadding: EdgeInsets.all(10),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _header(NoteCreationVm vm) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
          ),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SVGImagePlaceHolder(imagePath: Images.aiIcon, size: 35),
              IconButton(onPressed: vm.closeAiSection, icon: Icon(Icons.close)),
            ],
          ),
        ),
        _selectRow(),
      ],
    );
  }

  Widget _selectRow() {
    List<String> selectItems = [
      '📝 Summarize',
      '🗃️ Generate FlashCards',
      '🔍 Extract Key Concepts',
    ];
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: IntrinsicHeight(
        child: Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              selectItems.map((str) {
                bool isSelected = str == selectItems.first;
                return Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            isSelected
                                ? BorderSide(color: AppTheme.vividRose)
                                : BorderSide.none,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AppButton.text(
                      onTap: () {},
                      child: Flexible(
                        child: Text(
                          str,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? const Color(0xFF00555A)
                                    : const Color(0xFF6B7280),
                            fontSize: 14.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
