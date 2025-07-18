import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/compare_contrast/vm.dart';

class NoteCompareContrastMain extends StatelessWidget {
  const NoteCompareContrastMain({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      // height: 1000,
      addBorder: true,
      child: Column(children: [_header(), Flexible(child: _table())]),
    );
  }

  Widget _table() {
    return Consumer<NoteCompareContrastVm>(
      builder: (_, vm, _) {
        return DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          dataRowHeight: 300,

          columns: [
            DataColumn2(
              label: Text(
                'Category',
                style: TextStyle(
                  color: const Color(0xFF374151),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),
            DataColumn2(
              label: _tableHeaderInput(
                controller: TextEditingController(text: 'Prokaryotic Cells'),
                color: const Color(0xFF0EA5E9),
                textColor: const Color(0xFF0369A1),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: _tableHeaderInput(
                controller: TextEditingController(text: 'Eukaryotic Cells'),
                color: const Color(0xFFF97316),
                textColor: const Color(0xFFC2410C),
              ),
              size: ColumnSize.L,
            ),
          ],
          rows:
              ['Structure', 'Function', 'Example']
                  .map(
                    (str) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            str,
                            style: TextStyle(
                              color: const Color(0xFF374151),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          _richTextEditor(
                            color: const Color(0xFF0EA5E9),
                            controller: vm.richEditorController1,
                          ),
                        ),
                        DataCell(
                          _richTextEditor(
                            color: const Color(0xFFF97316),
                            controller: vm.richEditorController2,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _richTextEditor({
    required QuillController controller,
    required Color color,
  }) {
    return Column(
      children: [
        Expanded(
          child: QuillEditor.basic(
            controller: controller,
            config: const QuillEditorConfig(),
          ),
        ),
      ],
    );
  }

  Widget _tableHeaderInput({
    required TextEditingController controller,
    required Color color,
    required Color textColor,
  }) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 15,
        children: [
          Expanded(
            child: Text(
              'Comparison Grid',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.56,
              ),
            ),
          ),

          Row(
            spacing: 15,
            children: [
              AppButton.secondary(
                onTap: () {},
                text: 'View',
                color: AppTheme.lightGray,
                mainAxisSize: MainAxisSize.min,
                padding: EdgeInsets.all(10),
                minHeight: 40,
                textColor: AppTheme.black,
                prefix: SVGImagePlaceHolder(
                  imagePath: Images.eye,
                  size: 16,
                  color: AppTheme.black,
                ),
              ),
              AppButton.secondary(
                onTap: () {},
                text: 'Fill',
                color: AppTheme.lightGray,
                mainAxisSize: MainAxisSize.min,
                padding: EdgeInsets.all(10),
                minHeight: 40,
                textColor: AppTheme.black,
                spacing: 10,
                prefix: SVGImagePlaceHolder(
                  imagePath: Images.aiIcon,
                  size: 30,
                  color: AppTheme.black,
                ),
              ),
              AppButton.secondary(
                onTap: () {},
                text: 'Format',
                color: AppTheme.lightGray,
                mainAxisSize: MainAxisSize.min,
                padding: EdgeInsets.all(10),
                minHeight: 40,
                textColor: AppTheme.black,
                spacing: 10,
                prefix: SVGImagePlaceHolder(
                  imagePath: Images.draw,
                  size: 16,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
