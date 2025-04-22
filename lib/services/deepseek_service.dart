// import 'package:deepseek_api/deepseek_api.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class DeepseekService {
  Future<String> accessDeepseek(String text, String prompt) async {
    const url = 'https://openrouter.ai/api/v1/chat/completions';
    const apiKey =
        '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';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json', // optional but recommended
      },
      body: jsonEncode({
        'model': 'deepseek/deepseek-chat:free',
        'messages': [
          {'role': 'system', 'content': prompt},
          {'role': 'user', 'content': text},
        ],
        'temperature': 0.7,
        'max_tokens': 400,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed: ${response.statusCode} ${response.body}');
    }

    final json = jsonDecode(response.body);
    return json['choices'][0]['message']['content'];
  }
}
