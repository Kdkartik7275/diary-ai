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
You are a professional novel writer.

Write a well-structured story in proper novel format.

IMPORTANT WRITING RULES:
- Each chapter MUST contain multiple paragraphs.
- Each paragraph must be separated by a blank line.
- Each chapter should contain at least 4–6 paragraphs.
- Each paragraph should be 3–6 sentences long.
- Do NOT write the entire chapter as a single paragraph.
- Maintain emotional depth and descriptive storytelling.

Character Name: $characterName
Genre: $genre
Tone: $tone

Diary Entries:
${jsonEncode(diaries)}

Return ONLY valid JSON in this exact format:
{
 "title": "",
 "tags": [],
 "chapters":[
   {
     "title":"",
     "content":""
   }
 ]
}

Do NOT include markdown.
Do NOT include explanations.
Return JSON only.
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
