import 'package:navinotes/packages.dart';

class SellerUploadVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Board board;
  final formKey = GlobalKey<FormState>();
  
  // Form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  List<String> tags = [];
  List<String> included = [];
  String targetAudience = "";

  var categories = [
    'Science',
    'Arts & Humanities',
    'Social Sciences',
    'Engineering',
    'Business & Economics',
    'Medical & Health Sciences',
    'Technology & Computing',
    'Law',
    'Education',
    'Languages',
    'Other',
  ];

  var subCategories = <String>[];

  void loadSubCategories(String category) {
    debugPrint('loadSubCategories category: $category');
    if (category == '') {
      subCategories = [];
      notifyListeners();
      return;
    }

    switch (category) {
      case 'Science':
        subCategories = [
          'Physics',
          'Chemistry',
          'Biology',
          'Mathematics',
          'Environmental Science',
        ];
        break;
      case 'Arts & Humanities':
        subCategories = [
          'History',
          'Philosophy',
          'Literature',
          'Theology',
          'Visual Arts',
        ];
        break;
      case 'Social Sciences':
        subCategories = [
          'Sociology',
          'Psychology',
          'Political Science',
          'Anthropology',
          'Geography',
        ];
        break;
      case 'Engineering':
        subCategories = [
          'Mechanical Engineering',
          'Civil Engineering',
          'Electrical Engineering',
          'Computer Engineering',
          'Chemical Engineering',
        ];
        break;
      case 'Business & Economics':
        subCategories = [
          'Accounting',
          'Finance',
          'Marketing',
          'Economics',
          'Entrepreneurship',
        ];
        break;
      case 'Medical & Health Sciences':
        subCategories = [
          'Nursing',
          'Medicine',
          'Pharmacy',
          'Public Health',
          'Anatomy',
        ];
        break;
      case 'Technology & Computing':
        subCategories = [
          'Computer Science',
          'Information Technology',
          'Software Engineering',
          'Data Science',
          'Cybersecurity',
        ];
        break;
      case 'Law':
        subCategories = [
          'Criminal Law',
          'Civil Law',
          'International Law',
          'Constitutional Law',
          'Corporate Law',
        ];
        break;
      case 'Education':
        subCategories = [
          'Curriculum Studies',
          'Educational Psychology',
          'Early Childhood Education',
          'Guidance and Counselling',
          'Educational Administration',
        ];
        break;
      case 'Languages':
        subCategories = [
          'English Language',
          'French',
          'Spanish',
          'German',
          'Linguistics',
        ];
        break;
      default:
        subCategories = ['Other'];
    }

    notifyListeners();
  }

  
  SellerUploadVm({
    required this.scaffoldKey,
    required this.board,
  });

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
  
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }
  
  // Validation methods
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
  
  String? validateTags(String? value) {
    if (tags.isEmpty) {
      return 'Please add at least one tag';
    }
    return null;
  }
  
  void addTag(String tag) {
    if (tag.isEmpty) {
      tags.add('tag');
    }else if (!tags.contains(tag)) {
      tags.add(tag);
    }
    notifyListeners();
  }
  
  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }


  void includedClicked(String value, bool checked){
    debugPrint('includedClicked value: $value, checked: $checked');
    if (checked) {
      addIncluded(value);
    } else {
      removeIncluded(value);
    }
  }

  void addIncluded(String value) {
    debugPrint('addIncluded value: $value');
    if (value.isEmpty) {
      included.add(value);
    }else if (!included.contains(value)) {
      included.add(value);
    }
    notifyListeners();
  }

  void removeIncluded(String value) {
    debugPrint('removeIncluded value: $value');
    included.remove(value);
    notifyListeners();
  }

  setTargetAudience(String value) {
    targetAudience = value;
    notifyListeners();
  }
}
