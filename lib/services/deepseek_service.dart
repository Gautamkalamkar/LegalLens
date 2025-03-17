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
        maxTokens: 500,
      ),
    );

    return response.choices.first.message.content;
  }
}
