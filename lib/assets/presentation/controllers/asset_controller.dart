import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/assets/domain/entities/location_entity.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_assets_usecase.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_locations_usecase.dart';

enum Sensor { energy, critical }

class MyNode {
  MyNode({
    required this.location,
    Iterable<MyNode>? children,
  }) : children = <MyNode>[...?children];

  final LocationEntity location;
  final List<MyNode> children;
}

class AssetController extends GetxController with StateMixin {
  final GetAssetsUseCase getAssetsUseCase;
  final GetLocationsUseCase getLocationsUseCase;

  Rxn<Set<Sensor>> sensorView = Rxn<Set<Sensor>>();
  final TextEditingController searchBarTextEditingController =
      TextEditingController();
  late final TreeController<MyNode> treeController;
  late final List<MyNode> root;

  var filter = Rxn<TreeSearchResult<MyNode>>();
  var searchPattern = Rxn<Pattern>();

  AssetController(this.getAssetsUseCase, this.getLocationsUseCase);

  @override
  void onClose() {
    filter.value = null;
    searchPattern.value = null;
    treeController.dispose();
    searchBarTextEditingController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    final companyId = Get.parameters['companyId'] ?? '';

    try {
      final locations = await getLocationsUseCase.execute(companyId);
      root = buildTree(locations);
      // final assets = await getAssetsUseCase.execute(companyId);
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

    Pattern pattern;
    try {
      pattern = RegExp(query);
    } on FormatException {
      pattern = query.toLowerCase();
    }
    searchPattern.value = pattern;

    filter.value = treeController.search(
        (MyNode node) => node.location.name.toLowerCase().contains(pattern));
    treeController.rebuild();
  }

  void clearSearch() {
    if (filter.value == null) return;

    filter.value = null;
    searchPattern.value = null;
    treeController.rebuild();
    searchBarTextEditingController.clear();
  }

  void onSearchQueryChanged() {
    final String query = searchBarTextEditingController.text.trim();

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    search(query);
  }

  List<MyNode> buildTree(List<LocationEntity> locations) {
    Map<String, MyNode> mapIdToNode = {
      for (var location in locations)
        location.id: MyNode(
          location: location,
          children: [],
        ),
    };

    List<MyNode> root = [];

    for (var location in locations) {
      MyNode currentNode = mapIdToNode[location.id]!;

      if (currentNode.location.parentId == null) {
        root.add(currentNode);
      } else {
        MyNode? parent = mapIdToNode[currentNode.location.parentId];
        if (parent != null) {
          parent.children.add(currentNode);
        }
      }
    }

    return root;
  }
}
