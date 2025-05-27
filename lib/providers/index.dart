import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:provider/provider.dart';

class CustomProviders extends StatelessWidget {
  const CustomProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => LayoutProviderVm(
                deviceType: getDeviceType(screenWidth(context)),
                context: context,
              ),
        ),
      ],
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<LayoutProviderVm>().updateDeviceType();
            // context.read<LayoutProviderVm>().updateDeviceType(context);
          });
          return child;
        },
      ),
    );
  }
}
