import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/assets/model/asset_entity.dart';
import 'package:tractian_mobile/assets/presentation/controllers/asset_controller.dart';

class AssetPage extends GetWidget<AssetController> {
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
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<SensorStatus>(
                    segments: [
                      ButtonSegment(
                        value: Sensor.energy,
                        label: Text('Sensor de Energia'),
                        icon: Icon(Icons.bolt_outlined),
                      ),
                      ButtonSegment(
                        value: Status.alert,
                        label: Text('Crítico'),
                        icon: Icon(Icons.error_outline),
                      ),
                    ],
                    emptySelectionAllowed: true,
                    selected: controller.sensorView.value,
                    onSelectionChanged: (newSelection) {
                      controller.sensorView.value = newSelection;
                      controller.applyCombinedFilters(newSelection);
                    },
                    showSelectedIcon: false,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: TreeView<MyNode>(
                  treeController: controller.treeController,
                  nodeBuilder: (BuildContext context, TreeEntry<MyNode> entry) {
                    final filter = controller.filter.value;
                    if (filter == null || filter.hasMatch(entry.node)) {
                      return TreeTile(
                        entry: entry,
                        match: filter?.matchOf(entry.node),
                      );
                    }
                    return SizedBox.shrink();
                  }, // Adjust as needed
                ),
              ),
            ],
          );
        },
        onError: (error) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}

class TreeTile extends StatelessWidget {
  const TreeTile({
    super.key,
    required this.entry,
    required this.match,
  });

  final TreeEntry<MyNode> entry;
  final TreeSearchMatch? match;

  bool get shouldShowBadge =>
      !entry.isExpanded && (match?.subtreeMatchCount ?? 0) > 0;

  bool get shouldShowMatch {
    if (match != null && match!.isDirectMatch) return true;
    return false;
  }

  String get getImageIcon {
    final value = entry.node;

    if (value.location != null) {
      return 'location.png';
    }

    final asset = value.asset!;
    return (asset.sensorType == null &&
            (asset.locationId != null || asset.parentId != null))
        ? 'asset.png'
        : 'component.png';
  }

  Widget get showSensorIcon {
    final value = entry.node;
    if (value.asset != null) {
      final asset = value.asset!;
      if (asset.sensorType == Sensor.energy.name &&
          asset.status != Status.alert.name) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.bolt_outlined,
            color: Colors.green,
            size: 24,
          ),
        );
      } else if (asset.status == Status.alert.name) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.circle,
            color: Colors.red,
            size: 12,
          ),
        );
      }
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      child: Row(
        children: [
          Visibility(
            visible: entry.hasChildren,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: ExpandIcon(
              key: GlobalObjectKey(entry.node),
              isExpanded: entry.isExpanded,
              onPressed: (_) => TreeViewScope.of<MyNode>(context)
                ..controller.toggleExpansion(entry.node),
            ),
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
                Image.asset(
                  'assets/$getImageIcon',
                  scale: 1.2,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text.rich(
                    softWrap: true,
                    style: TextStyle(
                      color: shouldShowMatch ? Colors.green : null,
                      fontWeight: shouldShowMatch ? FontWeight.bold : null,
                    ),
                    TextSpan(
                      text: entry.node.asset?.name ?? entry.node.location?.name,
                    ),
                  ),
                ),
                showSensorIcon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
