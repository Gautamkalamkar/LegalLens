import 'package:deepseek_api/deepseek_api.dart';

class DeepseekService {
  Future<String> accessDeepseek(String text, String prompt) async {
    final deepseek = DeepSeekAPI(
      apiKey:
          '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',
      baseUrl: 'https://openrouter.ai/api/v1',
    );

    // Create a chat completion request
    final response = await deepseek.createChatCompletion(
      ChatCompletionRequest(
        model: 'deepseek/deepseek-chat',
        messages: [
          ChatMessage(
            role: 'user',
            content: text,
          ),
          ChatMessage(role: 'system', content: prompt)
        ],
        temperature: 0.7,
        maxTokens: 500,
      ),
    );

    return response.choices.first.message.content;
  }
}
