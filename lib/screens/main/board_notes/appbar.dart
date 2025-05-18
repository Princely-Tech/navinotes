import 'package:flutter/material.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/inputs.dart';

class BoardNotesAppBar extends StatelessWidget {
  const BoardNotesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Apptheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        spacing: 20,
        children: [
          _leading(),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: WidthLimiter(
                mobile: 512,
                child: CustomInputField(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Apptheme.slateGray,
                    size: 20,
                  ),
                  hintText: 'Search in this board',
                  fillColor: Apptheme.lightAsh,
                  hintStyle: TextStyle(
                    color: const Color(0xFFADAEBC),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ),
            ),
          ),
          _actions(),
        ],
      ),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        //
      ],
    );
  }

  Widget _leading() {
    return Flexible(
      child: Row(
        spacing: 10,
        children: [
          Icon(Icons.arrow_back, size: 24, color: Apptheme.strongBlue),
          OutlinedChild(
            decoration: BoxDecoration(color: Apptheme.paleBlue),
            child: Text(
              'N',
              style: TextStyle(
                color: const Color(0xFF1D4ED8),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.appName,
                    style: TextStyle(
                      color: const Color(0xFF1E40AF),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                  TextSpan(
                    text: '  /  ',
                    style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                  TextSpan(
                    text: 'Physics 101',
                    style: TextStyle(
                      color: const Color(0xFF374151),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
