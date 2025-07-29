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
          border: input.border,
          constraints: input.constraints,
          contentPadding: input.contentPadding,
          keyboardType: input.keyboardType,
          label: input.label,
          suffixIcon: input.suffixIcon,
          validator: input.validator,
          labelRight: input.labelRight,
          optional: input.optional,
          labelStyle: input.labelStyle,
          maxLines: input.maxLines,
          onChanged: input.onChanged,
          onSubmitted: input.onSubmitted,
          required: input.required,
          selectItems: input.selectItems,
          style: input.style,
          wrapWithExpanded: input.wrapWithExpanded,
        );
      },
      itemBuilder: itemBuilder,
      onSelected: (str) {},
    );
  }
}

class NotePageSearchDropdown<T> extends StatelessWidget {
  const NotePageSearchDropdown({super.key, required this.input});
  final CustomInputField input;
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return LoadingIndicator(
          loading: vm.fetchingContent,
          child: SearchDropdownField<Content>(
            suggestionsCallback: (search) {
              return vm.contents
                  .where((item) => checkStringMatch(item.title, search))
                  .toList();
            },
            itemBuilder: (_, item) {
              return CustomListTile(
                onTap: () => vm.goToNotePage(item),
                title: item.title,
                color: AppTheme.steelMist,
                activeColor: AppTheme.strongBlue,
              );
            },
            input: input,
          ),
        );
      },
    );
  }
}
