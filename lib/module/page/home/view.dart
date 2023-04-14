import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_manager/module/page/camera/view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/mode.dart';
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
        leading: Obx(() {
          return logic.mode != Mode.Building
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    logic.previousMode();
                  },
                )
              : Container();
        }),
        actions: [
          Center(
            //编辑按钮
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
      //添加按钮
      floatingActionButton: Obx(() {
        return logic.editMode
            ? FloatingActionButton(
                onPressed: () {
                  showEdit(true);
                },
                child: Icon(Icons.add),
              )
            : Container();
      }),
      body: Obx(() {
        return Wrap(
          children: List.generate(
              logic.data.length,
              (index) => logic.mode == Mode.Camera
                  ? camera(context, index)
                  : notCamera(index)),
        );
        return ListView.builder(
          itemCount: logic.data.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return notCamera(index);
          },
        );
      }),
    );
  }

  //非摄像头
  Widget notCamera(index) {
    return TextButton(
      onPressed: () {
        if (logic.editMode) {
          showEdit(false, index: index);
        } else {
          logic.nextMode(logic.data[index].id);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //名称
          Text(logic.data[index].name),
          //编辑按钮
          Obx(() {
            return logic.editMode
                ? GestureDetector(
                    child: Icon(Icons.close, color: Colors.grey),
                    onTap: () {
                      logic.delete(index);
                    },
                  )
                : Container();
          }),
        ],
      ),
    );
  }

  //摄像头
  Widget camera(context, index) {
    return TextButton(
      onPressed: () {
        // Get.to(()=>CameraPage(ip: logic.data[index].ip));
        if (logic.editMode) {
          showEdit(false, index: index);
        } else {
          goBrowser(logic.data[index].ip);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //名称
          Text(logic.data[index].name),
          SizedBox(width: 10),
          //ip
          Text(logic.data[index].ip),
          //编辑按钮
          Obx(() {
            return logic.editMode
                ? GestureDetector(
                    child: Icon(Icons.close, color: Colors.grey),
                    onTap: () {
                      logic.delete(index);
                    },
                  )
                : Container();
          }),
        ],
      ),
    );
  }

  //“编辑”弹窗
  showEdit(bool add, {int? index}) {
    if (!add) {
      logic.addController.text = logic.data[index!].name;
      if (logic.mode == Mode.Camera) {
        logic.ipController.text = logic.data[index].ip;
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(add ? '添加' : '编辑'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: logic.addController,
                  decoration: const InputDecoration(
                    hintText: '请输入名称',
                  ),
                ),
                logic.mode == Mode.Camera
                    ? TextField(
                        controller: logic.ipController,
                        decoration: const InputDecoration(
                          hintText: '请输入ip',
                        ),
                      )
                    : Container(),
              ],
            ),
            actions: [
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                  logic.addController.text = '';
                  logic.ipController.text = '';
                },
              ),
              TextButton(
                child: Text('确定'),
                onPressed: () {
                  logic.edit(add, index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //跳转浏览器
  goBrowser(String url) async {
    launchUrl(Uri.parse(url));
  }
}
