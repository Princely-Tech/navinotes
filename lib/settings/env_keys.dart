import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get syncfusionKey => dotenv.env['SyncfusionKey']!;
}
