import 'package:navinotes/models/markeplace_item.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/widgets/empty_state.dart';
import 'main.dart';
import 'appbar.dart';
import 'aside.dart';
import 'vm.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! MarketItem) {
      return Scaffold(
        body: Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'Product Not Found',
            subtitle: 'The requested product could not be found.',
            footer: AppButton(
              text: 'Go Back',
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
      );
    }

    final product = args as MarketItem;

    return ApiServiceComponent(
      child: Consumer<ApiServiceProvider>(
        builder: (_, apiServiceProvider, __) {
          return ChangeNotifierProvider(
            create:
                (context) => ProductDetailVm(
                  scaffoldKey: _scaffoldKey,
                  product: product,

                apiServiceProvider: apiServiceProvider,
                  context: context,
                ),
            child: Consumer<ProductDetailVm>(
              builder: (context, vm, _) {
                return ScaffoldFrame(
                  scaffoldKey: _scaffoldKey,
                  // endDrawer: CustomDrawer(
                  //   bgColor: AppTheme.whiteSmoke,
                  //   child: ProductDetailAside(),
                  // ),
                  backgroundColor: AppTheme.whiteSmoke,
                  body: Column(
                    children: [
                      ProductDetailAppBar(),
                      Expanded(
                        child: ResponsiveSection(
                          mobile: ProductDetailMain(vm: vm),
                          desktop: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: ProductDetailMain(vm: vm)),
                              // WidthLimiter(
                              //   mobile: 400,
                              //   child: ProductDetailAside(),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
