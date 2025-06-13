import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class ImportPdfMain extends StatelessWidget {
  const ImportPdfMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ScrollableController(
            padding: EdgeInsets.all(defaultHorizontalPadding),
            child: Column(
              spacing: 30,
              children: [
                _dragAndDropArea(),
                _importFromCloud(),
                _recentlyUpdated(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentItem({required String title, required String updatedDate}) {
    return CustomCard(
      width: null,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Apptheme.lightAsh,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 128,
                width: double.infinity,
                child: Center(
                  child: SVGImagePlaceHolder(
                    imagePath: Images.pdf,
                    size: 36,
                    color: Apptheme.coralRed,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: AppButton(
                  minHeight: 24,
                  onTap: () {},
                  color: Apptheme.white,
                  padding: EdgeInsets.zero,
                  shape: CircleBorder(),
                  child: Icon(Icons.more_vert),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text(
                  title,
                  style: Apptheme.text.copyWith(fontWeight: getFontWeight(500)),
                ),
                Text(
                  'Uploaded on $updatedDate',
                  style: Apptheme.text.copyWith(
                    color: Apptheme.steelMist,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentlyUpdated() {
    return Column(
      spacing: 15,
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: Text(
                'Recently Uploaded PDFs',
                style: Apptheme.text.copyWith(
                  color: Apptheme.darkSlateGray,
                  fontWeight: getFontWeight(500),
                ),
              ),
            ),
            AppButton.text(onTap: () {}, text: 'View All'),
          ],
        ),
        CustomGrid(
          children: [
            _recentItem(
              title: 'Neural Networks Study.pdf',
              updatedDate: 'May 1, 2025',
            ),
            _recentItem(
              title: 'Cognitive Psychology.pdf',
              updatedDate: 'Apr 28, 2025',
            ),
            _recentItem(
              title: 'Research Methods.pdf',
              updatedDate: 'Apr 25, 2025',
            ),
            //
          ],
        ),
      ],
    );
  }

  Widget _importChild({required String name, required String image}) {
    return CustomCard(
      padding: EdgeInsets.all(15),
      width: null,
      child: Column(
        spacing: 6,
        children: [
          SVGImagePlaceHolder(imagePath: image, size: 20),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Apptheme.text.copyWith(color: Apptheme.darkSlateGray),
          ),
        ],
      ),
    );
  }

  Widget _mobileImportChild(Widget child) {
    return Consumer<LayoutProviderVm>(
      builder: (_, vm, _) {
        double iWidth = vm.deviceWidth() / 4;
        return SizedBox(width: iWidth, child: child);
      },
    );
  }

  Widget _tabletImportChild(Widget child) {
    return Expanded(child: child);
  }

  Widget _importFromCloud() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Import from Cloud',
          style: Apptheme.text.copyWith(
            color: Apptheme.darkSlateGray,
            fontWeight: getFontWeight(500),
          ),
        ),
        ResponsiveSection(
          mobile: SizedBox(
            width: double.infinity,
            child: ScrollableRow(
              children: [
                _mobileImportChild(
                  _importChild(name: 'Google Drive', image: Images.drive),
                ),
                _mobileImportChild(
                  _importChild(name: 'iCloud', image: Images.cloud),
                ),
                _mobileImportChild(
                  _importChild(name: 'Dropbox', image: Images.dropbox),
                ),
                _mobileImportChild(
                  _importChild(name: 'URL Import', image: Images.url),
                ),
              ],
            ),
          ),
          tablet: Row(
            spacing: 15,
            children: [
              _tabletImportChild(
                _importChild(name: 'Google Drive', image: Images.drive),
              ),
              _tabletImportChild(
                _importChild(name: 'iCloud', image: Images.cloud),
              ),
              _tabletImportChild(
                _importChild(name: 'Dropbox', image: Images.dropbox),
              ),
              _tabletImportChild(
                _importChild(name: 'URL Import', image: Images.url),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dragAndDropArea() {
    return Container(
      decoration: DottedDecoration(
        color: Apptheme.strongBlue,
        shape: Shape.box,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(color: Apptheme.softSkyBlue.withAlpha(40)),
        padding: EdgeInsets.all(25),
        child: Column(
          spacing: 20,
          children: [
            OutlinedChild(
              size: 80,
              decoration: BoxDecoration(
                color: Apptheme.paleBlue,
                shape: BoxShape.circle,
              ),
              child: SVGImagePlaceHolder(imagePath: Images.upload2, size: 30),
            ),
            Text(
              'Drag & Drop PDFs here or tap to browse',
              textAlign: TextAlign.center,
              style: Apptheme.text.copyWith(
                fontSize: 18,
                fontWeight: getFontWeight(500),
              ),
            ),
            Text(
              'Supported formats: PDF only • Max size: 50MB',
              textAlign: TextAlign.center,
              style: Apptheme.text.copyWith(
                color: Apptheme.steelMist,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                AppButton(
                  minHeight: 42,
                  mainAxisSize: MainAxisSize.min,
                  wrapWithFlexible: true,
                  onTap: () {},
                  text: 'Browse Files',
                ),
                AppButton(
                  minHeight: 42,
                  prefix: SVGImagePlaceHolder(imagePath: Images.camera),
                  mainAxisSize: MainAxisSize.min,
                  wrapWithFlexible: true,
                  onTap: () {},
                  text: 'Scan Document',
                  textColor: Apptheme.darkSlateGray,
                  color: Apptheme.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Apptheme.coolGray),
                  ),
                ),
                //
              ],
            ),
            //
          ],
        ),
      ),
    );
  }
}
