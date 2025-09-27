import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:food_recognizer/model/meal_db_response.dart';

class HttpService {
  static const String _baseUrl =
      "https://www.themealdb.com/api/json/v1/1/search.php?s=";

  Future<MealDbResponse> fetchMeal(String mealName) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + mealName));
      if (response.statusCode == 200) {
        return mealDbResponseFromJson(response.body);
      }

      throw ("failed to load meal details");
    } catch (e) {
      if (e is SocketException) {
        throw ('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        throw ('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        throw ('Failed to load response data.');
      } else {
        throw ("Caught an error: $e");
      }
    }
  }
}
