import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_one/model/enum.dart';

import '../../add&edit_student/add_screen.dart';

class SwitcherWidget extends StatelessWidget {
  const SwitcherWidget({
    super.key,
    required this.searchValue,
    required this.searchController,
  });

  final dynamic searchValue;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
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
                                builder: (context) => AddScreen(
                                  type: ActionType.addScreen,
                                ),
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
                  onChanged: ((value) => searchValue.searchStudent(value)),
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
  }
}
