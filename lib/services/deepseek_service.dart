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
        model: 'deepseek/deepseek-chat:free',
        messages: [
          ChatMessage(
            role: 'user',
            content: text,
          ),
          ChatMessage(role: 'system', content: prompt)
        ],
        temperature: 0.7,
        maxTokens: 100,
      ),
    );

    return response.choices.first.message.content;
  }
}
