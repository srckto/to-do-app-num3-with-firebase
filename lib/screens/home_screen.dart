import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app_with_firebase/config.dart';
import 'package:to_do_app_with_firebase/controllers/home_controller.dart';
import 'package:to_do_app_with_firebase/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _homeController = Get.put(HomeController());
  final TextEditingController _taskTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context),
        body: Obx(() {
          _homeController.getTasks();
          if (_homeController.state.value)
            return Center(child: CircularProgressIndicator());
          else if (_homeController.tasks.isEmpty)
            return Container(
              child: Center(
                child: Image(
                  image: AssetImage("assets/no_task.png"),
                ),
              ),
            );

          return ListView.builder(
            itemCount: _homeController.tasks.length,
            itemBuilder: (context, int index) {
              return ListTile(
                title: Text(_homeController.tasks[index].task),
                onTap: null,
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _homeController.deleteTask(taskID: _homeController.tasks[index].taskID);
                  },
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDiloag(
              context: context,
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          elevation: 4,
          backgroundColor: k_primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  Get.off(() => LoginScreen());
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<dynamic> _showDiloag({
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Add Task"),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _taskTxtController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Write your task here",
                labelText: "Task Name",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Get.back();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: k_primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                  ),
                  child: Text("Add"),
                  onPressed: () async {
                    _homeController.createTask(textTask: _taskTxtController.text);
                    FocusScope.of(context).unfocus();
                    _taskTxtController.clear();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text("To Do App"),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.off(() => LoginScreen());
          },
          child: Text(
            "SignOut",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ],
    );
  }
}
