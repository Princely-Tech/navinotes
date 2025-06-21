class User {
  final String name;
  final String email;
  final String? country;
  // final String? countryCode;
  final double? latitude;
  final double? longitude;
  final String? apiKey;
  final String? otpSecret;
  final String? tokenSecret;
  final String? referredBy;
  final String? referralCode;
  final String updatedAt;
  final String createdAt;
  final String? iam;
  final int? id;
  final String? emailVerifiedAt;
  final String? about;
  final String? schoolName;
  final String? schoolField;
  final String? schoolLevel;

  User({
    required this.name,
    required this.email,
    this.country,
    required this.emailVerifiedAt,
    required this.iam,
    required this.about,
    required this.schoolName,
    required this.schoolField,
    required this.schoolLevel,
    required this.latitude,
    required this.longitude,
    required this.apiKey,
    required this.otpSecret,
    required this.tokenSecret,
    this.referredBy,
    required this.referralCode,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      iam: json['iam'],
      about: json['about'],
      schoolName: json['school_name'],
      schoolField: json['school_field'],
      schoolLevel: json['school_level'],
      name: json['name'],
      email: json['email'],
      country: json['country'],
      emailVerifiedAt: json['email_verified_at'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      // latitude: (json['latitude'] as num).toDouble(),
      // longitude: (json['longitude'] as num).toDouble(),
      apiKey: json['api_key'],
      otpSecret: json['otp_secret'],
      tokenSecret: json['token_secret'],
      referredBy: json['referred_by'],
      referralCode: json['referral_code'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'email': email,
  //     // 'country': country,
  //     // 'country_code': countryCode,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //     'api_key': apiKey,
  //     'otp_secret': otpSecret,
  //     'token_secret': tokenSecret,
  //     'referred_by': referredBy,
  //     'referral_code': referralCode,
  //     'updated_at': updatedAt.toIso8601String(),
  //     'created_at': createdAt.toIso8601String(),
  //     'id': id,
  //   };
  // }
}
