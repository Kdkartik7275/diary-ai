// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';

class DraftPreview extends StatefulWidget {
  const DraftPreview({super.key, required this.story});

  final StoryEntity story;

  @override
  State<DraftPreview> createState() => _DraftPreviewState();
}

class _DraftPreviewState extends State<DraftPreview> {
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

  List<String> _paginateContent(String content, {int charsPerPage = 1200}) {
    final pages = <String>[];

    for (int i = 0; i < content.length; i += charsPerPage) {
      int end = i + charsPerPage;

      if (end > content.length) {
        end = content.length;
      }

      pages.add(content.substring(i, end));
    }

    return pages;
  }

  String _formatUpdatedText({
    required Timestamp createdAt,
    Timestamp? updatedAt,
  }) {
    final date = (updatedAt ?? createdAt).toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Updated just now';
    if (diff.inHours < 1) return 'Last edited ${diff.inMinutes} min ago';
    if (diff.inDays < 1) return 'Last edited ${diff.inHours} hrs ago';
    if (diff.inDays == 1) return 'Last edited yesterday';
    return 'Last edited ${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final page = pages[currentPage];

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.story.title,
                  style: theme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.story.tags.first,
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      // ignore: avoid_types_as_parameter_names
                      '${widget.story.chapters.length} chapters • ${widget.story.chapters.fold<int>(0, (sum, chapter) => sum + chapter.content.trim().split(RegExp(r'\s+')).length)} words',
                      style: theme.titleSmall!.copyWith(
                        color: AppColors.textLighter,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textLighter,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatUpdatedText(
                        createdAt: widget.story.createdAt,
                        updatedAt: widget.story.updatedAt,
                      ),
                      style: theme.titleSmall!.copyWith(
                        color: AppColors.textLighter,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.border.withValues(alpha: .4)),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Chapter ${page.chapterNumber}: ${page.chapterTitle}',
              textAlign: TextAlign.start,
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                child: Text(
                  page.content,
                  style: theme.titleLarge!.copyWith(
                    height: 1.7,
                    color: AppColors.textLighter,
                  ),
                ),
              ),
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
                      color: AppColors.primary,
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
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
