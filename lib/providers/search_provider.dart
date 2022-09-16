import 'package:flutter/cupertino.dart';
import 'package:sample_one/db/functions/db_functions.dart';
import '../model/data_model.dart';

class SearchProvider with ChangeNotifier {
  bool visible = false;
  List<StudentModel> allStudents = [];
  List<StudentModel> foundStudents = [];

  void searchStudent(String value) async {
    List<StudentModel> result = [];
    if (value.isEmpty) {
      allStudents = await DBFunctions().getAllStudents();
      foundStudents = allStudents;
    } else {
      allStudents = await DBFunctions().getAllStudents();
      result = allStudents
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      foundStudents = result;
    }
    notifyListeners();
  }

  Future<void> delete(id) async {
    await DBFunctions().deleteStudent(id);
    notifyListeners();
  }

  void searchOnOff(value) {
    if (value == true) {
      visible = true;
    } else {
      visible = false;
    }
    notifyListeners();
  }
}
