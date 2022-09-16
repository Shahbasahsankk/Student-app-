import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:sample_one/providers/image_provider.dart';
import 'package:sample_one/providers/search_provider.dart';
import 'package:sample_one/providers/students_provider.dart';
import 'package:sample_one/views/home/home_screen.dart';

import 'model/data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
    Hive.registerAdapter(StudentModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentsProvider()),
        ChangeNotifierProvider(create: (context) => ImageProvder()),
        ChangeNotifierProvider(create: (context) => SearchProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home:  HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
