import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel model;

  GeminiService(String apiKey)
      : model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: apiKey,
        );

  /// Ask Gemini to respond with structured JSON for GenUI
  Future<String> generateOceanResponse(String userQuery) async {
    final prompt = '''
You are an ocean exploration assistant. 
When the user asks a question about the ocean, respond ONLY with a JSON schema 
that defines a GenUI component tree to visualize the data.

Example:
{
  "type": "chart",
  "data": {
    "title": "North Sea Temperature (°C)",
    "x": ["Week 1", "Week 2", "Week 3"],
    "y": [4.2, 4.5, 5.1, 5.8]
  }
}

User question: "$userQuery"
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? '{}';
  }
}
