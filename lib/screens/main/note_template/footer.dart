import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class NoteTemplateFooter extends StatelessWidget {
  const NoteTemplateFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteTemplateVm>(
      builder: (_, vm, _) {
        return CustomCard(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
          child: ResponsiveSection(
            mobile: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Flexible(child: _actions(vm))],
            ),
            laptop: Row(
              spacing: 20,
              children: [Expanded(child: _sectionSelector(vm)), _actions(vm)],
            ),
          ),
        );
      },
    );
  }

  Widget _actions(NoteTemplateVm vm) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      children: [
        AppButton.text(
          onTap: () {},
          text: 'Save as Favorite',
          mainAxisSize: MainAxisSize.min,
          wrapWithFlexible: true,
          color: AppTheme.strongBlue,
          prefix: Icon(Icons.star_border, color: AppTheme.strongBlue),
        ),
        AppButton(
          minHeight: 36,
          mainAxisSize: MainAxisSize.min,
          onTap: vm.createNote,
          text: 'Create Note',
          prefix: Icon(Icons.add, color: AppTheme.white),
          // wrapWithFlexible: true,
        ),
      ],
    );
  }

  Widget _sectionSelector(NoteTemplateVm vm) {
    return Row(
      children:
          noteTemplatesSections.map((section) {
            bool isSelected = vm.selectedSection == section;
            return InkWell(
              onTap: () {
                vm.updateSelectedSection(section);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.lightAsh : AppTheme.transparent,
                  borderRadius: BorderRadius.circular(9999),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: Text(
                  section,
                  textAlign: TextAlign.center,
                  style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
                ),
              ),
            );
          }).toList(),
    );
  }
}
