import 'package:get/get.dart';
import 'package:monitor_manager/module/model/mode.dart';

class HomeLogic extends GetxController {
    RxBool _editMode = false.obs;

    bool get editMode => _editMode.value;

    changeEditMode() {
        _editMode.value = !_editMode.value;
    }

    String get editButtonString => _editMode.value ? "完成" : '编辑';

    Mode _mode = Mode.Building;
    List? _data;


}

