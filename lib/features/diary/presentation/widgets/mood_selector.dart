// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lifeline/config/constants/colors.dart';

class MoodSelector extends StatefulWidget {
  final String? initialEmoji; 
  final Function(String emoji) onSelected;

  const MoodSelector({
    super.key,
    this.initialEmoji,
    required this.onSelected,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String selectedEmoji = "";

final List<String> moodEmojis = [
  "😀", "😃", "😄", "😁", "😊", "🙂", "😌", "🤗",
  "🥳", "🎉", "🎊", "🤩", "😎",
  "😔", "😞", "😢", "😭",
  "😠", "😡", "🤬", "😤",
  "😴", "🥱",
  "🤒", "🤕",
  "🤔", "😕", "😐",
  "😱", "😲",
  "❤️", "💕", "💖", "💘", "💗",
  "😇", "🙏",
  "✈️", "🌍", "🏖️", "🏝️", "🚗", "🏕️", "🗺️",
  "☕", "🍵", "🍔", "🍕", "🍟", "🍱", "🍩", "🍦",
  "💻", "📝", "📚", "💼", "📅"
];

@override
  void initState() {
    super.initState();
     selectedEmoji = widget.initialEmoji ?? ""; 
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: .1),
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: moodEmojis.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final emoji = moodEmojis[index];
          final isSelected = emoji == selectedEmoji;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedEmoji = emoji;
              });
              widget.onSelected(emoji);
            },
            child: Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
               
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ?  AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                  
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
