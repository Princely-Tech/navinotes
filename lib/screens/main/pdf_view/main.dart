import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:navinotes/packages.dart';

class PdfViewMain extends StatelessWidget {
  const PdfViewMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfViewVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            PdfViewHeader(),
            Expanded(
              child:
                  isNotNull(vm.comPdfVm.document)
                      ? CPDFReaderWidget(
                        document: vm.comPdfVm.document!,
                        configuration: CPDFConfiguration(
                          toolbarConfig: CPDFToolbarConfig(
                            mainToolbarVisible: false,
                          ),
                          contentEditorConfig: CPDFContentEditorConfig(),
                          readerViewConfig: CPDFReaderViewConfig(
                            verticalMode: false,
                            displayMode: CPDFDisplayMode.singlePage,
                            continueMode: false,
                            enableSliderBar: false,
                            enablePageIndicator: false,
                          ),
                          modeConfig: CPDFModeConfig(
                            initialViewMode: CPDFViewMode.annotations,
                          ),
                          annotationsConfig: CPDFAnnotationsConfig(
                            annotationAuthor: 'Navinotes',
                            availableTypes: [
                              CPDFAnnotationType.highlight,
                              CPDFAnnotationType.underline,
                              CPDFAnnotationType.strikeout,
                              CPDFAnnotationType.freetext,
                              CPDFAnnotationType.ink,
                              CPDFAnnotationType.ink_eraser,
                              CPDFAnnotationType.note,
                              CPDFAnnotationType.pencil,
                              CPDFAnnotationType.pictures,
                              CPDFAnnotationType.squiggly,
                              CPDFAnnotationType.strikeout,
                              CPDFAnnotationType.arrow,
                            ],
                          ),
                        ),
                        onSaveCallback: () {
                          print('Saved');
                        },
                        onCreated: (controller) {
                          print('Created');
                          // controller.
                        },
                      )
                      : const Center(child: CircularProgressIndicator()),
            ),
            PdfViewFooter(),
          ],
        );
      },
    );
  }
}
