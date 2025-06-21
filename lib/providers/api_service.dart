import 'package:navinotes/packages.dart';

class ApiServiceProvider extends ChangeNotifier {
  final SessionManager sessionManager;
  late RestNetworkService apiService;
  BuildContext context;
  ApiServiceProvider({required this.sessionManager, required this.context})
    : apiService = DioNetworkService(
        context: context,
        sessionManager: sessionManager,
        baseUrl: EnvironmentConfig.apiUrl,
        apiVersion: EnvironmentConfig.apiVersion,
        sendTimeout: Duration(seconds: 30),
        isProd: EnvironmentConfig.isProd,
      );
}
