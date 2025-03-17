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
