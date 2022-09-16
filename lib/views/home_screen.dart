import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_one/providers/search_provider.dart';
import 'package:sample_one/views/add_screen.dart';
import 'package:sample_one/views/studentview_screen.dart';

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
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: searchValue.visible == false
                    ? Container(
                        key: const Key('1'),
                        width: double.infinity,
                        height: 70,
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                'STUDENTS',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      searchValue.searchOnOff(true);
                                    },
                                    icon: const Icon(Icons.search),
                                    iconSize: 30,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 70,
                        width: double.infinity,
                        key: const Key('2'),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: TextField(
                            controller: searchController,
                            onChanged: ((value) =>
                                searchValue.searchStudent(value)),
                            decoration: InputDecoration(
                              hintText: 'Search Student',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  searchValue.searchOnOff(false);
                                  searchValue.searchStudent('');
                                },
                                child: const Icon(
                                  CupertinoIcons.xmark_circle,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
