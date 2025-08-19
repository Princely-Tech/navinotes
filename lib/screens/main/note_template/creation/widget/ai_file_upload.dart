import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

class AiSummaryFileUpload extends StatefulWidget {
  const AiSummaryFileUpload({super.key});

  @override
  State<AiSummaryFileUpload> createState() => _AiSummaryFileUploadState();
}

class _AiSummaryFileUploadState extends State<AiSummaryFileUpload> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        if (vm.aiSummaryFile != null) {
          return Row(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vm.aiSummaryFile!.name,
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

  Future<void> importFiles(BuildContext context, NoteCreationVm vm) async {
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
        vm.updateAiSummaryFile(pickedFile);
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
