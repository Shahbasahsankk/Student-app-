import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_one/contants/constants.dart';
import 'package:sample_one/providers/search_provider.dart';
import 'package:sample_one/views/home/widgets/animated_swither.dart';
import 'package:sample_one/views/studentview/studentview_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SearchProvider>(context, listen: false).searchStudent('');
    });
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Consumer<SearchProvider>(builder: (context, searchValue, _) {
              return SwitcherWidget(
                searchController: searchController,
                searchValue: searchValue,
              );
            }),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (BuildContext context, SearchProvider searchValue,
                    Widget? child) {
                  return searchValue.foundStudents.isEmpty
                      ? Center(
                          child: Text(searchValue.visible == true
                              ? 'No Student Found'
                              : 'No Student Data'),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => StudentviewScreen(
                                        name: searchValue
                                            .foundStudents[index].name,
                                        age: searchValue
                                            .foundStudents[index].age,
                                        number: searchValue
                                            .foundStudents[index].number,
                                        domain: searchValue
                                            .foundStudents[index].domain,
                                        image: searchValue
                                            .foundStudents[index].image,
                                        index: index,
                                        id: searchValue.foundStudents[index].id,
                                      ),
                                    ),
                                  );
                                },
                                title:
                                    Text(searchValue.foundStudents[index].name),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: FileImage(
                                    File(
                                        searchValue.foundStudents[index].image),
                                  ),
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    await delete(
                                        searchValue.foundStudents[index].id,
                                        context);
                                  },
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: searchValue.foundStudents.length,
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> delete(id, context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('File will be Permenently deleted, Continue?'),
          actions: [
            TextButton(
              onPressed: () {
                final search =
                    Provider.of<SearchProvider>(context, listen: false);
                search.delete(id);
                search.searchStudent(searchController.text);
                ScaffoldMessenger.of(context)
                    .showSnackBar(customSnackBar('Deleted', Colors.red));
                Navigator.of(ctx).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('No'),
            )
          ],
        );
      },
    );
  }
}
