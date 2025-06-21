import 'package:flutter/material.dart';
import 'package:navinotes/screens/aboutMe/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class AboutMeForm extends StatelessWidget {
  const AboutMeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AboutMeVm>(
      builder: (context, vm, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            spacing: 50,
            children: [
              CustomCard(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 30,
                    children: [_header(), _mainForm(vm)],
                  ),
                ),
              ),
              _footer(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _footer(AboutMeVm vm) {
    EdgeInsets padding = EdgeInsets.symmetric(vertical: 12, horizontal: 20);
    return Column(
      spacing: 15,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 15,
          children: [
            AppButton(
              onTap: vm.skipHandler,
              text: 'Skip for Now',
              wrapWithFlexible: true,
              mainAxisSize: MainAxisSize.min,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Apptheme.coolGray, width: 2),
              ),
              color: Apptheme.white,
              textColor: Apptheme.darkSlateGray,
              padding: padding,
            ),
            AppButton(
              onTap: vm.saveHandler,
              text: 'Save & Continue',
              wrapWithFlexible: true,
              mainAxisSize: MainAxisSize.min,
              padding: padding,
              color: Apptheme.jungleGreen,
            ),
          ],
        ),
        Text(
          'You can update your profile anytime in Settings',
          textAlign: TextAlign.center,
          style: Apptheme.text.copyWith(color: Apptheme.steelMist),
        ),
      ],
    );
  }

  Widget _mainForm(AboutMeVm vm) {
    TextStyle hintStyle = Apptheme.text.copyWith(
      color: Apptheme.slateGray,
      fontSize: 16.0,
      height: 1.50,
    );
    TextStyle labelStyle = Apptheme.text.copyWith(
      color: Apptheme.vividRose,
      fontSize: 16.0,
      fontWeight: getFontWeight(500),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        CustomInputField(hintText: 'Jane Smith', label: 'Name', required: true),
        CustomInputField(
          hintText: 'Select your role',
          label: 'I am a...',
          required: true,
          selectItems: ['Student', 'Teacher', 'Parent'],
        ),
        Container(
          decoration: ShapeDecoration(
            color: Apptheme.azura,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Apptheme.mintLight),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            spacing: 15,
            children: [
              CustomInputField(
                hintText: 'Enter your school or university',
                label: 'School/University name',
                optional: true,
                labelStyle: labelStyle,
                hintStyle: hintStyle,
              ),
              CustomInputField(
                hintText: 'E.g., Computer Science, Biology',
                label: 'Field of study/Major',
                hintStyle: hintStyle,
                optional: true,
                labelStyle: labelStyle,
              ),
              CustomInputField(
                hintText: 'Select your education level',
                label: 'Education level',
                optional: true,
                labelStyle: labelStyle,
                selectItems: ['High School', 'College', 'University'],
                hintStyle: Apptheme.text.copyWith(fontSize: 16.0),
              ),
            ],
          ),
        ),
        _multiSelect(vm),
        CustomInputField(
          hintText: 'Tell us a bit more about yourself...',
          label: 'About me',
          hintStyle: hintStyle,
          maxLines: 5,
          optional: true,
        ),
        _profileImage(),
      ],
    );
  }

  Widget _profileImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Header6(title: 'Profile picture', optional: true),
        Row(
          spacing: 15,
          children: [
            OutlinedChild(
              size: 80,
              decoration: BoxDecoration(
                color: Apptheme.pastelBloom,
                border: Border.all(color: Apptheme.skyFoam),
                shape: BoxShape.circle,
              ),
              child: SVGImagePlaceHolder(imagePath: Images.logo, size: 30),
            ),
            Flexible(
              child: Column(
                spacing: 4,
                children: [
                  AppButton.secondary(
                    onTap: () {},
                    text: 'Upload photo',
                    mainAxisSize: MainAxisSize.min,
                    minHeight: 42,
                    color: Apptheme.coolGray,
                    textColor: Apptheme.darkSlateGray,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.upload,
                      size: 16,
                    ),
                  ),
                  Text(
                    'PNG, JPG or GIF, max 5MB',
                    style: Apptheme.text.copyWith(
                      color: Apptheme.steelMist,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _multiSelect(AboutMeVm vm) {
    return Column(
      spacing: 7,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header6(title: 'I\'m using this app for...', required: true),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              applicationReasons.map((str) {
                bool isSelected = vm.selectedApplicationReasons.contains(str);
                return InkWell(
                  onTap: () => vm.selectApplicationReason(str),
                  child: Row(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color:
                            isSelected
                                ? Apptheme.strongBlue
                                : Apptheme.defaultBlack,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Text(
                                str,
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.darkSlateGray,
                                  fontSize: 16.0,
                                ),
                              ),
                              if (str == 'Other')
                                CustomInputField(
                                  hintText: 'Please specify',
                                  hintStyle: Apptheme.text.copyWith(
                                    color: Apptheme.slateGray,
                                    fontSize: 16.0,
                                    height: 1.50,
                                  ),
                                  fillColor: Apptheme.whisperGrey,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Tell Us About You',
          style: Apptheme.text.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Help us personalize your experience (you can skip or edit this later)',
          style: Apptheme.text.copyWith(
            color: Apptheme.stormGray,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
