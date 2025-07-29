import 'package:navinotes/packages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// define enum for screens
enum Screen { details, price, preview }

class SellerUploadVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Board board;
  final formKey = GlobalKey<FormState>();

  ApiServiceProvider apiServiceProvider;

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

final Map<String, List<String>> categoryMap = {
    'Medical & Health Professional Tests': [
      'MCAT (Medical College Admission Test)',
      'DAT (Dental Admission Test)',
      'PCAT (Pharmacy College Admission Test)',
      'OAT (Optometry Admission Test)',
      'VCAT (Veterinary College Admission Test)',
    ],
    'Law School Admission': ['LSAT (Law School Admission Test)'],
    'Graduate School Admission': [
      'GRE (Graduate Record Examination)',
      'GMAT (Graduate Management Admission Test)',
    ],
    'Undergraduate Admission': [
      'SAT (Scholastic Assessment Test)',
      'ACT (American College Testing)',
      'PSAT/NMSQT',
    ],
    'Professional Licensing & Certification': [
      'Bar Exam Preparation',
      'CPA Exam (Certified Public Accountant)',
      'FE Exam (Fundamentals of Engineering)',
      'NCLEX (National Council Licensure Examination)',
    ],
    'IT & Technology Certifications': [
      'CompTIA Certifications',
      'Cisco Certifications',
      'Microsoft Certifications',
      'AWS Certifications',
    ],
    'Project Management & Business': [
      'PMP (Project Management Professional)',
      'Six Sigma Certifications',
      'CFA (Chartered Financial Analyst)',
    ],
    'Advanced Placement (AP) Tests': [
      'STEM AP Exams',
      'Humanities AP Exams',
      'Language AP Exams',
    ],
    'International Tests': [
      'TOEFL (Test of English as a Foreign Language)',
      'IELTS (International English Language Testing System)',
      'GED (General Educational Development)',
    ],
    'Specialty Professional Tests': [
      'USMLE (United States Medical Licensing Examination)',
      'COMLEX (Comprehensive Osteopathic Medical Licensing Examination)',
      'Real Estate Licensing Exams',
    ],
    'Other': [
      'Other',
    ],
  };

  List<String> subCategories = [];

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;
  String? _validationError;
  String? get validationError => _validationError;

  // Price screen controllers
  final priceFormKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final customLicenseController = TextEditingController();
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

  List<String> getCategories() {
    return categoryMap.keys.toList();
  }

  void loadSubCategories(String category) {
    debugPrint('loadSubCategories category: $category');
    subCategories = categoryMap[category] ?? ['Other'];
    notifyListeners();
  }

  setScreen(Screen screen) {
    currentScreen = screen;
    notifyListeners();
  }

  SellerUploadVm({
    required this.scaffoldKey,
    required this.board,
    required this.apiServiceProvider,
  });

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
    if (isPublishing) {
      debugPrint('Already publishing');
      return;
    }

    isPublishing = true;
    publishingStatus = "Uploading Content...";
    debugPrint('publishingStatus: $publishingStatus');
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
      await uploadMarketPlace();
    } catch (e) {
      debugPrint('Error publishing marketplace: $e');
      isPublishing = false;
      publishingStatus = "Failed to publish marketplace";
      notifyListeners();
      return;
    }

    publishingStatus = "Product uploaded successfully. Redirecting...";
    notifyListeners();

    //delay
    await Future.delayed(const Duration(seconds: 2));
    isPublishing = false;
    notifyListeners();
    // navigate to marketplace
    NavigationHelper.pushReplacement(Routes.myStore);
  }

  uploadContent() async {
    debugPrint('board sync started');
    await board.syncToBackend(apiServiceProvider);

    debugPrint('board sync completed');

    // sync content
    board.getContents(forceRefresh: true).then((contents) {
      for (var content in contents) {
        content.syncToBackend(apiServiceProvider, boardGuid: board.guid);
      }
    });
  }

  getPriceCent() {
    int price = int.tryParse(priceController.text) ?? 0;
    return price * 100;
  }

  uploadMarketPlace() async {
    var previewFiles = [];
    for (var previewImage in previewImages) {
      final type = lookupMimeType(previewImage.path);
      final contentType = type != null ? MediaType.parse(type) : null;

      previewFiles.add(
        MultipartFile.fromFileSync(previewImage.path, contentType: contentType),
      );
    }

    // make a submit of the data.
    final body = FormDataRequest.post(
      ApiEndpoints.marketPlaceSubmit,
      body: {
        'board_guid': board.guid,
        'title': titleController.text,
        'description': descriptionController.text,
        'category': categoryController.text,
        'sub_category': subCategoryController.text,
        'tags[]': tags,
        'target_audience': targetAudience,
        'whats_included[]': included,
        'price': getPriceCent(),
        'discount_percent': discountController.text,
        'preview_images_files[]': previewFiles,
      },
      files: {'cover_image_file': coverImage!},
    );

    final response = await apiServiceProvider.apiService.sendFormDataRequest(
      body,
    );

    return response;
  }

  @override
  void dispose() {
    priceController.dispose();
    discountController.dispose();
    customLicenseController.dispose();
    super.dispose();
  }
}
