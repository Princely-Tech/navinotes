import 'package:navinotes/packages.dart';

class EnvironmentConfig {
  static const isProd = false;
  static String apiUrl = dotenv.env['BASE_URL']!;
  static const apiVersion = 'api/v1';
}
