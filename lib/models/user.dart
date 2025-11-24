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
  String? profilePicture;

  // Email Preferences
  bool emailMarketing;
  bool emailProductUpdates;
  bool emailMarketplaceNotifications;

  // Push Notification Preferences
  bool pushPomodoroAlerts;
  bool pushFlashcardReminders;
  bool pushMarketplacePurchaseConfirmations;
  bool pushMarketplaceSaleNotifications;
  bool pushFeatureAnnouncements;

  // Usage Purpose
  bool forExam;
  bool forProject;
  bool forResearch;
  bool forBrainstorming;
  bool forCourseNote;
  String? forOther;

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
    this.profilePicture,
    this.emailMarketing = true,
    this.emailProductUpdates = true,
    this.emailMarketplaceNotifications = true,
    this.pushPomodoroAlerts = true,
    this.pushFlashcardReminders = true,
    this.pushMarketplacePurchaseConfirmations = true,
    this.pushMarketplaceSaleNotifications = true,
    this.pushFeatureAnnouncements = true,
    this.forExam = false,
    this.forProject = false,
    this.forResearch = false,
    this.forBrainstorming = false,
    this.forCourseNote = false,
    this.forOther,
  });

  static bool _parseBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return defaultValue;
  }

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
      profilePicture: json['profile_picture'],
      emailMarketing: _parseBool(json['email_marketing'], defaultValue: true),
      emailProductUpdates: _parseBool(
        json['email_product_updates'],
        defaultValue: true,
      ),
      emailMarketplaceNotifications: _parseBool(
        json['email_marketplace_notifications'],
        defaultValue: true,
      ),
      pushPomodoroAlerts: _parseBool(
        json['push_pomodoro_alerts'],
        defaultValue: true,
      ),
      pushFlashcardReminders: _parseBool(
        json['push_flashcard_reminders'],
        defaultValue: true,
      ),
      pushMarketplacePurchaseConfirmations: _parseBool(
        json['push_marketplace_purchase_confirmations'],
        defaultValue: true,
      ),
      pushMarketplaceSaleNotifications: _parseBool(
        json['push_marketplace_sale_notifications'],
        defaultValue: true,
      ),
      pushFeatureAnnouncements: _parseBool(
        json['push_feature_announcements'],
        defaultValue: true,
      ),
      forExam: _parseBool(json['for_exam']),
      forProject: _parseBool(json['for_project']),
      forResearch: _parseBool(json['for_research']),
      forBrainstorming: _parseBool(json['for_brainstorming']),
      forCourseNote: _parseBool(json['for_course_note']),
      forOther: json['for_other'],
    );
  }

  updateEmail(String email) {
    this.email = email;
  }

  updateOtp(String otp) {
    otp = otp;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'api_key': apiKey,
      'otp_secret': otpSecret,
      'token_secret': tokenSecret,
      'referred_by': referredBy,
      'referral_code': referralCode,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'email_verified_at': emailVerifiedAt,
      'iam': iam,
      'about': about,
      'school_name': schoolName,
      'school_field': schoolField,
      'school_level': schoolLevel,
      'otp': otp,
      'profile_picture': profilePicture,
      'email_marketing': emailMarketing,
      'email_product_updates': emailProductUpdates,
      'email_marketplace_notifications': emailMarketplaceNotifications,
      'push_pomodoro_alerts': pushPomodoroAlerts,
      'push_flashcard_reminders': pushFlashcardReminders,
      'push_marketplace_purchase_confirmations':
          pushMarketplacePurchaseConfirmations,
      'push_marketplace_sale_notifications': pushMarketplaceSaleNotifications,
      'push_feature_announcements': pushFeatureAnnouncements,
      'for_exam': forExam,
      'for_project': forProject,
      'for_research': forResearch,
      'for_brainstorming': forBrainstorming,
      'for_course_note': forCourseNote,
      'for_other': forOther,
    };
  }
}
