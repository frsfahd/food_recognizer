import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recognizer/controller/home_provider.dart';
import 'package:food_recognizer/controller/image_classification_provider.dart';
import 'package:food_recognizer/controller/meal_db_query_provider.dart';
import 'package:food_recognizer/model/meal_db_response.dart';
import 'package:food_recognizer/static/meal_db_quesry_state.dart';
import 'package:food_recognizer/widget/meal_recipe.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    final mealQueryProvider = context.read<MealDbQueryProvider>();
    final imageProvider = context.read<ImageClassificationViewmodel>();

    Future.microtask(() {
      mealQueryProvider.fetchMealDetails(
        imageProvider.classifications.keys.first,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final imageProvider = context.read<ImageClassificationViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<MealDbQueryProvider>(
          builder: (context, provider, _) {
            return switch (provider.resultState) {
              QueryLoaded(mealData: var data) => Text(data.strMeal!),
              _ => Text("Food Details"),
            };
          },
        ),
      ),
      body: Consumer<MealDbQueryProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            QueryLoading() => const Center(child: CircularProgressIndicator()),
            QueryError(error: var message) => Center(child: Text(message)),
            QueryLoaded(mealData: var data) => ResultView(meal: data),
            _ => SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class ResultView extends StatelessWidget {
  const ResultView({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeProvider>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: meal.strMealThumb != null
                  ? Image.network(meal.strMealThumb!, fit: BoxFit.contain)
                  : Image.file(
                      File(homeProvider.imagePath.toString()),
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 16),
            MealRecipe(meal: meal),
          ],
        ),
      ),
    );
  }
}
