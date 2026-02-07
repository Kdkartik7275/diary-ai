// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';

class StoryReadingView extends StatefulWidget {
  const StoryReadingView({
    super.key,
    required this.story,
    required this.authorName,
    this.authorProfileUrl,
    required this.authorId,
  });

  final StoryEntity story;
  final String authorName;
  final String? authorProfileUrl;
  final String authorId;

  @override
  State<StoryReadingView> createState() => _StoryReadingViewState();
}

class _StoryReadingViewState extends State<StoryReadingView> {
  late final List<_ReaderPage> pages;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pages = _buildPages();
  }

  List<_ReaderPage> _buildPages() {
    final result = <_ReaderPage>[];

    for (int i = 0; i < widget.story.chapters.length; i++) {
      final chapter = widget.story.chapters[i];
      final chapterPages = _paginateContent(chapter.content);

      for (final pageContent in chapterPages) {
        result.add(
          _ReaderPage(
            chapterNumber: i + 1,
            chapterTitle: chapter.title,
            content: pageContent,
          ),
        );
      }
    }

    return result;
  }

  List<String> _paginateContent(String content, {int wordsPerPage = 250}) {
    final words = content.split(RegExp(r'\s+'));
    final pages = <String>[];

    for (int i = 0; i < words.length; i += wordsPerPage) {
      pages.add(words.skip(i).take(wordsPerPage).join(' '));
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final page = pages[currentPage];

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: .3),
                child: widget.authorProfileUrl != null
                    ? ClipOval(
                        child: Image.network(
                          widget.authorProfileUrl!,
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                widget.authorName.substring(0, 2),
                                style: theme.titleSmall!.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          widget.authorName.substring(0, 2),
                          style: theme.titleSmall!.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
              ),
              title: Text(widget.authorName, style: theme.titleLarge),
              subtitle: Text(
                DateFormat(
                  'MMM dd, yyyy',
                ).format(widget.story.publishedAt!.toDate()),
                style: theme.titleSmall!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.textLighter,
                ),
              ),
              trailing: ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {},
                child: Text(
                  'Follow',
                  style: theme.titleLarge!.copyWith(color: AppColors.white),
                ),
              ),
            ),
            Row(
              children: [
                TRoundedContainer(
                  radius: 12,
                  backgroundColor: AppColors.primary.withValues(alpha: .1),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    widget.story.tags.first,
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '${widget.story.chapters.length} chapters   •   ${2145} likes',
                  style: theme.titleSmall!.copyWith(
                    color: AppColors.textLighter,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: AppColors.border.withValues(alpha: .4)),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'Chapter ${page.chapterNumber}: ${page.chapterTitle}',
                textAlign: TextAlign.start,
                style: theme.titleMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        page.content,
                        style: theme.titleLarge!.copyWith(
                          height: 1.7,
                          color: AppColors.textLighter,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: currentPage > 0
                                  ? () => setState(() => currentPage--)
                                  : null,
                              child: Text(
                                'Previous',
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: currentPage > 0
                                      ? AppColors.primary
                                      : AppColors.textLighter,
                                ),
                              ),
                            ),
                            Text(
                              '${currentPage + 1} of ${pages.length}',
                              style: theme.titleSmall,
                            ),
                            TextButton(
                              onPressed: currentPage < pages.length - 1
                                  ? () => setState(() => currentPage++)
                                  : null,
                              child: Text(
                                'Next',
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: currentPage < pages.length - 1
                                      ? AppColors.primary
                                      : AppColors.textLighter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 12),
        color: AppColors.white,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.favorite_border, color: AppColors.border),
                Text(
                  '2134',
                  style: theme.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColors.textLighter,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(CupertinoIcons.chat_bubble, color: AppColors.border),
                Text(
                  '214',
                  style: theme.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColors.textLighter,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(Icons.bookmark_border, color: AppColors.border),
                Text(
                  'Save',
                  style: theme.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColors.textLighter,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderPage {
  final String chapterTitle;
  final String content;
  final int chapterNumber;

  const _ReaderPage({
    required this.chapterTitle,
    required this.content,
    required this.chapterNumber,
  });
}
