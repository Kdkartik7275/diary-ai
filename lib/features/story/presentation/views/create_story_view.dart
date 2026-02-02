// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/presentation/widgets/date_field.dart';
import 'package:lifeline/features/story/presentation/widgets/genre_selector.dart';

class CreateStoryView extends StatelessWidget {
  const CreateStoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    List tones = ['Emotional', 'Dramatic', 'Light', 'Humorous'];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),

          children: [
            Text(
              'Create Your Story',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Transform your diary into a magical tale',
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textLighter,
              ),
            ),
            SizedBox(height: height * 0.02),

            _MainContainer(
              width: width,
              height: height,
              title: 'Date Range',
              icon: Icons.calendar_month_outlined,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(height: height * .05, child: DateField()),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(height: height * .05, child: DateField()),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            _MainContainer(
              width: width,
              height: height,
              title: 'Story Style',
              icon: CupertinoIcons.wand_stars,
              child: const GenreSelector(),
            ),
            SizedBox(height: height * 0.02),
            _MainContainer(
              width: width,
              height: height,
              title: 'Main Character Name',
              icon: CupertinoIcons.person,
              child: SizedBox(
                height: height * .05,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter main character name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            _MainContainer(
              width: width,
              height: height,
              title: 'Story Tone',
              icon: Icons.emoji_emotions_outlined,
              child: GridView.builder(
                itemCount: tones.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.8,
                ),
                itemBuilder: (_, index) {
                  final tone = tones[index];
                  return TRoundedContainer(
                    showBorder: true,
                    radius: 16,
                    alignment: Alignment.center,
                    child: Text(
                      tone,
                      style: theme.titleLarge!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.03),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              height: height * .05,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primary,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.wand_stars, color: AppColors.white),
                  SizedBox(width: 10),
                  Text(
                    'Generate Story Book',
                    style: theme.titleLarge!.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}

class _MainContainer extends StatelessWidget {
  const _MainContainer({
    required this.width,
    required this.height,
    required this.title,
    required this.icon,
    required this.child,
  });

  final double width;

  final double height;
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return TRoundedContainer(
      width: width,

      padding: EdgeInsets.all(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .07),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              SizedBox(width: width * 0.02),
              Text(title, style: theme.titleLarge),
            ],
          ),
          SizedBox(height: height * 0.02),
          child,
        ],
      ),
    );
  }
}
