class User {
  String name;
  String email;
  String? country;
  double? latitude;
  double? longitude;
  String? apiKey;
  String? otpSecret;
  String? tokenSecret;
  String? referredBy;
  String? referralCode;
  String updatedAt;
  String createdAt;
  String? iam;
  int? id;
  String? emailVerifiedAt;
  String? about;
  String? schoolName;
  String? schoolField;
  String? schoolLevel;
  String? otp;

  User({
    required this.name,
    required this.email,
    required this.country,
    this.otp,
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

  updateEmail(String email) {
    this.email = email;
  }

  updateOtp(String otp) {
    otp = otp;
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
