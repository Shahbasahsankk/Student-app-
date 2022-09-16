import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sample_one/providers/students_provider.dart';

import '../model/data_model.dart';
import '../providers/image_provider.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class EditScreen extends StatelessWidget {
  EditScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.domain,
    required this.number,
    required this.image,
    required this.index,
    required this.id,
  }) : super(key: key);

  final String name;
  final String age;
  final String domain;
  final String number;
  String image;
  int index;
  final String id;

  late TextEditingController nameController;

  late TextEditingController ageController;

  late TextEditingController domainController;

  late TextEditingController numberController;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController(text: name);
    ageController = TextEditingController(text: age);
    domainController = TextEditingController(text: domain);
    numberController = TextEditingController(text: number);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(
                        File(image),
                      ),
                      radius: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 46,
                        top: 120,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          imagepicker(context);
                        },
                        child: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const Text('Edit Photo'),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill your Name';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill your Age';
                    } else if (value.length > 2) {
                      return 'Impossible value';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: 'Age',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: domainController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill your Domain';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: 'Domain',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill your Mobile Number';
                    } else if (value.length != 10) {
                      return 'Number must be 10 digits';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: 'Mobile Number',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      save(context);
                    }
                  },
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void imagepicker(context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            width: 200,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<ImageProvder>(context, listen: false)
                        .getImage(ImageSource.camera);
                    Navigator.pop(ctx);
                  },
                  child: const Icon(Icons.camera_alt_sharp),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<ImageProvder>(context, listen: false)
                        .getImage(ImageSource.gallery);
                    Navigator.pop(ctx);
                  },
                  child: const Icon(Icons.image_search),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void save(ctx) async {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text('Saving'),
      ),
    );
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final studentModel = StudentModel(
      name: nameController.text,
      age: ageController.text,
      domain: domainController.text,
      number: numberController.text,
      image: image,
      id: id,
    );
    Provider.of<StudentsProvider>(ctx, listen: false).update(id, studentModel);
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false,
    );
  }
}
