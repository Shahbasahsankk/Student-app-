import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_one/contants/constants.dart';
import 'package:sample_one/model/enum.dart';
import 'package:sample_one/providers/image_provider.dart';
import 'package:sample_one/views/add&edit_student/widgets/image_picker.dart';
import 'package:sample_one/views/add&edit_student/widgets/textfeilds.dart';
import 'package:sample_one/views/home/home_screen.dart';

import '../../model/data_model.dart';
import '../../providers/students_provider.dart';

class AddScreen extends StatelessWidget {
  AddScreen({
    Key? key,
    this.name,
    this.age,
    this.domain,
    this.number,
    this.image,
    this.index,
    this.idKey,
    this.type,
  }) : super(key: key);

  final ActionType? type;
  final _formkey = GlobalKey<FormState>();
  final String? name;
  final String? age;
  final String? domain;
  final String? number;
  final String? image;
  final int? index;
  final String? idKey;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (type == ActionType.editScreen) {
      _nameController.text = name!;
      _ageController.text = age!;
      _numberController.text = number!;
      _domainController.text = domain!;
    }
    final imgProvider = Provider.of<ImageProvder>(context, listen: false);
    if (type == ActionType.addScreen) {
      imgProvider.img = null;
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  sizedBoxH20,
                  Consumer<ImageProvder>(builder: (context, value, _) {
                    return Stack(
                      children: [
                        type == ActionType.editScreen
                            ? CircleAvatar(
                                backgroundImage: FileImage(
                                  File(value.img?.path ?? image!),
                                ),
                                radius: 60,
                              )
                            : value.img == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 60,
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(value.img!.path),
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
                    );
                  }),
                  const Text('Add Photo'),
                  sizedBoxH10,
                  Consumer<ImageProvder>(builder: (context, value, _) {
                    return Visibility(
                      visible: value.isVisible,
                      child: const Text(
                        'Please Add Photo',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }),
                  sizedBoxH40,
                  CustomTextFeild(
                    controller: _nameController,
                    hintText: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fill your Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  sizedBoxH20,
                  CustomTextFeild(
                    controller: _ageController,
                    hintText: 'Age',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fill your Age';
                      } else if (value.length > 2) {
                        return 'Impossible value';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                  sizedBoxH20,
                  CustomTextFeild(
                    controller: _domainController,
                    hintText: 'Domain',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fill your Domain';
                      } else {
                        return null;
                      }
                    },
                  ),
                  sizedBoxH20,
                  CustomTextFeild(
                    controller: _numberController,
                    hintText: 'Mobile Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fill your Mobile Number';
                      } else if (value.length != 10) {
                        return 'Number must be 10 digits';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                  sizedBoxH20,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate() &&
                          imgProvider.img != null) {
                        submit(context);
                        imgProvider.isVisible = false;
                      } else {
                        imgProvider.visible(imgProvider.img);
                      }
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
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
        return ImagePickerWidge(ctx: ctx);
      },
    );
  }

  void submit(context) async {
    ScaffoldMessenger.of(context).showSnackBar(type == ActionType.addScreen
        ? customSnackBar('Adding Data..', Colors.green)
        : customSnackBar('Updating Data..', Colors.green));
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final studentModel = StudentModel(
      name: _nameController.text,
      age: _ageController.text,
      domain: _domainController.text,
      number: _numberController.text,
      image: Provider.of<ImageProvder>(context, listen: false).img!.path,
      id: type == ActionType.addScreen
          ? DateTime.now().microsecondsSinceEpoch.toString()
          : idKey!,
    );
    type == ActionType.addScreen
        ? Provider.of<StudentsProvider>(context, listen: false)
            .add(studentModel)
        : Provider.of<StudentsProvider>(context, listen: false)
            .update(idKey!, studentModel);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false,
    );
  }
}
