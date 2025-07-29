// import 'package:flutter/material.dart';
// import 'package:navinotes/screens/main/choose_board/vm.dart';
// import 'package:provider/provider.dart';
// import 'package:navinotes/settings/packages.dart';
// import 'package:navinotes/widgets/index.dart';

// class ChooseBoardAside extends StatelessWidget {
//   const ChooseBoardAside({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChooseBoardVm>(
//       builder: (context, vm, child) {
//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: AppTheme.white,
//             border: Border(
//               right: BorderSide(width: 2, color: AppTheme.lightGray),
//             ),
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ScrollableController(
//                   mobilePadding: EdgeInsets.all(20),
//                   child: Column(
//                     spacing: 30,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _preview(vm),
//                       _description(vm),
//                       _colorPalette(),
//                       _customization(vm),
//                       _fontStyle(),
//                       _brainyTip(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _brainyTip() {
//     return CustomCard(
//       decoration: BoxDecoration(
//         color: AppTheme.ivoryGlow,
//         border: Border.all(color: AppTheme.amber),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 10,
//         children: [
//           SVGImagePlaceHolder(imagePath: Images.logo, size: 22),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               spacing: 10,
//               children: [
//                 Text(
//                   'Navi Tip',
//                   style: AppTheme.text.copyWith(
//                     color: AppTheme.abyssTeal,
//                     fontWeight: getFontWeight(500),
//                   ),
//                 ),
//                 Text(
//                   'Choose a style that helps you focus. Different aesthetics can stimulate different types of thinking and creativity!',
//                   style: AppTheme.text.copyWith(
//                     color: AppTheme.black,
//                     fontSize: 12.0,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _fontStyle() {
//     return CustomInputField(
//       hintText: 'Font Style',
//       label: 'Font Style',
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: AppTheme.pastelBlue),
//       ),
//       selectItems: ['Sans Serif', 'Serif', 'Monospace'],
//       controller: TextEditingController(text: 'Sans Serif'),
//       labelStyle: AppTheme.text.copyWith(color: AppTheme.black, fontSize: 12.0),
//     );
//   }

//   Widget _customization(ChooseBoardVm vm) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 15,
//       children: [
//         Text(
//           'Customization',
//           style: AppTheme.text.copyWith(
//             color: AppTheme.black,
//             fontWeight: getFontWeight(500),
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 5,
//           children: [
//             Text(
//               'Accent Color',
//               style: AppTheme.text.copyWith(
//                 color: AppTheme.black,
//                 fontSize: 12.0,
//               ),
//             ),
//             ScrollableController(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 10,
//                 children: [
//                   ColorWidget(AppTheme.vividBlue),
//                   ColorWidget(AppTheme.primaryColor),
//                   ColorWidget(AppTheme.lavenderPurple),
//                   ColorWidget(AppTheme.coralRed),
//                   ColorWidget(AppTheme.amber),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         _backgroundPattern(vm),
//       ],
//     );
//   }

//   Widget _backgroundPattern(ChooseBoardVm vm) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 4,
//       children: [
//         Text(
//           'Background Pattern',
//           style: AppTheme.text.copyWith(color: AppTheme.black, fontSize: 12.0),
//         ),
//         Column(
//           spacing: 7,
//           children: [
//             CustomSlider(
//               slider: Slider(
//                 value: vm.backgroundPatternOpacity,
//                 onChanged: vm.updateBackgroundPatternOpacity,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               spacing: 10,
//               children:
//                   ['None', 'Subtle', 'Strong']
//                       .map(
//                         (str) => Flexible(
//                           child: Text(
//                             str,
//                             style: AppTheme.text.copyWith(
//                               color: AppTheme.black,
//                               fontSize: 12.0,
//                             ),
//                           ),
//                         ),
//                       )
//                       .toList(),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _colorPalette() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 8,
//       children: [
//         Text(
//           'Color Palette',
//           style: AppTheme.text.copyWith(
//             color: AppTheme.black,
//             fontWeight: getFontWeight(500),
//           ),
//         ),
//         ScrollableRow(
//           children: [
//             ColorWidget(AppTheme.white, size: 32),
//             ColorWidget(AppTheme.lightGray, size: 32),
//             ColorWidget(AppTheme.vividBlue, size: 32),
//             ColorWidget(AppTheme.mintyGreen, size: 32),
//             ColorWidget(AppTheme.defaultBlack, size: 32),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _description(ChooseBoardVm vm) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 15,
//       children: [
//         Text(
//           vm.selectedBoard.name,
//           style: AppTheme.text.copyWith(
//             color: AppTheme.abyssTeal,
//             fontSize: 16.0,
//             fontWeight: getFontWeight(500),
//           ),
//         ),
//         Text(
//           vm.selectedBoard.body,
//           style: AppTheme.text.copyWith(color: AppTheme.black),
//         ),
//       ],
//     );
//   }

//   Widget _preview(ChooseBoardVm vm) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 10,
//       children: [
//         Text(
//           'Preview',
//           style: AppTheme.text.copyWith(
//             color: AppTheme.vividRose,
//             fontSize: 16.0,
//             fontWeight: getFontWeight(600),
//           ),
//         ),
//         CustomCard(
//           decoration: BoxDecoration(
//             border: Border.all(color: AppTheme.paleBlue),
//           ),
//           child: ImagePlaceHolder(
//             imagePath: vm.selectedBoard.image,
//             borderRadius: BorderRadius.zero,
//           ),
//         ),
//       ],
//     );
//   }
// }
