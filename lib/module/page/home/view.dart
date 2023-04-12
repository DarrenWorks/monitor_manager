import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('监控管理'),
        actions: [
          Center(
            child: Obx(() {
              return TextButton(
                child: Text(
                  logic.editMode ? "完成" : '编辑',
                  style: TextStyle(color: Colors.red),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  logic.changeEditMode();
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return logic.editMode
            ? FloatingActionButton(
                onPressed: () {
                  //todo 跳转到添加页面
                },
                child: Icon(Icons.add),
              )
            : Container();
      }),
      body: Container(),
    );
  }
}
