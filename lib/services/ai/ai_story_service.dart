// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AIStoryService {
//   AIStoryService({required this.apiKey});
//   final String apiKey;

//   Future<Map<String, dynamic>> generateStory({
//     required List<Map<String, dynamic>> diaries,
//     required String genre,
//     required String tone,
//     required String characterName,
//     String? summary, // Optional user summary
//   }) async {
//     final url = Uri.parse('https://api.openai.com/v1/chat/completions');

//     final summarySection = summary != null && summary.trim().isNotEmpty
//         ? '''
// USER'S PERSONAL CONTEXT (use this to deeply understand their emotional world):
// """
// $summary
// """
// '''
//         : '';

//     final prompt =
//         '''
// You are an award-winning novelist with a gift for transforming real human experiences into deeply moving fiction.

// Your task is to write a ${genre} story with a ${tone} tone, inspired by real diary entries from a person's life.
// The main character's name is $characterName.

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// STORYTELLING PRINCIPLES — FOLLOW STRICTLY:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// EMOTIONAL DEPTH:
// - Translate raw diary emotions into vivid inner monologue and sensory experience.
// - Show feelings through action, body language, and environment — not just statements.
// - Let $characterName's vulnerability, fear, joy, or longing breathe through every scene.
// - Use the "show, don't tell" technique relentlessly.

// NARRATIVE CRAFT:
// - Write in a flowing, literary prose style — not a journal retelling.
// - Each chapter must feel like a scene with a beginning, emotional arc, and resonant ending.
// - Use metaphors, sensory details (sight, sound, smell, touch), and atmospheric description.
// - Build tension and release across chapters — not every chapter should feel the same emotionally.

// STRUCTURE RULES:
// - Each chapter MUST contain 5–7 well-developed paragraphs.
// - Each paragraph must be 4–6 sentences long and separated by a blank line.
// - Never write a chapter as a single block of text.
// - Each chapter should have its own emotional color (e.g., hopeful, tense, bittersweet).

// CHARACTER CONSISTENCY:
// - $characterName should feel like a real, flawed, lovable human being.
// - Reflect their inner world consistently — their habits, fears, desires, and growth.
// - Secondary characters, if any, should feel distinct and purposeful.

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// INPUT DATA:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// $summarySection

// DIARY ENTRIES (the raw emotional source material):
// ${jsonEncode(diaries)}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// OUTPUT FORMAT:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Return ONLY valid JSON in this exact format. No markdown. No explanation. JSON only.

// {
//   "title": "A compelling, evocative story title",
//   "tags": ["tag1", "tag2", "tag3"],
//   "chapters": [
//     {
//       "title": "Chapter title that hints at emotional theme",
//       "content": "Full chapter content with paragraphs separated by \\n\\n"
//     }
//   ]
// }
// ''';

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: jsonEncode({
//         'model': 'gpt-5-nano',
//         'messages': [
//           {
//             'role': 'system',
//             'content':
//                 'You are an award-winning novelist. You only respond with valid JSON. Never include markdown, code blocks, or explanations.',
//           },
//           {'role': 'user', 'content': prompt},
//         ],
//         'temperature': 0.85, // Slightly creative but coherent
//         'presence_penalty': 0.3, // Encourages varied vocabulary
//         'frequency_penalty': 0.3, // Reduces repetitive phrasing
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw 'AI generation failed: ${response.body}';
//     }

//     final data = jsonDecode(response.body);
//     final text = data['choices'][0]['message']['content'] as String;

//     // Safely strip accidental markdown fences if model misbehaves
//     final cleaned = text
//         .trim()
//         .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
//         .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
//         .replaceAll(RegExp(r'```$', multiLine: true), '')
//         .trim();

//     return jsonDecode(cleaned);
//   }
// }


import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AIStoryService {
  AIStoryService({required this.apiKey});
  final String apiKey;

  Future<Map<String, dynamic>> generateStory({
    required List<Map<String, dynamic>> diaries,
    required String genre,
    required String tone,
    required String characterName,
    String? summary,
  }) async {
    debugPrint('Generating story with ${diaries.length} diary entries, genre: $genre, tone: $tone, character: $characterName');
    debugPrint('User summary provided: ${summary != null && summary.trim().isNotEmpty}');

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final summarySection = summary != null && summary.trim().isNotEmpty
        ? '''
USER'S PERSONAL CONTEXT (use this to deeply understand their emotional world):
"""
$summary
"""
'''
        : '';

    final prompt = '''
You are an award-winning novelist with a gift for transforming real human experiences into deeply moving fiction.

Your task is to write a $genre story with a $tone tone, inspired by real diary entries from a person's life.
The main character's name is $characterName.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STORYTELLING PRINCIPLES — FOLLOW STRICTLY:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EMOTIONAL DEPTH:
- Translate raw diary emotions into vivid inner monologue and sensory experience.
- Show feelings through action, body language, and environment — not just statements.
- Let $characterName's vulnerability, fear, joy, or longing breathe through every scene.
- Use the "show, don't tell" technique relentlessly.

NARRATIVE CRAFT:
- Write in a flowing, literary prose style — not a journal retelling.
- Each chapter must feel like a scene with a beginning, emotional arc, and resonant ending.
- Use metaphors, sensory details (sight, sound, smell, touch), and atmospheric description.
- Build tension and release across chapters — not every chapter should feel the same emotionally.

STRUCTURE RULES:
- Each chapter MUST contain 5–7 well-developed paragraphs.
- Each paragraph must be 4–6 sentences long and separated by a blank line.
- Never write a chapter as a single block of text.
- Each chapter should have its own emotional color (e.g., hopeful, tense, bittersweet).

CHARACTER CONSISTENCY:
- $characterName should feel like a real, flawed, lovable human being.
- Reflect their inner world consistently — their habits, fears, desires, and growth.
- Secondary characters, if any, should feel distinct and purposeful.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
INPUT DATA:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$summarySection

DIARY ENTRIES (the raw emotional source material):
${jsonEncode(diaries)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT FORMAT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Return ONLY valid JSON in this exact format. No markdown. No explanation. JSON only.

{
  "title": "A compelling, evocative story title",
  "tags": ["tag1", "tag2", "tag3"],
  "chapters": [
    {
      "title": "Chapter title that hints at emotional theme",
      "content": "Full chapter content with paragraphs separated by \\n\\n"
    }
  ]
}
''';

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an award-winning novelist. You only respond with valid JSON. Never include markdown, code blocks, or explanations.',
          },
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.85,
        'max_tokens': 8000,
      }),
    );

    debugPrint('Groq API status: ${response.statusCode}');
    debugPrint('📦 Raw body: ${response.body.substring(0, response.body.length.clamp(0, 300))}');

    if (response.statusCode != 200) {
      debugPrint('❌ Groq error: ${response.body}');
      throw 'AI generation failed: ${response.body}';
    }

    final data = jsonDecode(response.body);
    final text = data['choices'][0]['message']['content'] as String;

    debugPrint('📦 Raw AI response length: ${text.length}');

    final cleaned = text
        .trim()
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .replaceAll(RegExp(r'```$', multiLine: true), '')
        .trim();

    return jsonDecode(cleaned);
  }
}