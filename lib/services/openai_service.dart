import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  late final String _apiKey;

  OpenAIService() {
    _apiKey = const String.fromEnvironment('OPENAI_API_KEY');
    if (_apiKey.isEmpty) {
      if (kDebugMode) {
        print(
            'WARNING: OPENAI_API_KEY is not configured. Please check your env.json file.');
      }
    }
  }

  Future<String?> getChatCompletion({
    required String message,
    required String systemPrompt,
  }) async {
    if (_apiKey.isEmpty || _apiKey == 'your-openai-api-key-here') {
      return _getOfflineResponse(message);
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': systemPrompt,
            },
            {
              'role': 'user',
              'content': message,
            }
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String?;
      } else if (response.statusCode == 401) {
        if (kDebugMode) {
          print('OpenAI API Error: Invalid API key');
        }
        return _getOfflineResponse(message);
      } else {
        if (kDebugMode) {
          print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        }
        return _getOfflineResponse(message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('OpenAI Service Error: $e');
      }
      return _getOfflineResponse(message);
    }
  }

  String _getOfflineResponse(String message) {
    final lowerMessage = message.toLowerCase();

    // Tree species responses
    if (lowerMessage.contains('acacia') ||
        lowerMessage.contains('drought') ||
        lowerMessage.contains('arid')) {
      return "Acacia trees are excellent for Northern Kenya's arid climate. They're drought-resistant and help prevent soil erosion. Plant during the rainy season and water weekly for the first 3 months.";
    }

    if (lowerMessage.contains('baobab') ||
        lowerMessage.contains('water storage')) {
      return "Baobab trees are perfect for water storage and can survive extreme drought. They grow slowly but live for centuries. Plant in well-draining soil and avoid overwatering.";
    }

    if (lowerMessage.contains('moringa') ||
        lowerMessage.contains('nutrition')) {
      return "Moringa is a superfood tree that grows quickly in Northern Kenya. Its leaves are rich in vitamins and minerals. Plant in sandy soil with good drainage.";
    }

    // Care and maintenance responses
    if (lowerMessage.contains('water') || lowerMessage.contains('irrigation')) {
      return "In Northern Kenya's climate, water young trees 2-3 times per week during dry season. Use drip irrigation or mulching to conserve water. Morning watering is best.";
    }

    if (lowerMessage.contains('soil') ||
        lowerMessage.contains('plant') ||
        lowerMessage.contains('preparation')) {
      return "Prepare soil by digging holes 60cm deep and wide. Mix with compost or manure. In clay soil, add sand for drainage. In sandy soil, add organic matter for retention.";
    }

    if (lowerMessage.contains('disease') || lowerMessage.contains('pest')) {
      return "Common tree diseases in Northern Kenya include root rot and leaf blight. Ensure proper drainage and avoid overwatering. For pest control, neem oil is an effective organic solution.";
    }

    if (lowerMessage.contains('fertilizer') ||
        lowerMessage.contains('nutrients')) {
      return "For Northern Kenya's alkaline soils, use organic compost mixed with phosphorus-rich fertilizers. Avoid nitrogen-heavy fertilizers during dry seasons.";
    }

    // General responses
    return "I can help you with information about tree species suitable for Northern Kenya, including Acacia, Baobab, and Moringa trees. I can also provide guidance on watering, soil preparation, and general tree care. What specific topic would you like to know more about?";
  }

  List<String> getQuickReplies(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('acacia')) {
      return ["Acacia varieties", "Planting season", "Pruning tips"];
    }

    if (lowerMessage.contains('baobab')) {
      return ["Baobab benefits", "Growth rate", "Harvesting"];
    }

    if (lowerMessage.contains('moringa')) {
      return ["Moringa nutrition", "Leaf harvesting", "Seed planting"];
    }

    if (lowerMessage.contains('water') || lowerMessage.contains('irrigation')) {
      return ["Irrigation methods", "Water conservation", "Drought management"];
    }

    if (lowerMessage.contains('soil')) {
      return ["Composting guide", "Soil testing", "Organic fertilizers"];
    }

    return ["Tree species", "Care tips", "Climate advice", "Planting guide"];
  }

  String get systemPrompt => '''
You are MitiBot, an AI assistant specialized in tree care and environmental conservation for Northern Kenya. You help people with:

1. Tree species selection for arid and semi-arid regions
2. Planting and care instructions
3. Water management and conservation
4. Soil preparation and improvement
5. Disease and pest management
6. Climate-appropriate agricultural practices

Focus on practical, actionable advice suitable for Northern Kenya's climate. Prioritize drought-resistant species like Acacia, Baobab, and Moringa. Keep responses concise but informative.

Always consider:
- Limited water resources
- High temperatures and low rainfall
- Local soil conditions
- Sustainable farming practices
- Community-based conservation efforts

Respond in a friendly, helpful tone and encourage environmental stewardship.
''';
}
