import 'package:flutter/material.dart';
import 'package:food_recognizer/model/meal_db_response.dart';

class MealRecipe extends StatelessWidget {
  const MealRecipe({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ingredients",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(thickness: 2, height: 24),
          ..._buildIngredientsList(),
          const SizedBox(height: 32),
          Text(
            "Instructions",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(thickness: 2, height: 24),
          Text(meal.strInstructions ?? "-"),
        ],
      ),
    );
  }

  List<Widget> _buildIngredientsList() {
    final List<Widget> ingredients = [];

    final mealJson = meal.toJson();

    for (int i = 1; i <= 20; i++) {
      final ingredient = mealJson['strIngredient$i'];
      final measure = mealJson['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 2, child: Text(ingredient.toString())),
                Expanded(flex: 1, child: Text(measure?.toString() ?? "-")),
              ],
            ),
          ),
        );
      }
    }

    return ingredients;
  }
}
