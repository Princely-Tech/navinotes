import 'package:navinotes/packages.dart';
import 'package:path/path.dart' as path;

class BoardEditUploads extends StatelessWidget {
  const BoardEditUploads(this.vm, {super.key});
  final BoardEditVm vm;

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(String? filePath) {
    if (filePath == null) return Icons.insert_drive_file;

    final ext = path.extension(filePath).toLowerCase();
    switch (ext) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.xls':
      case '.xlsx':
      case '.csv':
        return Icons.table_chart;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      case '.txt':
        return Icons.article;
      case '.zip':
      case '.rar':
      case '.7z':
        return Icons.archive;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Icons.image;
      case '.mp3':
      case '.wav':
        return Icons.audio_file;
      case '.mp4':
      case '.mov':
      case '.avi':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (vm.fetchingFiles) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.uploadedFiles.isEmpty) {
      return EmptyState(
        icon: Icons.folder_open,
        title: 'No files yet',
        subtitle: 'Upload files to get started',
        footer: AppButton(
          onTap: () {
            vm.importFiles(context);
          },
          text: 'Import Files',
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }
    return CustomGrid(
      wrapWithIntrinsicHeight: false,
      children:
          vm.uploadedFiles.map((file) {
            final metaDataSize = file.metaData[ContentMetadataKey.fileSize];
            final size =
                metaDataSize is int
                    ? _formatFileSize(metaDataSize)
                    : 'Unknown size';
            final name = file.title;
            return CustomCard(
              addBorder: true,
              addCardShadow: true,
              child: Row(
                children: [
                  Icon(
                    _getFileIcon(file.file),
                    size: 40,
                    color: AppTheme.vividBlue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          size,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showPopover(
                            context: context,
                            bodyBuilder:
                                (context) => ListView(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  children: [
                                    _buildMenuItem(
                                      icon: Icons.open_in_new,
                                      label: 'Open',
                                      onTap: () {
                                        handleOpenFile(file, context);
                                      },
                                    ),
                                    const Divider(height: 1, thickness: 1),
                                    _buildMenuItem(
                                      icon: Icons.download,
                                      label: 'Download',
                                      onTap: () {
                                        handleFileDownload(file, context);
                                      },
                                    ),
                                    const Divider(height: 1, thickness: 1),
                                    _buildMenuItem(
                                      icon: Icons.delete_outline,
                                      label: 'Delete',
                                      textColor: AppTheme.coralRed,
                                      onTap: () {
                                        handleContentDelete(
                                          file: file,
                                          context: context,
                                          onSuccess:
                                              () => vm.loadFiles(vm.board!.id!),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            direction: PopoverDirection.bottom,
                            width: 160,
                            height: 140,
                            arrowHeight: 10,
                            arrowWidth: 20,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            NavigationHelper.pop();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color:
                      textColor ??
                      Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        textColor ??
                        Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
