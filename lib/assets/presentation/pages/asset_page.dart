import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/assets/presentation/controllers/asset_controller.dart';

class AssetPage extends GetView<AssetController> {
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: controller.obx(
        (tree) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBar(
                  controller: controller.searchBarTextEditingController,
                  hintText: 'Buscar Ativo ou Local',
                  leading: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.filter_list),
                  ),
                  trailing: [
                    Obx(
                      () => Badge(
                        isLabelVisible: controller.filter.value != null,
                        backgroundColor:
                            controller.filter.value?.totalMatchCount == 0
                                ? Colors.red
                                : Colors.green,
                        label: Text(
                          '${controller.filter.value?.totalMatchCount}/${controller.filter.value?.totalNodeCount}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: controller.clearSearch,
                    )
                  ],
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SegmentedButton<Sensor>(
                      segments: [
                        ButtonSegment(
                          value: Sensor.energy,
                          label: Text('Sensor de Energia'),
                          icon: Icon(Icons.bolt_outlined),
                        ),
                        ButtonSegment(
                          value: Sensor.critical,
                          label: Text('Crítico'),
                          icon: Icon(Icons.error_outline),
                        ),
                      ],
                      emptySelectionAllowed: true,
                      selected: controller.sensorView.value ?? {},
                      onSelectionChanged: (newSelection) {
                        controller.sensorView.value = newSelection;
                      },
                      showSelectedIcon: false,
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: AnimatedTreeView<MyNode>(
                  treeController: controller.treeController,
                  nodeBuilder: (BuildContext context, TreeEntry<MyNode> entry) {
                    return TreeTile(
                      entry: entry,
                      match: controller.filter.value?.matchOf(entry.node),
                      searchPattern: controller.searchPattern.value,
                    );
                  },
                  duration:
                      const Duration(milliseconds: 300), // Adjust as needed
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TreeTile extends StatelessWidget {
  const TreeTile({
    super.key,
    required this.entry,
    required this.match,
    required this.searchPattern,
  });

  final TreeEntry<MyNode> entry;
  final TreeSearchMatch? match;
  final Pattern? searchPattern;

  bool get shouldShowBadge =>
      !entry.isExpanded && (match?.subtreeMatchCount ?? 0) > 0;

  bool shouldShowMatch() {
    if (match != null && match!.isDirectMatch) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      child: Row(
        children: [
          ExpandIcon(
            key: GlobalObjectKey(entry.node),
            isExpanded: entry.isExpanded,
            onPressed: (_) => TreeViewScope.of<MyNode>(context)
              ..controller.toggleExpansion(entry.node),
          ),
          if (shouldShowBadge)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Badge(
                label: Text('${match?.subtreeMatchCount}'),
                backgroundColor: Colors.green,
              ),
            ),
          Flexible(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: shouldShowMatch() ? Colors.green : null,
                ),
                SizedBox(
                  width: 8,
                ),
                Text.rich(
                  style: TextStyle(
                    color: shouldShowMatch() ? Colors.green : null,
                    fontWeight: shouldShowMatch() ? FontWeight.bold : null,
                  ),
                  TextSpan(
                    text: entry.node.location.name,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // InlineSpan buildTextSpan() {
  //   final String title = entry.node.location.name;

  //   if (searchPattern == null) {
  //     return TextSpan(text: title);
  //   }

  //   final List<InlineSpan> spans = <InlineSpan>[];
  //   bool hasAnyMatches = false;

  //   title.splitMapJoin(
  //     searchPattern!,
  //     onMatch: (Match match) {
  //       hasAnyMatches = true;
  //       spans.add(TextSpan(text: match.group(0)!));
  //       return '';
  //     },
  //     onNonMatch: (String text) {
  //       spans.add(TextSpan(text: text));
  //       return '';
  //     },
  //   );

  //   if (hasAnyMatches) {
  //     return TextSpan(children: spans);
  //   }

  //   return TextSpan(text: title);
  // }
}
