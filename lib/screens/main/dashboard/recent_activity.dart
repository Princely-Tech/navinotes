import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({super.key});

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  List<Content> recentContents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentContents();
  }

  Future<void> _loadRecentContents() async {
    try {
      // Get 8 most recent contents of any type
      recentContents = await DatabaseHelper.instance.getRecentContentsAcrossAllBoards(limit: 8);
    } catch (e) {
      debugPrint('Error loading recent contents: $e');
      recentContents = [];
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          'Recent Activity',
          style: AppTheme.text.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isLoading)
          CustomCard(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading recent activity...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (recentContents.isEmpty)
          CustomCard(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No recent activity',
                    style: AppTheme.text.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create some content to see your activity here',
                    style: AppTheme.text.copyWith(
                      fontSize: 14.0,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          CustomCard(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                for (int i = 0; i < recentContents.length; i++) ...[
                  _buildContentCard(recentContents[i]),
                  if (i < recentContents.length - 1)
                    Divider(color: AppTheme.lightGray, height: 40),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContentCard(Content content) {
    // Get content type and appropriate icon/color
    final contentTitle = content.title.isNotEmpty ? content.title : 'Untitled ${content.type.name}';
    final iconData = _getContentIcon(content.type);
    final iconColor = _getContentColor(content.type);
    final contentType = _getContentTypeLabel(content.type);
    
    // Format the updated date
    final updatedDate = DateTime.fromMillisecondsSinceEpoch(
      content.updatedAt * 1000,
    );
    final formattedDate = _formatDate(updatedDate);
    
    // Get board name if available
    final boardName = _getBoardName(content.boardId);

    return InkWell(
      onTap: () => NavigationHelper.navigateToContent(content),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: iconColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          contentTitle,
                          style: AppTheme.text.copyWith(
                            fontSize: 16.0,
                            fontWeight: getFontWeight(500),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          contentType,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.vividRose,
                            fontSize: 12.0,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                        if (boardName.isNotEmpty)
                          Text(
                            boardName,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.stormGray,
                              fontSize: 12.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VisibleController(
              mobile: false,
              tablet: true,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  formattedDate,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.steelMist,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getContentIcon(AppContentType type) {
    switch (type) {
      case AppContentType.note:
        return Icons.note;
      case AppContentType.mindmap:
        return Icons.account_tree;
      case AppContentType.flashcardDeck:
        return Icons.quiz;
      case AppContentType.file:
        return Icons.insert_drive_file;
      default:
        return Icons.description;
    }
  }

  Color _getContentColor(AppContentType type) {
    switch (type) {
      case AppContentType.note:
        return AppTheme.vividBlue;
      case AppContentType.mindmap:
        return AppTheme.vitalGreen;
      case AppContentType.flashcardDeck:
        return AppTheme.orange;
      case AppContentType.file:
        return AppTheme.bloodFire;
      default:
        return AppTheme.paleBlue;
    }
  }

  String _getContentTypeLabel(AppContentType type) {
    switch (type) {
      case AppContentType.note:
        return 'NOTE';
      case AppContentType.mindmap:
        return 'MIND MAP';
      case AppContentType.flashcardDeck:
        return 'FLASHCARDS';
      case AppContentType.file:
        return 'FILE';
      default:
        return 'CONTENT';
    }
  }

  String _getBoardName(int boardId) {
    // This would ideally come from a cached boards list or be passed down
    // For now, return empty string as board name lookup would require additional database call
    return '';
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
