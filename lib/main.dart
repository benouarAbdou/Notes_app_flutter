import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes/controllers/NoteController.dart';
import 'package:notes/controllers/ThemeController.dart';

import 'package:notes/pages/homePage.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // Initialize GetX controllers
  Get.put(NoteController());
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: themeController.isDarkMode.value
            ? const Color(0xFF0D1333)
            : Colors.white,
      ));

      return GetMaterialApp(
        title: "My notes",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blueAccent),
          brightness: themeController.isDarkMode.value
              ? Brightness.dark
              : Brightness.light,
          primaryColor:
              themeController.isDarkMode.value ? Colors.black : Colors.white,
          scaffoldBackgroundColor: themeController.isDarkMode.value
              ? const Color(0xFF0D1333)
              : Colors.white,
          cardColor: themeController.isDarkMode.value
              ? const Color(0xFF242947)
              : const Color(0xffEFF2F9),
          appBarTheme: AppBarTheme(
            backgroundColor:
                themeController.isDarkMode.value ? Colors.black : Colors.white,
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black),
            bodyMedium: TextStyle(
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black),
          ),
        ),
        home: const MyHomePage(),
      );
    });
  }
}
