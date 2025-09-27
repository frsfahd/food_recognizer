import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_recognizer/controller/home_provider.dart';
import 'package:food_recognizer/controller/image_classification_provider.dart';
import 'package:food_recognizer/controller/meal_db_query_provider.dart';
import 'package:food_recognizer/firebase_options.dart';
import 'package:food_recognizer/service/firebase_ml_service.dart';
import 'package:food_recognizer/service/http_service.dart';
import 'package:food_recognizer/service/image_classification_service.dart';
import 'package:food_recognizer/style/theme.dart';
import 'package:food_recognizer/ui/home_page.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseMlService()),
        Provider(
          create: (context) =>
              ImageClassificationService(context.read())..initModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageClassificationViewmodel(
            context.read<ImageClassificationService>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        Provider(create: (context) => HttpService()),
        ChangeNotifierProvider(
          create: (context) => MealDbQueryProvider(context.read<HttpService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recognizer',
      theme: FoodTheme.lightTheme,
      darkTheme: FoodTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: const HomePage(),
    );
  }
}
