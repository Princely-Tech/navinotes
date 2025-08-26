import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';

class ContentFileUpload extends StatefulWidget {
  const ContentFileUpload({super.key});

  @override
  State<ContentFileUpload> createState() => _ContentFileUploadState();
}

class _ContentFileUploadState extends State<ContentFileUpload> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        if (vm.contentFile != null) {
          return Row(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vm.contentFile!.name,
                  // overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              AppButton.text(
                onTap: () => importFiles(context, vm),
                loading: isLoading,
                text: 'Change',
                minHeight: 40,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
              ),
            ],
          );
        }

        return AppButton.secondary(
          onTap: () => importFiles(context, vm),
          loading: isLoading,
          text: 'Upload File',
          minHeight: 40,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        );
      },
    );
  }

  void updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> importFiles(BuildContext context, FlashCardCreationVm vm) async {
    try {
      updateLoading(true);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'txt',
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        vm.updateContentFile(pickedFile);
      }
    } catch (e) {
      debugPrint('Error importing file: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(context, 'Error importing file');
      }
    } finally {
      updateLoading(false);
    }
  }
}
