import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/fields/custom_text_field.dart';

class SearchField extends StatefulWidget {
  final void Function()? onTap;
  final void Function(String)? onSearch;
  final TextEditingController? controller;
  final bool readOnly;
  final String hint;
  const SearchField({
    super.key,
    this.onTap,
    this.readOnly = false,
    this.controller,
    this.onSearch,
    this.hint = AppStrings.search,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool _canClear = false;
  @override
  void initState() {
    widget.controller?.addListener(_searchListener);
    super.initState();
  }

  void _searchListener() {
    if (!_canClear) {
      if (widget.controller!.text.isNotEmpty) {
        setState(() {
          _canClear = true;
        });
      }
    } else {
      if (widget.controller!.text.isEmpty) {
        setState(() {
          _canClear = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSearch,
      textInputAction: TextInputAction.search,
      controller: widget.controller,
      readOnly: widget.readOnly,
      hintText: widget.hint,
      hintStyle: TextStyle(
        color: context.theme.iconTheme.color?.withOpacity(0.5),
      ),
      prefixIcon: const Icon(HugeIcons.strokeRoundedSearch01),
      prefixIconColor: context.theme.iconTheme.color?.withOpacity(0.5),
      suffixIcon: _canClear
          ? IconButton(
              onPressed: _clear,
              icon: Icon(
                HugeIcons.strokeRoundedCancel01,
                color: context.theme.iconTheme.color?.withOpacity(0.5),
              ),
            )
          : null,
    );
  }

  void _clear() {
    widget.controller?.clear();
  }
}
