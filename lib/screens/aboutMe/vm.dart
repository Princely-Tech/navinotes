import 'package:navinotes/packages.dart';

enum ApplicationReason {
  studyingForExams,
  projectPlanning,
  researchOrganization,
  creativeBrainstorming,
  courseNotes,
  other;

  @override
  toString() {
    switch (this) {
      case studyingForExams:
        return 'Studying for exams';
      case projectPlanning:
        return 'Project planning';
      case researchOrganization:
        return 'Research organization';
      case creativeBrainstorming:
        return 'Creative brainstorming';
      case courseNotes:
        return 'Course notes';
      case other:
        return 'Other';
    }
  }

  String shortName() {
    switch (this) {
      case studyingForExams:
        return 'Studying';
      case projectPlanning:
        return 'Planning';
      case researchOrganization:
        return 'Research';
      case creativeBrainstorming:
        return 'Brainstorming';
      case courseNotes:
        return 'Notes';
      case other:
        return 'Other reasons';
    }
  }
}

List<ApplicationReason> applicationReasons = [
  ApplicationReason.studyingForExams,
  ApplicationReason.projectPlanning,
  ApplicationReason.researchOrganization,
  ApplicationReason.creativeBrainstorming,
  ApplicationReason.courseNotes,
  ApplicationReason.other,
];

class AboutMeVm extends ChangeNotifier {
  bool isLoading = false;
  ApiServiceProvider apiServiceProvider;
  BuildContext context;
  TextEditingController nameController;
  FToast fToast = FToast();
  File? image;
  AboutMeVm({
    required this.context,
    required this.apiServiceProvider,
    TextEditingController? nameController,
  }) : nameController = TextEditingController(
         text: apiServiceProvider.sessionManager.getName(),
       );

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void initialize() {
    fToast.init(context);
  }

  List<ApplicationReason> selectedApplicationReasons = [];
  TextEditingController roleController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController fieldController = TextEditingController();
  TextEditingController educationLevelController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController othersController = TextEditingController();

  void formChangeHandler() {
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    schoolNameController.dispose();
    fieldController.dispose();
    educationLevelController.dispose();
    aboutController.dispose();
    othersController.dispose();
    super.dispose();
  }

  updateImage(File image) {
    this.image = image;
    notifyListeners();
  }

  void uploadPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (isNotNull(pickedImage)) {
      updateImage(File(pickedImage!.path));
    } else {
      fToast.showToast(
        child: MessageDisplayContainer('No image selected'),
        gravity: AppConstants.toastGravity,
        toastDuration: AppConstants.toastDuration,
      );
    }
  }

  void selectApplicationReason(ApplicationReason reason) {
    if (selectedApplicationReasons.contains(reason)) {
      selectedApplicationReasons.remove(reason);
    } else {
      selectedApplicationReasons.add(reason);
    }
    notifyListeners();
  }

  void skipHandler() {
    goToDashboard();
  }

  void goToDashboard() {
    NavigationHelper.pushAndRemoveUntil(Routes.dashboard);
  }

  void saveHandler() async {
    if (selectedApplicationReasons.isEmpty) {
      fToast.showToast(
        child: MessageDisplayContainer(
          'Please select a reason for using ${AppStrings.appName}',
        ),
        gravity: AppConstants.toastGravity,
        toastDuration: AppConstants.toastDuration,
      );
      return;
    }
    try {
      updateIsLoading(true);
      Map<String, dynamic> body = {
        "name": nameController.text,
        "iam": roleController.text,
      };
      if (aboutController.text.isNotEmpty) {
        body['about'] = aboutController.text;
      }
      if (othersController.text.isNotEmpty) {
        body['for_other'] = othersController.text;
      }
      if (schoolNameController.text.isNotEmpty) {
        body['school_name'] = schoolNameController.text;
      }
      if (fieldController.text.isNotEmpty) {
        body['school_field'] = fieldController.text;
      }
      if (educationLevelController.text.isNotEmpty) {
        body['school_level'] = educationLevelController.text;
      }
      for (var reason in selectedApplicationReasons) {
        switch (reason) {
          case ApplicationReason.studyingForExams:
            body['for_exam'] = true;
            break;
          case ApplicationReason.projectPlanning:
            body['for_project'] = true;
            break;
          case ApplicationReason.researchOrganization:
            body['for_research'] = true;
            break;
          case ApplicationReason.creativeBrainstorming:
            body['for_brainstorming'] = true;
            break;
          case ApplicationReason.courseNotes:
            body['for_course_note'] = true;
            break;
          case ApplicationReason.other:
        }
      }

      final request = JsonRequest.post(ApiEndpoints.profile, body);
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );

      if (isNotNull(image)) {
        try {
          final imageBody = FormDataRequest.post(ApiEndpoints.profileImage, {
            'profile_picture': image!,
          });
          final imageResponse = await apiServiceProvider.apiService
              .sendFormDataRequest(imageBody);
          completeSignInAndRouteOut(
            response: imageResponse,
            apiServiceProvider: apiServiceProvider,
          );
          return;
        } catch (err) {
          fToast.showToast(
            child: MessageDisplayContainer(
              'Could not upload Image. Kindly try again later',
            ),
            gravity: AppConstants.toastGravity,
            toastDuration: AppConstants.toastDuration,
          );
        }
      }
      completeSignInAndRouteOut(
        response: response,
        apiServiceProvider: apiServiceProvider,
      );
    } catch (err) {
      fToast.showToast(
        child: MessageDisplayContainer('An Error occurred'),
        gravity: AppConstants.toastGravity,
        toastDuration: AppConstants.toastDuration,
      );
    }
    updateIsLoading(false);
  }
}
