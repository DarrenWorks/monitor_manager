import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_manager/module/common/database/building_dao.dart';
import 'package:monitor_manager/module/common/database/database_manager.dart';
import 'package:monitor_manager/module/model/mode.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../../common/database/camera_dao.dart';
import '../../common/database/floor_dao.dart';
import '../../model/building.dart';
import '../../model/camera.dart';
import '../../model/floor.dart';

class HomeLogic extends GetxController {
  //编辑模式
  RxBool _editMode = false.obs;

  bool get editMode => _editMode.value;

  changeEditMode() {
    _editMode.value = !_editMode.value;
  }

  String get editButtonString => _editMode.value ? "完成" : '编辑';

  //当前数据模式
  Rx<Mode> _mode = Mode.Building.obs;

  Mode get mode => _mode.value;

  int buildingId = -1;
  int floorId= -1;
  int cameraId = -1;

  nextMode(int id) {
    Mode nextMode;
    switch (mode) {
      case Mode.Building:
        nextMode = Mode.Floor;
        buildingId = id;
        _changeMode(nextMode);
        break;
      case Mode.Floor:
        nextMode = Mode.Camera;
        floorId = id;
        _changeMode(nextMode);
        break;
      case Mode.Camera:
        nextMode = Mode.Camera;
        cameraId = id;
        _changeMode(nextMode);
        break;
    }
  }

  previousMode() {
    Mode previousMode;
    switch (mode) {
      case Mode.Building:
        previousMode = Mode.Building;
        buildingId = -1;
        _changeMode(previousMode);
        break;
      case Mode.Floor:
        previousMode = Mode.Building;
        floorId = -1;
        _changeMode(previousMode);
        break;
      case Mode.Camera:
        previousMode = Mode.Floor;
        cameraId = -1;
        _changeMode(previousMode);
        break;
    }
  }

  //切换模式
  _changeMode(Mode mode) {
    _mode.value = mode;
    _updateData();
  }

  //获取database
  Future<Database> get database async => await DatabaseManager().database;

  //当前数据
  final RxList _data = [].obs;

  List get data => _data;

  //更新数据
  _updateData() async {
    switch (mode) {
      case Mode.Building:
        _data.value = await BuildingDAO.queryAllBuildings(await database);
        break;

      case Mode.Floor:
        _data.value = await FloorDAO.queryFloorsByBuildingId(await database, buildingId);
        break;
      case Mode.Camera:
        _data.value = await CameraDAO.queryCamerasByFloorId(await database, floorId);
        break;
    }
  }

  final TextEditingController _addController = TextEditingController();
  TextEditingController get addController => _addController;

  final TextEditingController _ipController = TextEditingController();
  TextEditingController get ipController => _ipController;

  //添加
  edit(bool add, int? index) {
    if(add) {
      switch (mode) {
        case Mode.Building:
          addBuilding();
          break;
        case Mode.Floor:
          addFloor();
          break;
        case Mode.Camera:
          addCamera();
          break;
      }
    } else {
      switch (mode) {
        case Mode.Building:
          editBuilding(index!);
          break;
        case Mode.Floor:
          editFloor(index!);
          break;
        case Mode.Camera:
          editCamera(index!);
          break;
      }
    }
  }

  //删除
  delete(int index) async {
    switch (mode) {
      case Mode.Building:
        await BuildingDAO.deleteBuilding(await database, _data[index].id);
        break;
      case Mode.Floor:
        await FloorDAO.deleteFloor(await database, _data[index].id);
        break;
      case Mode.Camera:
        await CameraDAO.deleteCamera(await database, _data[index].id);
        break;
    }
    _data.removeAt(index);
  }

  //添加building
  addBuilding() async {
    int id =
        await BuildingDAO.insertBuilding(await database, addController.text);
    _data.add(Building(id: id, name: addController.text));
    addController.text = '';
  }

  //编辑building
  editBuilding(int index) async {
    await BuildingDAO.updateBuilding(await database, _data[index].id, addController.text);
    _data[index].name = addController.text;
    _data.refresh();
    addController.text = '';
  }

  //添加floor
  addFloor() async {
    int id = await FloorDAO.insertFloor(
        await database, buildingId, addController.text);
    _data.add(Floor(id: id, buildingId: buildingId, name: addController.text));
    addController.text = '';
  }

  //编辑floor
  editFloor(int index) async {
    await FloorDAO.updateFloor(await database, _data[index].id, buildingId, addController.text);
    _data[index].name = addController.text;
    _data.refresh();
    addController.text = '';
  }

  //添加camera
  addCamera() async {
    int id = await CameraDAO.insertCamera(
        await database, floorId, addController.text, ipController.text);
    _data.add(
        Camera(id: id, floorId: floorId, name: addController.text, ip: ipController.text));
    addController.text = '';
    ipController.text = '';
  }

  //编辑camera
  editCamera(int index) async {
    await CameraDAO.updateCamera(await database, _data[index].id, floorId, addController.text, "");
    _data[index].name = addController.text;
    _data.refresh();
    addController.text = '';
    ipController.text = '';
  }

@override
  void onInit() {
    super.onInit();

    _updateData();
  }
}
