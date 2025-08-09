import 'widget.dart';

import 'vm.dart';
import 'package:navinotes/packages.dart';

class AboutMeForm extends StatelessWidget {
  AboutMeForm({super.key});
  final formKey = GlobalKey<FormState>();
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
                  key: formKey,
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
    return Builder(
      builder: (context) {
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
                    side: BorderSide(color: AppTheme.coolGray, width: 2),
                  ),
                  color: AppTheme.white,
                  textColor: AppTheme.darkSlateGray,
                  padding: padding,
                ),
                AppButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      vm.saveHandler();
                    } else {
                      MessageDisplayService.showFormInValidError(context);
                    }
                  },
                  text: 'Save & Continue',
                  loading: vm.isLoading,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  padding: padding,
                  color: AppTheme.jungleGreen,
                ),
              ],
            ),
            Text(
              'You can update your profile anytime in Settings',
              textAlign: TextAlign.center,
              style: AppTheme.text.copyWith(color: AppTheme.steelMist),
            ),
          ],
        );
      },
    );
  }

  Widget _mainForm(AboutMeVm vm) {
    TextStyle hintStyle = AppTheme.text.copyWith(
      color: AppTheme.slateGray,
      fontSize: 16.0,
      height: 1.50,
    );
    TextStyle labelStyle = AppTheme.text.copyWith(
      color: AppTheme.vividRose,
      fontSize: 16.0,
      fontWeight: getFontWeight(500),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        CustomInputField(
          hintText: 'Jane Smith',
          label: 'Name',
          required: true,
          controller: vm.nameController,
          validator:
              (input) =>
                  noNullValidator(value: input, message: 'Enter your name'),
        ),
        CustomInputField(
          hintText: 'Select your role',
          label: 'I am a...',
          required: true,
          selectItems: ['Student', 'Teacher', 'Parent'],
          validator:
              (input) =>
                  noNullValidator(value: input, message: 'Select your role'),
          controller: vm.roleController,
        ),
        Container(
          decoration: ShapeDecoration(
            color: AppTheme.azura,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppTheme.mintLight),
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
                controller: vm.schoolNameController,
              ),
              CustomInputField(
                hintText: 'E.g., Computer Science, Biology',
                label: 'Field of study/Major',
                hintStyle: hintStyle,
                optional: true,
                labelStyle: labelStyle,
                controller: vm.fieldController,
              ),
              CustomInputField(
                hintText: 'Select your education level',
                label: 'Education level',
                optional: true,
                labelStyle: labelStyle,
                selectItems: educationLevel,
                hintStyle: AppTheme.text.copyWith(fontSize: 16.0),
                controller: vm.educationLevelController,
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
          controller: vm.aboutController,
        ),
        _profileImage(vm),
      ],
    );
  }

  Widget _profileImage(AboutMeVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Header6(title: 'Profile picture', optional: true),
        Row(
          spacing: 15,
          children: [
            AboutMeProfilePic(size: 80),
            Flexible(
              child: Column(
                spacing: 4,
                children: [
                  AppButton.secondary(
                    onTap: vm.uploadPhoto,
                    text: 'Upload photo',
                    mainAxisSize: MainAxisSize.min,
                    minHeight: 42,
                    color: AppTheme.coolGray,
                    textColor: AppTheme.darkSlateGray,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.upload,
                      size: 16,
                    ),
                  ),
                  Text(
                    'PNG, JPG or GIF, max 5MB',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.steelMist,
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
              applicationReasons.map((reason) {
                bool isSelected = vm.selectedApplicationReasons.contains(
                  reason,
                );
                String reasonString = reason.toString();
                return InkWell(
                  onTap: () => vm.selectApplicationReason(reason),
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
                                ? AppTheme.strongBlue
                                : AppTheme.defaultBlack,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Text(
                                reasonString,
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.darkSlateGray,
                                  fontSize: 16.0,
                                ),
                              ),
                              if (reason == ApplicationReason.other)
                                CustomInputField(
                                  hintText: 'Please specify',
                                  hintStyle: AppTheme.text.copyWith(
                                    color: AppTheme.slateGray,
                                    fontSize: 16.0,
                                    height: 1.50,
                                  ),
                                  fillColor: AppTheme.whisperGrey,
                                  validator:
                                      vm.selectedApplicationReasons.contains(
                                            ApplicationReason.other,
                                          )
                                          ? (input) => noNullValidator(
                                            value: input,
                                            message: 'Enter custom reasons',
                                          )
                                          : null,
                                  controller: vm.othersController,
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
          style: AppTheme.text.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Help us personalize your experience (you can skip or edit this later)',
          style: AppTheme.text.copyWith(
            color: AppTheme.stormGray,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
