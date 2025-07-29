import 'package:navinotes/packages.dart';

class MarketItem {
  final int id;
  final String title;
  final String description;
  final String coverImagePath;
  final double price;
  final double? discountPercent;
  final String author;
  final double rating;
  final int ratingCount;
  final List<String> tags;
  final List<String> whatsIncluded;

  MarketItem({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImagePath,
    required this.price,
    this.discountPercent,
    required this.author,
    this.rating = 0,
    this.ratingCount = 0,
    this.tags = const [],
    this.whatsIncluded = const [],
  });

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      coverImagePath: json['cover_image_path'],
      price: (json['price'] as num).toDouble(),
      discountPercent: json['discount_percent']?.toDouble(),
      author: json['user']?['name'] ?? 'Unknown',
      rating: json['rating_count'] > 0 
          ? (json['rating_sum'] / json['rating_count']).toDouble() 
          : 0,
      ratingCount: json['rating_count'],
      tags: List<String>.from(json['tags'] ?? []),
      whatsIncluded: List<String>.from(json['whats_included'] ?? []),
    );
  }
}

class MarketPlaceVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  ApiServiceProvider apiServiceProvider;
  
  bool _isLoading = false;
  List<MarketItem> _items = [];
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

  MarketPlaceVm({required this.scaffoldKey, required this.apiServiceProvider});

  Future<void> loadMarketplaceItems({int page = 1}) async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      if (page == 1) _items.clear();
      

      final request = JsonRequest.get(
        '/marketplace',
        queryParams: {
          'page': page.toString(),
          'per_page': _perPage.toString(),
        },
      );
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      
      final data = response;
      _currentPage = data['current_page'];
      _totalPages = data['last_page'];
      _totalItems = data['total'];

      final newItems =
          (data['data'] as List)
              .map((item) => MarketItem.fromJson(item))
              .toList();

      _items.addAll(newItems);
    } catch (e) {
      debugPrint('Error loading marketplace items: $e');
      // Handle error (e.g., show error message)
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (_currentPage < _totalPages) {
      await loadMarketplaceItems(page: _currentPage + 1);
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void goToProductDetail() {
    NavigationHelper.push(Routes.productDetail);
  }
}
