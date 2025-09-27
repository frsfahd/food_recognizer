import 'package:flutter/material.dart';
import 'package:food_recognizer/service/http_service.dart';
import 'package:food_recognizer/static/meal_db_quesry_state.dart';

class MealDbQueryProvider extends ChangeNotifier {
  final HttpService _httpService;
  MealDbQueryProvider(this._httpService);

  MealDbQuesryState _resultState = QueryNoneState();
  MealDbQuesryState get resultState => _resultState;

  Future<void> fetchMealDetails(String mealName) async {
    try {
      _resultState = QueryLoading();
      notifyListeners();

      final result = await _httpService.fetchMeal(mealName);

      if (result.meals!.isEmpty) {
        _resultState = QueryError("no matching meal found");
        notifyListeners();
      } else {
        _resultState = QueryLoaded(result.meals!.first);
        notifyListeners();
      }
    } catch (e) {
      _resultState = QueryError(e.toString());
      notifyListeners();
    }
  }
}
