import 'package:navinotes/packages.dart';

class BoardEditUploads extends StatelessWidget {
  const BoardEditUploads(this.vm, {super.key});
  final BoardEditVm vm;

  @override
  Widget build(BuildContext context) {
    if (vm.uploadedFiles.isEmpty) {
      return EmptyState(
        icon: Icons.folder_open,
        title: 'No files yet',
        subtitle: 'Upload files to get started',
        footer: AppButton(
          loading: vm.fetchingFiles,
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
            final size = getFileSize(metaDataSize);
            final name = file.title;
            return CustomCard(
              addBorder: true,
              addCardShadow: true,
              child: InkWell(
                onTap: () {
                  NavigationHelper.navigateToContent(file);
                },
                child: Row(
                  children: [
                    // Image preview or icon
                    _buildFilePreview(file),
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
                              fontSize: 16.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            size,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
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
                                          NavigationHelper.navigateToContent(
                                            file,
                                          );
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
                                                () => vm.loadFiles(vm.board.id),
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
              ),
            );
          }).toList(),
    );
  }

  Widget _buildFilePreview(Content file) {
    final filePath = file.file;
    if (filePath == null) {
      return _buildFileIconPreview(file);
    }

    // Check if it's an image file
    final extension = filePath.toLowerCase();
    final isImage =
        extension.endsWith('.png') ||
        extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.gif') ||
        extension.endsWith('.webp') ||
        extension.endsWith('.bmp');

    if (isImage && File(filePath).existsSync()) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFileIconPreview(file);
            },
          ),
        ),
      );
    }

    return _buildFileIconPreview(file);
  }

  Widget _buildFileIconPreview(Content file) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: Icon(
          getFileIcon(file.file),
          size: 32,
          color: AppTheme.vividBlue,
        ),
      ),
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
