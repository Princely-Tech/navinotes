import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/import_pdf/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class ImportPdfAside extends StatelessWidget {
  const ImportPdfAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImportPdfVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: Apptheme.whiteSmoke,
            border: Border(
              right: BorderSide(width: 2, color: Apptheme.lightGray),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ScrollableController(
                  mobilePadding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 30,
                    children: [_quickFilters(vm), _importTo(), _preview()],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _preview() {
    return _section(
      title: 'Preview',
      children: [
        CustomCard(
          padding: EdgeInsets.all(10),
          child: Text(
            'Select a PDF to preview',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: getFontWeight(400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _importToItem({
    required String title,
    required SVGImagePlaceHolder icon,
  }) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Row(
            spacing: 10,
            children: [
              SVGImagePlaceHolder(
                imagePath: icon.imagePath,
                color: icon.color,
                size: 16,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF374151),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: getFontWeight(400),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Apptheme.blueGray,
        ),
      ],
    );
  }

  Widget _importTo() {
    return _section(
      title: 'Import To',
      spacing: 20,
      children: [
        _importToItem(
          title: 'Neuroscience',
          icon: SVGImagePlaceHolder(
            imagePath: Images.logo,
            color: Apptheme.lavenderPurple,
          ),
        ),
        _importToItem(
          title: 'Biology 101',
          icon: SVGImagePlaceHolder(
            imagePath: Images.flask,
            color: Apptheme.teal,
          ),
        ),
        _importToItem(
          title: 'Statistics',
          icon: SVGImagePlaceHolder(
            imagePath: Images.calculator,
            color: Apptheme.vividBlue,
          ),
        ),
      ],
    );
  }

  Widget _quickFilters(ImportPdfVm vm) {
    return _section(
      title: 'Quick Filters',
      children: [
        quickFilterItem(title: 'All PDFs', icon: Images.pdf, vm: vm),
        quickFilterItem(title: 'Study Materials', icon: Images.book, vm: vm),
        quickFilterItem(title: 'Research Papers', icon: Images.chart, vm: vm),
        quickFilterItem(title: 'Favorites', icon: Images.star, vm: vm),
      ],
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
    double spacing = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: getFontWeight(500),
            height: 1,
            letterSpacing: 0.70,
          ),
        ),
        Column(spacing: spacing, children: children),
      ],
    );
  }

  Widget quickFilterItem({
    required String title,
    required String icon,
    required ImportPdfVm vm,
  }) {
    bool isActive = vm.selectedFilter == title;
    final color = isActive ? Apptheme.strongBlue : Apptheme.steelMist;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: SVGImagePlaceHolder(imagePath: icon, size: 14, color: color),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        selected: isActive,
        selectedTileColor: Apptheme.iceBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: Text(
          title,
          style: Apptheme.text.copyWith(
            color: color,
            fontSize: 16,
            fontWeight: getFontWeight(500),
          ),
        ),
        onTap: () => vm.updateSelectedFilter(title),
      ),
    );
  }
}
