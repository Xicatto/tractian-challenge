import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/assets/model/asset_entity.dart';
import 'package:tractian_mobile/assets/model/location_entity.dart';
import 'package:tractian_mobile/assets/provider/asset_provider.dart';
import 'package:tractian_mobile/assets/provider/location_provider.dart';

class MyNode {
  MyNode({
    this.location,
    this.asset,
    List<MyNode>? children,
  }) : children = <MyNode>[...?children];

  final Location? location;
  final Asset? asset;
  final List<MyNode> children;
}

class AssetController extends GetxController with StateMixin {
  Rx<Set<SensorStatus>> sensorView = Rx<Set<SensorStatus>>({});
  final TextEditingController searchBarTextEditingController =
      TextEditingController();
  late final TreeController<MyNode> treeController;
  late final List<MyNode> root;

  var filter = Rxn<TreeSearchResult<MyNode>>();

  @override
  void onClose() {
    filter.value = null;
    searchBarTextEditingController.dispose();
    try {
      treeController.dispose();
    } catch (e) {
      log(e.toString());
    }
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    fetchData();
  }

  fetchData() async {
    final companyId = Get.parameters['companyId'] ?? '';

    try {
      final locationsRes = await LocationProvider().fetchLocations(companyId);
      final locations = (locationsRes.body as List).map((location) {
        return Location.fromJson(location);
      }).toList();

      final assetsRes = await AssetProvider().fetchAssets(companyId);
      final assets = (assetsRes.body as List).map((asset) {
        return Asset.fromJson(asset);
      }).toList();

      root = buildTree(locations, assets);
      treeController = TreeController<MyNode>(
        roots: root,
        childrenProvider: getChildren,
      );

      searchBarTextEditingController.addListener(onSearchQueryChanged);

      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Iterable<MyNode> getChildren(MyNode node) {
    if (filter.value != null) {
      return node.children.where(filter.value!.hasMatch);
    }
    return node.children;
  }

  void clearSearch() {
    filter.value = null;
    sensorView.value = {};
    treeController.rebuild();
    searchBarTextEditingController.clear();
  }

  void onSearchQueryChanged() {
    final String query =
        searchBarTextEditingController.text.toLowerCase().trim();

    if (query.isEmpty && sensorView.value.isEmpty) {
      clearSearch();
      return;
    }

    applyCombinedFilters(sensorView.value);
  }

  void applyCombinedFilters(Set<SensorStatus> newSelection) {
    final String query =
        searchBarTextEditingController.text.toLowerCase().trim();
    filter.value = null;

    if (query.isEmpty && newSelection.isEmpty) {
      clearSearch();
      return;
    }

    if (newSelection.isEmpty) {
      filter.value = treeController.search((node) {
        final locationName = node.location?.name.toLowerCase();
        final assetName = node.asset?.name.toLowerCase();

        return (locationName != null && locationName.contains(query)) ||
            (assetName != null && assetName.contains(query));
      });
      treeController.rebuild();
      return;
    }

    filter.value = treeController.search((node) {
      final asset = node.asset;
      if (asset == null) return false;

      final assetName = asset.name.toLowerCase();
      if (assetName.isEmpty || !assetName.contains(query)) {
        return false; // Early return if name doesn't match query
      }

      // Check sensor or status based on the first sensorView value
      if (sensorView.value.first == Sensor.energy) {
        return asset.sensorType == Sensor.energy.name;
      } else {
        return asset.status == Status.alert.name;
      }
    });

    treeController.rebuild();
  }

  List<MyNode> buildTree(List<Location> locations, List<Asset> assets) {
    Map<String, MyNode> mapNodes = {
      for (var location in locations) location.id: MyNode(location: location),
      for (var asset in assets) asset.id: MyNode(asset: asset),
    };

    List<MyNode> root = [];

    for (final location in locations) {
      final currentNode = mapNodes[location.id]!;

      if (currentNode.location!.parentId == null) {
        root.add(currentNode);
      } else {
        final parent = mapNodes[currentNode.location!.parentId];
        if (parent != null) {
          parent.children.add(currentNode);
        }
      }
    }

    for (final asset in assets) {
      final currentNode = mapNodes[asset.id]!;

      if (currentNode.asset!.parentId == null &&
          currentNode.asset!.locationId == null) {
        root.add(currentNode);
      } else if (currentNode.asset!.locationId != null) {
        final parent = mapNodes[currentNode.asset!.locationId];
        if (parent != null) {
          parent.children.add(currentNode);
        }
      } else {
        final parent = mapNodes[currentNode.asset!.parentId];
        if (parent != null) {
          parent.children.add(currentNode);
        }
      }
    }

    return root;
  }
}
