import 'dart:math';
import 'package:navinotes/packages.dart';
import 'main_empty.dart';
import 'vm.dart';

class RecentNotesMain extends StatelessWidget {
  const RecentNotesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentNotesVm>(
      builder: (_, vm, _) {
        return Column(
          spacing: 10,
          children: [
            SearchBarHeader(openDrawer: vm.openDrawer, borderBottom: true),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(10),
                tabletPadding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding,
                  vertical: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    spacing: 25,
                    children: [
                      // RecentNotesFilter(), // Commented out as it's not defined
                      if (vm.isLoading)
                        Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading recent notes...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (vm.hasData)
                        Column(
                          spacing: 25,
                          children: [
                            Column(
                              spacing: 10,
                              children:
                                  vm.recentContents
                                      .map(
                                        (content) => _buildContentCard(content),
                                      )
                                      .toList(),
                            ),
                            _footer(),
                          ],
                        )
                      else
                        EmptyRecentNotesMain(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _footer() {
    return SizedBox.shrink();
  }

  Widget _buildContentCard(Content content) {
    // Get icon based on content type
    Widget icon;

    switch (content.type) {
      case AppContentType.note:
        icon = SVGImagePlaceHolder(
          imagePath: Images.file,
          size: 16,
          color: AppTheme.tealStone,
        );
        break;
      case AppContentType.mindmap:
        icon = SVGImagePlaceHolder(
          imagePath: Images.share,
          size: 16,
          color: AppTheme.vitalGreen,
        );
        break;
      case AppContentType.flashcardDeck:
        icon = SVGImagePlaceHolder(
          imagePath: Images.file,
          size: 16,
          color: AppTheme.vividBlue,
        );
        break;
      case AppContentType.file:
        icon = SVGImagePlaceHolder(
          imagePath: Images.pdf,
          size: 16,
          color: AppTheme.bloodFire,
        );
        break;
    }

    // Format the updated date
    final updatedDate = DateTime.fromMillisecondsSinceEpoch(
      content.updatedAt * 1000,
    );
    final formattedDate = _formatDate(updatedDate);

    return InkWell(
      onTap: () => NavigationHelper.navigateToContent(content),
      child: _noteCard(
        image: icon,
        title:
            content.title.isNotEmpty
                ? content.title
                : 'Untitled ${content.type.name}',
        subject: content.type.toString().toUpperCase(),
        lastUpdated: formattedDate,
      ),
    );
  }

  Widget _noteCard({
    required String title,
    required String subject,
    required String lastUpdated,
    required Widget image,
  }) {
    return CustomCard(
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 7,
                      children: [
                        image,
                        Flexible(
                          child: Text(
                            title,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.charcoalBlue,
                              fontSize: 16.0,
                              fontWeight: getFontWeight(500),
                              height: 1.50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: subject,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.tealStone,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  lastUpdated,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.steelMist,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
