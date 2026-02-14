import 'dart:convert';
import 'package:http/http.dart' as http;

class AIStoryService {
  final String apiKey;

  AIStoryService({required this.apiKey});

  Future<Map<String, dynamic>> generateStory({
    required List<Map<String, dynamic>> diaries,
    required String genre,
    required String tone,
    required String characterName,
  }) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final prompt =
        """
You are a professional story writer.

Generate a structured story JSON ONLY.

Character Name: $characterName
Genre: $genre
Tone: $tone

Diary Entries:
${jsonEncode(diaries)}

Return JSON ONLY in this format:
{
 "title": "",
 "tags": [],
 "chapters":[
   {"title":"","content":""}
 ]
}
""";

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-5-nano",
        "messages": [
          {"role": "user", "content": prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw "AI generation failed: ${response.body}";
    }

    final data = jsonDecode(response.body);

    final text = data["choices"][0]["message"]["content"];

    return jsonDecode(text);
  }
}
