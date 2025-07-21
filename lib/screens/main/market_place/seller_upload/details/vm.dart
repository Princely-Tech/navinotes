import 'package:navinotes/packages.dart';
import 'package:image_picker/image_picker.dart';

// define enum for screens
enum Screen { details, price, preview }

class SellerUploadVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Board board;
  final formKey = GlobalKey<FormState>();

  Screen currentScreen = Screen.details;

  // Form fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  List<String> tags = [];
  List<String> included = [];
  String targetAudience = "";
  File? coverImage;
  List<File> previewImages = [];
  static const int maxPreviewImages = 3;

  notifyChange() {
    notifyListeners();
  }

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

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;
  String? _validationError;
  String? get validationError => _validationError;

  // Price screen controllers
  final priceFormKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final customLicenseController = TextEditingController();
  String selectedCurrency = 'NGN';
  String selectedLicense = 'Standard';
  bool agreeToTerms = false;
  bool agreeToRefundPolicy = false;
  bool agreeToCopyrightPolicy = false;

  double get price => double.tryParse(priceController.text) ?? 0;
  int get discount => int.tryParse(discountController.text) ?? 0;

  var isPublishing = false;
  var publishingStatus = "";



  String? get originalPrice {
    if (discount > 0 && price > 0) {
      return (price * 100 / (100 - discount)).toStringAsFixed(2);
    }
    return null;
  }

  setScreen(Screen screen) {
    currentScreen = screen;
    notifyListeners();
  }

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

  SellerUploadVm({required this.scaffoldKey, required this.board});

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  bool validateForm() {
    _validationError = null;

    if (titleController.text.isEmpty) {
      _validationError = 'Product title is required';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (categoryController.text.isEmpty) {
      _validationError = 'Category is required';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (subCategoryController.text.isEmpty) {
      _validationError = 'Sub-category is required';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (coverImage == null) {
      _validationError = 'Cover image is required';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (previewImages.isEmpty) {
      _validationError = 'At least one preview image is required';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (descriptionController.text.isEmpty) {
      _validationError = 'Description is required';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (targetAudience.isEmpty) {
      _validationError = 'Please select target audience';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    if (included.isEmpty) {
      _validationError = 'Please select what\'s included';
      _isFormValid = false;
      notifyListeners();
      return false;
    }

    _validationError = null;
    _isFormValid = true;
    setScreen(Screen.price);
    notifyListeners();
    return true;
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
    } else if (!tags.contains(tag)) {
      tags.add(tag);
    }
    notifyListeners();
  }

  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }

  Future<void> pickCoverImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        coverImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking cover image: $e');
    }
  }

  Future<void> addPreviewImage() async {
    try {
      if (previewImages.length >= maxPreviewImages) return;

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        previewImages.add(File(image.path));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking preview image: $e');
    }
  }

  void removePreviewImage(int index) {
    if (index >= 0 && index < previewImages.length) {
      previewImages.removeAt(index);
      notifyListeners();
    }
  }

  void includedClicked(String value, bool checked) {
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
    } else if (!included.contains(value)) {
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

  // Price screen methods
  void setCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  void setLicenseType(String license) {
    selectedLicense = license;
    notifyListeners();
  }

  void setAgreeToTerms(bool value) {
    agreeToTerms = value;
    notifyListeners();
  }

  void setAgreeToRefundPolicy(bool value) {
    agreeToRefundPolicy = value;
    notifyListeners();
  }

  void setAgreeToCopyrightPolicy(bool value) {
    agreeToCopyrightPolicy = value;
    notifyListeners();
  }

  bool validatePriceForm() {
    _validationError = null;
    if (priceFormKey.currentState?.validate() != true) {
      return false;
    }

    if (!agreeToTerms || !agreeToRefundPolicy || !agreeToCopyrightPolicy) {
      _validationError = 'Please agree to all terms and conditions';
      return false;
    }

    return true;
  }

  publish() async {
    isPublishing = true;
    publishingStatus = "Uploading Content...";
    notifyListeners();
    
    try {
      await uploadContent();
    } catch (e) {
      debugPrint('Error uploading content: $e');
      isPublishing = false;
      publishingStatus = "Failed to upload content";
      notifyListeners();
      return;
    }

    publishingStatus = "Publishing Product Details...";
    notifyListeners();
    try {
      await publishMarketPlace();
    } catch (e) {
      debugPrint('Error publishing marketplace: $e');
      isPublishing = false;
      publishingStatus = "Failed to publish marketplace";
      notifyListeners();
      return;
    }

    publishingStatus = "Product uploaded successfully";
    isPublishing = false;
    notifyListeners();
  }

uploadContent() async {
  // TODO later
}

publishMarketPlace() async {
  // make a submit of the data.
  
}


  @override
  void dispose() {
    priceController.dispose();
    discountController.dispose();
    customLicenseController.dispose();
    super.dispose();
  }
}
