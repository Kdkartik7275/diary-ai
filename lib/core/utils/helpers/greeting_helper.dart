import 'dart:math';

class GreetingHelper {
  static final Random _random = Random();

  static final Map<String, List<String>> greetings = {
    'morning': [
      'Good Morning',
      'Rise and shine',
      'A fresh start awaits',
      'Morning vibes',
      'Hello sunshine',
    ],
    'afternoon': [
      'Good Afternoon',
      'Hope your day is going well',
      'Keep the momentum going',
      'A beautiful afternoon',
      'Stay inspired',
    ],
    'evening': [
      'Good Evening',
      'Winding down already?',
      'Evening reflections',
      'Time to relax',
      'Hope your day was great',
    ],
    'night': [
      'Good Night',
      'Late night thoughts?',
      'Reflect on your day',
      'Quiet night ahead',
      'Night journaling time',
    ],
  };

  static final List<String> subtitles = [
    'How was your day today?',
    'Ready to write something?',
    "What's on your mind today?",
    'Your thoughts matter here.',
    "Capture today's moments.",
    "Let's turn thoughts into stories.",
    'Time to reflect and write.',
    'Tell your story today.',
  ];

  static String getGreeting() {
    final hour = DateTime.now().hour;

    String period;

    if (hour >= 5 && hour < 12) {
      period = 'morning';
    } else if (hour >= 12 && hour < 17) {
      period = 'afternoon';
    } else if (hour >= 17 && hour < 21) {
      period = 'evening';
    } else {
      period = 'night';
    }

    final options = greetings[period]!;

    return options[_random.nextInt(options.length)];
  }

  static String getSubtitle() {
    return subtitles[_random.nextInt(subtitles.length)];
  }
}
