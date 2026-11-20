import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/poi-categories.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    required this.poiCategory,
    required this.active,
    required this.onChange,
    this.fallbackIcon,
    super.key,
  });

  /// Category represented by this button.
  final Query_PoiCategoryForKommune_poiCategories_docs poiCategory;

  /// Whether the category is currently selected.
  final bool active;

  /// Called when the category selection changes.
  final VoidCallback onChange;

  /// Local icon used when the category has no backend icon.
  final IconData? fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconUrl = poiCategory.icon?.url;
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: MaterialButton(
              padding: const EdgeInsets.all(8),
              shape: const CircleBorder(),
              color: active ? theme.primaryColorLight : DesignTokens.gray100,
              elevation: 0,
              onPressed: onChange,
              child: iconUrl == null || iconUrl.isEmpty
                  ? Icon(fallbackIcon, size: 32)
                  : SvgPicture.network(height: 48, width: 48, iconUrl),
            ),
          ),
          Text(poiCategory.title),
        ],
      ),
    );
  }
}
