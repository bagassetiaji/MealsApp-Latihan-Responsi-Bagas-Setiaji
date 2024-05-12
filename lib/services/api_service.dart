import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static Future<List<Category>> fetchCategories() async {
    final response =
    await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['categories'];
      return List<Category>.from(data.map((category) => Category(
        idCategory: category['idCategory'],
        nameCategory: category['strCategory'],
        categoryThumb: category['strCategoryThumb'],
        categoryDescription: category['strCategoryDescription'],
      )));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'];
      return List<Meal>.from(data.map((meal) => Meal(
        idMeal: meal['idMeal'],
        nameMeal: meal['strMeal'],
        mealThumb: meal['strMealThumb'],
      )));
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<MealDetail> fetchMealDetail(String mealId) async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'][0];
      return MealDetail(
        idMeal: data['idMeal'],
        meal: data['strMeal'],
        category: data['strCategory'],
        mealThumb: data['strMealThumb'],
        instructions: data['strInstructions'],
      );
    } else {
      throw Exception('Failed to load meal detail');
    }
  }
}