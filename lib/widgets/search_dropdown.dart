import 'package:navinotes/packages.dart';

class SearchDropdownField<T> extends StatelessWidget {
  const SearchDropdownField({
    super.key,
    required this.input,
    required this.suggestionsCallback,
    required this.itemBuilder,
  });
  final CustomInputField input;
  final FutureOr<List<T>?> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T) itemBuilder;
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      suggestionsCallback: suggestionsCallback,
      builder: (_, controller, focusNode) {
        return CustomInputField(
          controller: controller,
          focusNode: focusNode,
          prefixIcon: input.prefixIcon,
          hintText: input.hintText,
          fillColor: input.fillColor,
          side: input.side,
          hintStyle: input.hintStyle,
        );
      },
      itemBuilder: itemBuilder,
      onSelected: (str) {},
    );
  }
}
