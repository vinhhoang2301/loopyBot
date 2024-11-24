import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:final_project/consts/api.dart';
import 'package:final_project/services/authen_service.dart'; 
import 'package:final_project/models/prompt_model.dart';

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
  final String baseUrl = devServer;

  Future<List<PromptModel>> fetchPrompts(
    BuildContext context, {
    PromptCategory category = PromptCategory.all,
    String searchQuery = '',
    bool isFavorite = false,
    bool isPublic = true,
  }) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    String categoryQuery = category == PromptCategory.all ? '' : '&category=${category.toString().split('.').last}';
    String searchQueryParam = searchQuery.isEmpty ? '' : '&query=$searchQuery';
    String favoriteQuery = isFavorite ? '&isFavorite=true' : '';
    String publicQuery = isPublic ? '&isPublic=true' : '&isPublic=false';
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/prompts?offset=&limit=20$categoryQuery$searchQueryParam$favoriteQuery$publicQuery'));

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

  Future<void> addFavoritePrompt(BuildContext context, String promptId) async {
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
      
      log('Success add favorite: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      
      log('Failed to add favorite prompt: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
    }
  }

  Future<void> removeFavoritePrompt(BuildContext context, String promptId) async {
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
      
      log('Success REMOVE: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      
      log('Failed to remove favorite prompt: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
    }
  }

  Future<void> addPrivatePrompt(
    BuildContext context,
    String title,
    String prompt,
    String description,
  ) async {
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
      
      log('Success add: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      
      log('Failed to add private prompt: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
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
      
      log('Success delete: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      
      log('Failed to delete private prompt: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
    }
  }

  Future<void> updatePrivatePrompt(
    BuildContext context,
    String promptId,
    String title,
    String content,
    String description,
  ) async {
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
      
      log('Success update: $responseBody');
    } else {
      String responseBody = await response.stream.bytesToString();
      
      log('Failed to update prompt: ${response.statusCode} - ${response.reasonPhrase}');
      log('Response body: $responseBody');
    }
  }

  Future<List<PromptModel>> fetchPromptsByPartialTitle(
    BuildContext context,
    String partialTitle,
  ) async {
    final accessToken = await AuthenticationService.getAccessToken(context);

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/prompts?query=$partialTitle'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> jsonResponse = json.decode(responseBody)['items'];
      
      return jsonResponse.map((item) => PromptModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch prompts: ${response.reasonPhrase}');
    }
  }
}