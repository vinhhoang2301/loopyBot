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

  Future<List<PromptModel>> fetchPrompts(BuildContext context, {PromptCategory category = PromptCategory.all, String searchQuery = '', bool isFavourite = false, bool isPublic = true}) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    String categoryQuery = category == PromptCategory.all ? '' : '&category=${category.toString().split('.').last}';
    String searchQueryParam = searchQuery.isEmpty ? '' : '&query=$searchQuery';
    String favouriteQuery = isFavourite ? '&isFavorite=true' : '';
    String publicQuery = isPublic ? '&isPublic=true' : '&isPublic=false';
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/prompts?offset=&limit=20$categoryQuery$searchQueryParam$favouriteQuery$publicQuery'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
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

  Future<void> addFavouritePrompt(BuildContext context, String promptId) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/prompts/$promptId/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      print('Success add favourite: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to add favorite prompt: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: $responseBody');
    }
  }

  Future<void> removeFavouritePrompt(BuildContext context, String promptId) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.Request('DELETE', Uri.parse('$baseUrl/api/v1/prompts/$promptId/favorite'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      print('Success REMOVE: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to remove favorite prompt: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: $responseBody');
    }
  }

  Future<void> addPrivatePrompt(BuildContext context, String title, String prompt, String description) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'title': title,
      'content': prompt,
      'description': description,
      'isPublic': false,
    });

    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/prompts'));

    request.headers.addAll(headers);
    request.body = body;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      print('Success add: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to add private prompt: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: $responseBody');
    }
  }

  Future<void> deletePrivatePrompt(BuildContext context, String promptId) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.Request('DELETE', Uri.parse('$baseUrl/api/v1/prompts/$promptId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      print('Success delete: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to delete private prompt: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: $responseBody');
    }
  }

  Future<void> updatePrivatePrompt(BuildContext context, String promptId, String title, String content, String description) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'title': title,
      'content': content,
      'description': description,
      'category': "other",
      'language': "English",
      'isPublic': false,
    });

    var request = http.Request('PATCH', Uri.parse('$baseUrl/api/v1/prompts/$promptId'));

    request.headers.addAll(headers);
    request.body = body;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print('Success update: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to update prompt: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: $responseBody');
    }
  }
}