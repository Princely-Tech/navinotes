import 'package:navinotes/packages.dart';

class ChooseBoardWrapper extends StatelessWidget {
  const ChooseBoardWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, __) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.error != null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(vm.error!)),
          );
        }

        if (vm.board == null) {
          return const Scaffold(
            body: Center(child: Text('No board data available')),
          );
        }

        // Main content
        return child;
      },
    );
  }
}
