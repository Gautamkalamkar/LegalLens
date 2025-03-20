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
        maxTokens: 400,
      ),
    );

    return response.choices.first.message.content;
  }
}
