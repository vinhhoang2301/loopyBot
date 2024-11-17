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

  Future<List<PromptModel>> fetchPrompts(BuildContext context, {PromptCategory category = PromptCategory.all, String searchQuery = '', bool isFavourite = false}) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    String categoryQuery = category == PromptCategory.all ? '' : '&category=${category.toString().split('.').last}';
    String searchQueryParam = searchQuery.isEmpty ? '' : '&query=$searchQuery';
    String favouriteQuery = isFavourite ? '&isFavorite=true' : '';
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/prompts?offset=&limit=20&isPublic=true$categoryQuery$searchQueryParam$favouriteQuery'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      if (jsonResponse['items'] != null) {
        List<dynamic> promptsJson = jsonResponse['items'];
        promptsJson.forEach((json) {
          print('Title: ${json['title']}, IsFavourite: ${json['isFavorite']}');
        });
        return promptsJson.map((json) => PromptModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch prompts: ${response.reasonPhrase}');
    }
  }

  Future<List<PromptModel>> fetchPrivatePrompts(BuildContext context) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/prompts?offset=&limit=20&isFavorite=false&isPublic=false'));

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
      throw Exception('Failed to fetch private prompts: ${response.reasonPhrase}');
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
      print('Success: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to add favorite prompt: ${response.statusCode} - ${response.reasonPhrase}');
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
      print('Success: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      print('Failed to add private prompt: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: $responseBody');
    }
  }
}