import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:to_do_app_with_firebase/models/task_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxBool state = false.obs;

  createTask({
    required String textTask,
  }) {
    TaskModel _task = TaskModel(
      task: textTask,
      date: DateTime.now().toString(),
      taskID: "",
    );
    _db
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("tasks")
        .add(_task.toMap())
        .then((value) {
      value.update({
        "taskID": value.id,
      });
    });

  }

  getTasks() {
    state.value = true;
    _db
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("tasks")
        .orderBy("date", descending: true)
        .snapshots()
        .listen((event) {
      tasks.clear();

      event.docs.forEach((element) {
        tasks.add(TaskModel.formJson(element.data()));
      });
    });
    state.value = false;
  }

  deleteTask({required taskID}) {
    _db.collection("users").doc(_auth.currentUser!.uid).collection("tasks").doc(taskID).delete();
  }
}
