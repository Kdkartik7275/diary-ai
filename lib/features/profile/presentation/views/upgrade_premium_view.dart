// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';

class UpgradePremiumView extends StatefulWidget {
  const UpgradePremiumView({super.key});

  @override
  State<UpgradePremiumView> createState() => _UpgradePremiumViewState();
}

class _UpgradePremiumViewState extends State<UpgradePremiumView>
    with SingleTickerProviderStateMixin {
  int _selectedPlan = 1;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _plans = [
    {
      'id': 0,
      'label': 'Monthly',
      'price': '\$4.99',
      'period': '/mo',
      'badge': null,
      'savings': null,
      'billed': 'Billed monthly',
    },
    {
      'id': 1,
      'label': 'Yearly',
      'price': '\$2.99',
      'period': '/mo',
      'badge': 'BEST VALUE',
      'savings': 'Save 40%',
      'billed': 'Billed \$35.88/year',
    },
    {
      'id': 2,
      'label': 'Lifetime',
      'price': '\$49.99',
      'period': ' once',
      'badge': 'ONE-TIME',
      'savings': 'Forever',
      'billed': 'Pay once, use forever',
    },
  ];

  final List<Map<String, dynamic>> _features = [
    {
      'icon': CupertinoIcons.book_fill,
      'title': 'Unlimited Diary Entries',
      'subtitle': 'Write every day with no entry limits or storage caps',
    },
    {
      'icon': CupertinoIcons.wand_stars,
      'title': 'AI Story Generation',
      'subtitle': 'Transform your diary entries into beautiful narratives with AI',
    },
    {
      'icon': CupertinoIcons.pencil_outline,
      'title': 'Unlimited Story Creation',
      'subtitle': 'Write and publish as many stories as you want',
    },
    {
      'icon': CupertinoIcons.globe,
      'title': 'Publish to Community',
      'subtitle': 'Share your stories with readers across the platform',
    },
    {
      'icon': CupertinoIcons.wand_rays,
      'title': 'Advanced AI Rewrites',
      'subtitle': 'Refine tone, style, and plot with powerful AI editing tools',
    },
    {
      'icon': CupertinoIcons.chart_bar_alt_fill,
      'title': 'Story & Diary Analytics',
      'subtitle': 'Track your writing habits, moods, and reader engagement',
    },
    {
      'icon': CupertinoIcons.paintbrush_fill,
      'title': 'Premium Themes & Covers',
      'subtitle': 'Unlock beautiful story covers, fonts, and journal themes',
    },
    {
      'icon': CupertinoIcons.cloud_download_fill,
      'title': 'Export Stories & Diary',
      'subtitle': 'Download your work as PDF, ePub, or plain text anytime',
    },
  ];

  final List<Map<String, String>> _subscriptionDetails = [
    {
      'title': 'Billing',
      'body':
          'Payment will be charged to your account upon confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.',
    },
    {
      'title': 'Auto-Renewal',
      'body':
          'Your account will be charged for renewal within 24 hours prior to the end of the current period at the rate of your selected plan.',
    },
    {
      'title': 'Cancellation',
      'body':
          'You may cancel your subscription at any time through your account settings. Cancellation takes effect at the end of the current billing period. No refunds for partial periods.',
    },
    {
      'title': 'Free Trial',
      'body':
          'If you cancel during the free trial, you won\'t be charged. The trial is available once per user.',
    },
    {
      'title': 'Data Security',
      'body':
          'All journal entries are encrypted end-to-end. DiaryAI cannot access your private entries. Your privacy is guaranteed.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          children: [
            SizedBox(height: height * 0.01),

            // ── Hero ────────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: .12),
                      ),
                      child: Icon(
                        CupertinoIcons.star_fill,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unlock Your Full Story',
                    style: theme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Write more, create stories, and publish to readers',
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLighter,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Pill tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PillTag('AI Stories'),
                      const SizedBox(width: 6),
                      _PillTag('Publish'),
                      const SizedBox(width: 6),
                      _PillTag('7-Day Free Trial'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

            // ── Free vs Premium comparison ───────────────────────────
            TRoundedContainer(
              margin: EdgeInsets.zero,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CompareColumn(
                        label: 'Free',
                        items: const [
                          'Diary entries (limited)',
                          'Manual story writing',
                          'View community stories',
                        ],
                        theme: theme,
                        isPremium: false,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 96,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: AppColors.border.withValues(alpha: .4),
                    ),
                    Expanded(
                      child: _CompareColumn(
                        label: 'Premium',
                        items: const [
                          'Unlimited diary entries',
                          'AI-powered story creation',
                          'Publish your stories',
                        ],
                        theme: theme,
                        isPremium: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.025),

            // ── Plan Selector ────────────────────────────────────────
            Text(
              'Choose Your Plan',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              'All plans include a 7-day free trial',
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textLighter,
              ),
            ),
            SizedBox(height: height * 0.015),

            Row(
              children: _plans.map((plan) {
                final isSelected = _selectedPlan == plan['id'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPlan = plan['id']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      margin:
                          EdgeInsets.only(right: plan['id'] < 2 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: .08)
                            : (isDark
                                ? Colors.white.withOpacity(0.04)
                                : Colors.grey.withOpacity(0.05)),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border.withValues(alpha: .4),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: .12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (plan['badge'] != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color:
                                    AppColors.primary.withValues(alpha: .12),
                              ),
                              child: Text(
                                plan['badge'],
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 22),
                          Text(
                            plan['price'],
                            style: theme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color:
                                  isSelected ? AppColors.primary : null,
                            ),
                          ),
                          Text(
                            plan['period'],
                            style: theme.bodySmall!.copyWith(
                              color: AppColors.textLighter,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan['label'],
                            style: theme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textLighter,
                            ),
                          ),
                          if (plan['savings'] != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              plan['savings'],
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),
            Center(
              child: Text(
                _plans[_selectedPlan]['billed'],
                style: theme.titleSmall!.copyWith(
                  color: AppColors.textLighter,
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                ),
              ),
            ),

            SizedBox(height: height * 0.025),

            // ── CTA Button ───────────────────────────────────────────
            _buildCtaButton(theme, height, width),

            SizedBox(height: height * 0.03),

            // ── Features ─────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Everything in Premium',
                  style:
                      theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primary.withValues(alpha: .10),
                  ),
                  child: Text(
                    '${_features.length} features',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),

            TRoundedContainer(
              margin: EdgeInsets.zero,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: _features.length,
                separatorBuilder: (_, __) => Divider(
                  color: AppColors.border.withValues(alpha: .3),
                  height: 1,
                  indent: 56,
                ),
                itemBuilder: (context, index) {
                  final feature = _features[index];
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary.withValues(alpha: .10),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      feature['title'],
                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      feature['subtitle'],
                      style: theme.bodySmall!.copyWith(
                        color: AppColors.textLighter,
                        fontSize: 11,
                      ),
                    ),
                    trailing: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: .10),
                      ),
                      child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: AppColors.primary,
                        size: 12,
                      ),
                    ),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    minVerticalPadding: 4,
                  );
                },
              ),
            ),

            SizedBox(height: height * 0.025),

            // ── Testimonial ──────────────────────────────────────────
            TRoundedContainer(
              margin: EdgeInsets.zero,
              backgroundColor: AppColors.primary.withValues(alpha: .05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.quote_bubble_fill,
                      color: AppColors.primary.withValues(alpha: .6),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"I turned a whole year of diary entries into a novel with DiaryAI. The AI story tool is unlike anything else."',
                            style: theme.bodySmall!.copyWith(
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: .12),
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Alex R. · Premium writer',
                                style: theme.labelSmall!.copyWith(
                                  color: AppColors.textLighter,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: List.generate(
                                  5,
                                  (_) => Icon(
                                    CupertinoIcons.star_fill,
                                    color: AppColors.primary,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.025),

            // ── Subscription Details ─────────────────────────────────
            Text(
              'Subscription Details',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: height * 0.015),

            TRoundedContainer(
              margin: EdgeInsets.zero,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _subscriptionDetails.asMap().entries.map((entry) {
                    final isLast =
                        entry.key == _subscriptionDetails.length - 1;
                    final item = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 3, right: 8),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${item['title']}: ',
                                      style: theme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.text,
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: item['body'],
                                      style: theme.bodySmall!.copyWith(
                                        color: AppColors.textLighter,
                                        fontSize: 12,
                                        height: 1.5,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!isLast) const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: height * 0.02),

            // ── Bottom links ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _linkButton('Restore Purchase', theme),
                Text('·', style: TextStyle(color: AppColors.textLighter)),
                _linkButton('Terms of Use', theme),
                Text('·', style: TextStyle(color: AppColors.textLighter)),
                _linkButton('Privacy Policy', theme),
              ],
            ),

            Center(
              child: Text(
                'Cancel anytime. No charges during your 7-day trial.',
                style: theme.titleSmall!.copyWith(
                  color: AppColors.textLighter,
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: height * 0.06),
          ],
        ),
      ),
    );
  }

  Widget _buildCtaButton(TextTheme theme, double height, double width) {
    final plan = _plans[_selectedPlan];

    final String buttonText = _selectedPlan == 2
        ? 'Get Lifetime Access · ${plan['price']}'
        : 'Start Free Trial · ${plan['label']}';

    final String subText = _selectedPlan == 2
        ? 'One-time payment, never pay again'
        : 'Then ${plan['price']}${plan['period']} · Cancel anytime';

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // handle purchase
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: height * 0.065,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.primary.withValues(alpha: .15),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: theme.titleMedium!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subText,
          style: theme.titleSmall!.copyWith(
            color: AppColors.textLighter,
            fontWeight: FontWeight.normal,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _linkButton(String label, TextTheme theme) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: theme.titleSmall!.copyWith(
          color: AppColors.textLighter,
          fontWeight: FontWeight.normal,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _PillTag extends StatelessWidget {
  final String label;

  const _PillTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primary.withValues(alpha: .10),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: .3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _CompareColumn extends StatelessWidget {
  final String label;
  final List<String> items;
  final TextTheme theme;
  final bool isPremium;

  const _CompareColumn({
    required this.label,
    required this.items,
    required this.theme,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isPremium ? 12 : 0,
        right: isPremium ? 0 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isPremium) ...[
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: .12),
                  ),
                  child: Icon(
                    CupertinoIcons.star_fill,
                    color: AppColors.primary,
                    size: 8,
                  ),
                ),
              ],
              Text(
                label,
                style: theme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isPremium ? AppColors.primary : AppColors.textLighter,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 6),
                    child: Icon(
                      isPremium
                          ? CupertinoIcons.checkmark_alt
                          : CupertinoIcons.minus,
                      size: 11,
                      color: isPremium
                          ? AppColors.primary
                          : AppColors.textLighter.withOpacity(0.5),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.bodySmall!.copyWith(
                        fontSize: 11,
                        color: isPremium
                            ? null
                            : AppColors.textLighter.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}