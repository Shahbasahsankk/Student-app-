

import 'package:flutter/material.dart';
import 'package:sample_one/db/functions/db_functions.dart';

import '../model/data_model.dart';

class StudentsProvider with ChangeNotifier{
  List<StudentModel> list=[];
  void get()async{
     list=await DBFunctions().getAllStudents();
    notifyListeners();
  }
  void add(StudentModel value)async{
    list=await DBFunctions().addStudent(value);
    notifyListeners();
  }
  void update(String id,StudentModel value)async{
    await DBFunctions().updateStudent(id,value);
    notifyListeners();
  }
}