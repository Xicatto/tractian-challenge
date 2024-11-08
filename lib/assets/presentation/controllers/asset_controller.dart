import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/assets/domain/entities/asset_entity.dart';
import 'package:tractian_mobile/assets/domain/entities/location_entity.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_assets_usecase.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_locations_usecase.dart';

class MyNode {
  MyNode({
    this.location,
    this.asset,
    List<MyNode>? children,
  }) : children = <MyNode>[...?children];

  final LocationEntity? location;
  final AssetEntity? asset;
  final List<MyNode> children;
}

class AssetController extends GetxController with StateMixin {
  final GetAssetsUseCase getAssetsUseCase;
  final GetLocationsUseCase getLocationsUseCase;

  Rxn<Set<SensorStatus>> sensorView = Rxn<Set<SensorStatus>>();
  final TextEditingController searchBarTextEditingController =
      TextEditingController();
  late final TreeController<MyNode> treeController;
  late final List<MyNode> root;

  var filter = Rxn<TreeSearchResult<MyNode>>();

  AssetController(this.getAssetsUseCase, this.getLocationsUseCase);

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
    final companyId = Get.parameters['companyId'] ?? '';

    try {
      final locations = await getLocationsUseCase.execute(companyId);
      final assets = await getAssetsUseCase.execute(companyId);
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

  void search(String query) {
    filter.value = null;

    filter.value = treeController.search((node) {
      final locationName = node.location?.name.toLowerCase();
      final assetName = node.asset?.name.toLowerCase();

      return (locationName != null && locationName.contains(query)) ||
          (assetName != null && assetName.contains(query)) &&
              (sensorView.value != null &&
                  (sensorView.value!.first == Sensor.energy ||
                      sensorView.value!.first == Status.alert));
    });

    treeController.rebuild();
  }

  void clearSearch() {
    if (filter.value == null) return;

    filter.value = null;
    treeController.rebuild();
    searchBarTextEditingController.clear();
  }

  void onSearchQueryChanged() {
    final String query =
        searchBarTextEditingController.text.toLowerCase().trim();

    if (query.isEmpty) {
      // clearSearch();
      return;
    }

    search(query);
  }

  List<MyNode> buildTree(
      List<LocationEntity> locations, List<AssetEntity> assets) {
    // Mapping locations and assets
    Map<String, MyNode> mapNodes = {
      for (var location in locations) location.id: MyNode(location: location),
      for (var asset in assets) asset.id: MyNode(asset: asset),
    };

    List<MyNode> root = [];

    // Process both locations and assets
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
