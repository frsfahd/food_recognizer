import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recognizer/controller/home_provider.dart';
import 'package:food_recognizer/controller/meal_db_query_provider.dart';
import 'package:food_recognizer/model/meal_db_response.dart';
import 'package:food_recognizer/static/meal_db_quesry_state.dart';
import 'package:food_recognizer/widget/meal_recipe.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.mealName});

  final String mealName;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    final mealQueryProvider = context.read<MealDbQueryProvider>();

    Future.microtask(() {
      mealQueryProvider.fetchMealDetails(widget.mealName);
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
            QueryLoaded(mealData: var data) => DetailsView(meal: data),
            _ => SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({super.key, required this.meal});

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
