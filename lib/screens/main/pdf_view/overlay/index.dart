import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/index.dart';

class PdfViewOverlay extends StatefulWidget {
  const PdfViewOverlay({super.key});

  @override
  State<PdfViewOverlay> createState() => _PdfViewOverlayState();
}

class _PdfViewOverlayState extends State<PdfViewOverlay> {
  bool _showOverlay = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _showOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showOverlay)
            Container(
              decoration: ShapeDecoration(
                color: Apptheme.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Apptheme.pastelBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 50,
                    offset: Offset(0, 25),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            //
                          ],
                        ),
                      ),
                      Icon(Icons.close),
                    ],
                  ),
                  //
                ],
              ).animate().fadeIn().scale(duration: 1.seconds),
            ),
        ],
      ),
    );
  }
}
