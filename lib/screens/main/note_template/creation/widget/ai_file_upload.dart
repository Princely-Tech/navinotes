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
        return AppButton.secondary(
          onTap: () {},
          loading: isLoading,
          text: 'Upload File',
          minHeight: 40,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        );
      },
    );
  }
}
