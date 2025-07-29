

final Map<String, List<String>> marketPlaceCategoryMap = {
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
  'Other': ['Other'],
};



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
