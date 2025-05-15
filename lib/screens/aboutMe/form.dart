import 'package:flutter/material.dart';

class AboutMeForm extends StatelessWidget {
  const AboutMeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 25,
        children: [
          Column(
            spacing: 15,
            children: [
              Text(
                'Tell Us About You',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              Text(
                'Help us personalize your experience (you can skip or edit this later)',
                style: TextStyle(
                  color: const Color(0xFF4B5563),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              //
            ],
          ),
        ],
      ),
    );
  }
}
