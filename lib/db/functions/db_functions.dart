import 'package:hive_flutter/adapters.dart';
import '../../model/data_model.dart';

class DBFunctions {
  static List<StudentModel> studentList = [];

  Future<List<StudentModel>> addStudent( StudentModel value) async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    await studentDB.put(value.id,value);
    studentList.add(value);
    return studentList;
  }

  Future<List<StudentModel>> getAllStudents() async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    studentList.clear();
    studentList.addAll(studentDB.values);
    return studentList;
  }

  Future<void> deleteStudent(id) async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    await studentDB.delete(id);
     getAllStudents();
  }

  Future<void> updateStudent(String id, StudentModel value) async {
    final studentDB = await Hive.openBox<StudentModel>('student_db');
    studentDB.put(id, value);
  }
}
