import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:final_project/consts/api.dart'; // Import the api.dart file
import 'package:final_project/services/authen_service.dart'; // Make sure to import the AuthenticationService
import 'package:final_project/models/prompt_model.dart'; // Import the PromptModel

enum PromptCategory {
  all,
  marketing,
  business,
  seo,
  writing,
  coding,
  career,
  chatbot,
  education,
  fun,
  productivity,
  other,
}

const Map<PromptCategory, String> promptCategoryLabels = {
  PromptCategory.all: 'All',
  PromptCategory.marketing: 'Marketing',
  PromptCategory.business: 'Business',
  PromptCategory.seo: 'SEO',
  PromptCategory.writing: 'Writing',
  PromptCategory.coding: 'Coding',
  PromptCategory.career: 'Career',
  PromptCategory.chatbot: 'Chatbot',
  PromptCategory.education: 'Education',
  PromptCategory.fun: 'Fun',
  PromptCategory.productivity: 'Productivity',
  PromptCategory.other: 'Other',
};

class PromptService {
  final String baseUrl = devServer; // Use devServer as the baseUrl

  Future<List<PromptModel>> fetchPrompts(BuildContext context, {PromptCategory category = PromptCategory.all, String searchQuery = ''}) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    String categoryQuery = category == PromptCategory.all ? '' : '&category=${category.toString().split('.').last}';
    String searchQueryParam = searchQuery.isEmpty ? '' : '&query=$searchQuery';
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/prompts?offset=&limit=20&isFavorite=false&isPublic=true$categoryQuery$searchQueryParam'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      if (jsonResponse['items'] != null) {
        List<dynamic> promptsJson = jsonResponse['items'];
        return promptsJson.map((json) => PromptModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch prompts: ${response.reasonPhrase}');
    }
  }
}