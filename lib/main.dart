import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taxi_fare/models/history.dart';
import 'package:taxi_fare/utils/colors.dart';
import 'package:taxi_fare/models/boxes.dart';
import 'package:taxi_fare/models/user.dart';
import 'package:taxi_fare/navigation/app_navigation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(HiveBoxes.user);
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(CalculationResultAdapter());
  await Hive.openBox<History>(HiveBoxes.history);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tugas Akhir TPM',
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      routerConfig: AppNavigation.router,
    );
  }
}