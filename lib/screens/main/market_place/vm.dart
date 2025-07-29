import 'package:navinotes/models/markeplace_item.dart';
import 'package:navinotes/packages.dart';


class MarketPlaceVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  ApiServiceProvider apiServiceProvider;
  FToast fToast = FToast();
  BuildContext context;


  MarketPlaceVm({
    required this.scaffoldKey,
    required this.apiServiceProvider,
    required this.context,
  });

  bool _isLoading = false;
  List<MarketItem> _items = [];
  bool _hasLoadedItems = false; // prevents widget from always loading data on every build
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _perPage = 10;

  bool get isLoading => _isLoading;
  List<MarketItem> get items => _items;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  int get perPage => _perPage;
  bool get hasMorePages => _currentPage < _totalPages;

  List<MarketItem> _featuredItems = [];
  List<MarketItem> get featuredItems => _featuredItems;
  bool _isLoadingFeatured = false;
  bool get isLoadingFeatured => _isLoadingFeatured;

String _searchQuery = '';
  String get searchQuery => _searchQuery;


    bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

 PageDisplayFormat _displayFormat = PageDisplayFormat.grid;
  PageDisplayFormat get displayFormat => _displayFormat;


  void initialize() {
    fToast.init(context);
  }

void toggleDisplayFormat() {
    _displayFormat = _displayFormat == PageDisplayFormat.grid 
        ? PageDisplayFormat.list 
        : PageDisplayFormat.grid;
    notifyListeners();
  }

  Future<void> loadFeaturedItems() async {
    if (_isLoadingFeatured) return;

    try {
      _isLoadingFeatured = true;
      notifyListeners();

      final request = JsonRequest.get('/marketplace/recommended');
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      if (response['data'] is List) {
        _featuredItems =
            (response['data'] as List)
                .map((item) => MarketItem.fromJson(item))
                .toList();
      }
    } catch (e) {
      debugPrint('Error loading featured items: $e');
    } finally {
      _isLoadingFeatured = false;
      notifyListeners();
    }
  }

  // Future<void> loadMarketplaceItems({int page = 1, String? query}) async {
  //   if (_isLoading) return;

  //   try {
  //     _isLoading = true;
  //     _hasError = false;
  //     _errorMessage = null;
  //     notifyListeners();

  //     if (page == 1) _items.clear();

  //     if (query != null) _searchQuery = query;

  //     final request = JsonRequest.get(
  //       '/marketplace',
  //       queryParams: {
  //         'page': page.toString(), 'per_page': _perPage.toString(),
  //         if (_searchQuery.isNotEmpty) 'search': _searchQuery,

  //       },
  //     );
  //     final response = await apiServiceProvider.apiService.sendJsonRequest(
  //       request,
  //     );

  //     final data = response;
  //     _currentPage = data['current_page'];
  //     _totalPages = data['last_page'];
  //     _totalItems = data['total'];

  //     final newItems =
  //         (data['data'] as List)
  //             .map((item) => MarketItem.fromJson(item))
  //             .toList();

  //     _items.addAll(newItems);
  //   } catch (e) {

  //     debugPrint('Error loading marketplace items: $e');
  //     // check if error is instance of NetworkException
  //     if (e is NetworkException) {
  //       _hasError = true;
  //       _errorMessage = 'Failed to load items. Please check your connection.';
  //     } else {
  //       _hasError = true;
  //       _errorMessage = 'Failed to load items. Please try again later.';
  //     }
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

bool get shouldLoadData => !isLoading && !_hasLoadedItems && !hasError && !isLoadingFeatured;


Future<void> loadMarketplaceItems({int page = 1, String? query}) async {
  if (_isLoading) return;

 
  try {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    _hasLoadedItems = true;

      // clear items
      _items.clear();
    notifyListeners();

    if (page == 1) _items.clear();
    if (query != null) _searchQuery = query;

    final params = <String, String>{
      'page': page.toString(),
      'per_page': _perPage.toString(),
      if (_searchQuery.isNotEmpty) 'search': _searchQuery,
      if (_selectedCategory != null) 'category': _selectedCategory!,
      if (_selectedSubCategory != null) 'sub_category': _selectedSubCategory!,
      if (_minPrice != null) 'price_min': (_minPrice!*100).toStringAsFixed(2),
      if (_maxPrice != null) 'price_max': (_maxPrice!*100).toStringAsFixed(2),
      if (_minDiscount != null) 'discount_percent_min': _minDiscount!.toString(),
      if (_maxDiscount != null) 'discount_percent_max': _maxDiscount!.toString(),
    };

    // Add tags as separate parameters
    for (var i = 0; i < _selectedTags.length; i++) {
      params['tags[$i]'] = _selectedTags[i];
    }

    final request = JsonRequest.get('/marketplace', queryParams: params);
    final response = await apiServiceProvider.apiService.sendJsonRequest(request);
    
    final data = response;
    _currentPage = data['current_page'];
    _totalPages = data['last_page'];
    _totalItems = data['total'];

    final newItems = (data['data'] as List)
        .map((item) => MarketItem.fromJson(item))
        .toList();

    _items.addAll(newItems);
  } catch (e) {
    debugPrint('Error loading marketplace items: $e');
    _hasError = true;
    _errorMessage = e is NetworkException
        ? 'Failed to load items. Please check your connection.'
        : 'Failed to load items. Please try again later.';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
    loadMarketplaceItems(page: 1);
  }

  Future<void> loadNextPage() async {
    if (_currentPage < _totalPages) {
      await loadMarketplaceItems(page: _currentPage + 1);
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void goToProductDetail(MarketItem item) {
    NavigationHelper.push(Routes.productDetail, arguments: item);
  }

  void addToCart(MarketItem item) {
    // NavigationHelper.push(Routes.productDetail);
    fToast.showToast(
      child: MessageDisplayContainer('Item added to cart', isError: false),
      gravity: AppConstants.toastGravity,
      toastDuration: AppConstants.toastDuration,
    );
  }




  // Filter-related properties
  String? _selectedCategory;
  String? _selectedSubCategory;
  final List<String> _selectedTags = [];
  double? _minPrice;
  double? _maxPrice;
  int? _minDiscount;
  int? _maxDiscount;
  bool _showFilters = false;

  // Getters
  String? get selectedCategory => _selectedCategory;
  String? get selectedSubCategory => _selectedSubCategory;
  List<String> get selectedTags => List.unmodifiable(_selectedTags);
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  int? get minDiscount => _minDiscount;
  int? get maxDiscount => _maxDiscount;
  bool get showFilters => _showFilters;

  // Count active filters
  int get activeFilterCount =>
      [
        _selectedCategory,
        _selectedSubCategory,
        if (_selectedTags.isNotEmpty) _selectedTags,
        _minPrice,
        _maxPrice,
        _minDiscount,
        _maxDiscount,
      ].where((item) => item != null).length;



      void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    _selectedSubCategory = null; // Reset subcategory when category changes
    notifyListeners();
  }

  void setSubCategory(String? subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setDiscountRange(int? min, int? max) {
    _minDiscount = min;
    _maxDiscount = max;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedSubCategory = null;
    _selectedTags.clear();
    _minPrice = null;
    _maxPrice = null;
    _minDiscount = null;
    _maxDiscount = null;
    notifyListeners();
    //loadMarketplaceItems(page: 1);
  }
}
