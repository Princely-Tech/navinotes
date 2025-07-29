class MarketItem {
  final int id;
  final String title;
  final String description;
  final String coverImagePath;
  final double price;
  // price is in cent
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
      rating:
          json['rating_count'] > 0
              ? (json['rating_sum'] / json['rating_count']).toDouble()
              : 0,
      ratingCount: json['rating_count'],
      tags: List<String>.from(json['tags'] ?? []),
      whatsIncluded: List<String>.from(json['whats_included'] ?? []),
    );
  }

  double getAmount() {
    // price is in cent
    return price / 100;
  }

  double getOriginalAmount() {
    double amount = price;
    // if there is discount, work the original amount backwards
    if (discountPercent != null && discountPercent! > 0) {
      amount = price * 100 / (100 - discountPercent!);
    }

    return amount / 100;
  }
}
