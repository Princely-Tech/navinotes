import 'package:navinotes/packages.dart';
import 'vm.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: Apptheme.white,
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return ChangeNotifierProvider(
              create:
                  (context) => VerifyVM(apiServiceProvider: apiServiceProvider),
              child: Consumer<VerifyVM>(
                builder: (_, vm, _) {
                  return _main(vm);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _main(VerifyVM vm) {
    return Builder(
      builder: (context) {
        return AbsorbPointer(
          absorbing: vm.isLoading,
          child: Column(
            children: [
              //
            ],
          ),
        );
      },
    );
  }
}
