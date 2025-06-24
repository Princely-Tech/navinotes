import 'package:navinotes/packages.dart';
import 'vm.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: AppTheme.white,
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return ChangeNotifierProvider(
              create:
                  (context) => VerifyVM(
                    context: context,
                    apiServiceProvider: apiServiceProvider,
                  ),
              child: Consumer<VerifyVM>(
                builder: (_, vm, _) {
                  return AbsorbPointer(
                    absorbing: vm.isLoading,
                    child: AuthFrame(
                      child: Column(
                        spacing: 30,
                        children: [AuthHeader(), _authCard(vm)],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _authCard(VerifyVM vm) {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return ShadowCard(
          child: Column(
            spacing: 25,
            children: [
              HeaderSectionTwo(
                title: 'Verify your email',
                body:
                    'Enter the email sent to ${apiServiceProvider.sessionManager.getEmail()}',
              ),
              VerifyFormComponent(
                isLoading: vm.isLoading,
                submitHandler: (input) => vm.submitForm(input),
                resendOtpHandler: vm.resendOtp,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _continueWith() {
    return Row(
      spacing: 5,
      children: [
        _divider(),
        Text(
          'or continue with',
          style: AppTheme.text.copyWith(
            color: AppTheme.steelMist,
            fontFamily: AppTheme.fontPoppins,
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _divider() {
    return Expanded(
      child: Divider(color: AppTheme.lightGray, thickness: 1, height: 1),
    );
  }
}

// class VerifyBody extends StatelessWidget {
//   VerifyBody({super.key});
//   final formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
    
//     final vm = Provider.of<VerifyVM>(context);
//     final apiServiceProvider = Provider.of<ApiServiceProvider>(context);
//     return ScaffoldFrame(
//       backgroundColor: AppTheme.white,
//       body: AbsorbPointer(
//         absorbing: vm.isLoading,
//         child: Column(
//           spacing: 20,
//           children: [
//             AppHeaderOne(title: 'Verify email'),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
              // child: 
//           ],
//         ),
//       ),
//     );
//   }

  
// }

// class VerifyScreen extends StatelessWidget {
//   const VerifyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ApiServiceComponent(
//       child: Consumer<ApiServiceProvider>(
//         builder: (_, apiServiceProvider, __) {
//           return ChangeNotifierProvider(
//             create: (_) => VerifyVM(apiServiceProvider: apiServiceProvider),
//             child: VerifyBody(),
//           );
//         },
//       ),
//     );
//   }
// }
