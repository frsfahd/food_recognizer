import 'package:food_recognizer/model/meal_db_response.dart';

sealed class MealDbQuesryState {}

class QueryNoneState extends MealDbQuesryState {}

class QueryLoading extends MealDbQuesryState {}

class QueryError extends MealDbQuesryState {
  final String error;
  QueryError(this.error);
}

class QueryLoaded extends MealDbQuesryState {
  final Meal mealData;
  QueryLoaded(this.mealData);
}
