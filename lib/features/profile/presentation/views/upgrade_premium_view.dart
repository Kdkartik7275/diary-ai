// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/containers/rounded_container.dart';

class UpgradePremiumView extends StatefulWidget {
  const UpgradePremiumView({super.key});

  @override
  State<UpgradePremiumView> createState() => _UpgradePremiumViewState();
}

class _UpgradePremiumViewState extends State<UpgradePremiumView>
    with SingleTickerProviderStateMixin {
  int _selectedTier = 1; // 0=Creator, 1=Pro, 2=Unlimited
  int _billingCycle = 1; // 0=Monthly, 1=Yearly

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _tiers = [
    {
      'id': 0,
      'name': 'Creator',
      'tagline': 'Start your story',
      'icon': CupertinoIcons.pencil,
      'color': const Color(0xFF6C8EF5),
      'monthlyPrice': 2.99,
      'yearlyMonthlyPrice': 1.99,
      'yearlyTotal': 23.88,
      'features': [
        {
          'icon': CupertinoIcons.book_fill,
          'text': 'Unlimited diary entries',
          'free': true,
        },
        {
          'icon': CupertinoIcons.wand_stars,
          'text': '5 AI story generations/mo',
          'free': false,
        },
        {
          'icon': CupertinoIcons.pencil_outline,
          'text': '3 published stories',
          'free': false,
        },
        {
          'icon': CupertinoIcons.globe,
          'text': 'Community reading access',
          'free': false,
        },
        {
          'icon': CupertinoIcons.cloud_download_fill,
          'text': 'Export as PDF',
          'free': false,
        },
      ],
      'notIncluded': [
        'Advanced AI rewrites',
        'Analytics dashboard',
        'Premium themes & covers',
        'Priority support',
      ],
    },
    {
      'id': 1,
      'name': 'Pro',
      'tagline': 'For serious writers',
      'icon': CupertinoIcons.wand_stars,
      'color': AppColors.primary,
      'badge': 'MOST POPULAR',
      'monthlyPrice': 5.99,
      'yearlyMonthlyPrice': 3.99,
      'yearlyTotal': 47.88,
      'features': [
        {
          'icon': CupertinoIcons.book_fill,
          'text': 'Unlimited diary entries',
          'free': true,
        },
        {
          'icon': CupertinoIcons.wand_stars,
          'text': '30 AI story generations/mo',
          'free': false,
        },
        {
          'icon': CupertinoIcons.pencil_outline,
          'text': 'Unlimited published stories',
          'free': false,
        },
        {
          'icon': CupertinoIcons.globe,
          'text': 'Full community features',
          'free': false,
        },
        {
          'icon': CupertinoIcons.wand_rays,
          'text': 'Advanced AI rewrites',
          'free': false,
        },
        {
          'icon': CupertinoIcons.chart_bar_alt_fill,
          'text': 'Story & diary analytics',
          'free': false,
        },
        {
          'icon': CupertinoIcons.cloud_download_fill,
          'text': 'Export PDF, ePub & text',
          'free': false,
        },
      ],
      'notIncluded': ['Premium themes & covers', 'Priority support'],
    },
    {
      'id': 2,
      'name': 'Unlimited',
      'tagline': 'Everything, forever',
      'icon': CupertinoIcons.sparkles,
      'color': const Color(0xFFE8A838),
      'monthlyPrice': 9.99,
      'yearlyMonthlyPrice': 6.99,
      'yearlyTotal': 83.88,
      'features': [
        {
          'icon': CupertinoIcons.book_fill,
          'text': 'Unlimited diary entries',
          'free': true,
        },
        {
          'icon': CupertinoIcons.wand_stars,
          'text': 'Unlimited AI generations',
          'free': false,
        },
        {
          'icon': CupertinoIcons.pencil_outline,
          'text': 'Unlimited published stories',
          'free': false,
        },
        {
          'icon': CupertinoIcons.globe,
          'text': 'Full community + featured slots',
          'free': false,
        },
        {
          'icon': CupertinoIcons.wand_rays,
          'text': 'Advanced AI rewrites',
          'free': false,
        },
        {
          'icon': CupertinoIcons.chart_bar_alt_fill,
          'text': 'Deep analytics & insights',
          'free': false,
        },
        {
          'icon': CupertinoIcons.paintbrush_fill,
          'text': 'All premium themes & covers',
          'free': false,
        },
        {
          'icon': CupertinoIcons.cloud_download_fill,
          'text': 'Export all formats',
          'free': false,
        },
        {
          'icon': CupertinoIcons.checkmark_shield_fill,
          'text': 'Priority support',
          'free': false,
        },
      ],
      'notIncluded': [],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _currentTier => _tiers[_selectedTier];

  double get _displayedMonthlyPrice => _billingCycle == 0
      ? (_currentTier['monthlyPrice'] as double)
      : (_currentTier['yearlyMonthlyPrice'] as double);

  String get _billingLine => _billingCycle == 0
      ? 'Billed monthly · Cancel anytime'
      : 'Billed \$${_currentTier['yearlyTotal']}/year · Save ${_savingsPercent()}%';

  int _savingsPercent() {
    final monthly = (_currentTier['monthlyPrice'] as double) * 12;
    final yearly = _currentTier['yearlyTotal'] as double;
    return (((monthly - yearly) / monthly) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final theme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tierColor = _currentTier['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upgrade', style: theme.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          children: [
            SizedBox(height: h * 0.015),

            // ── Header ──────────────────────────────────────────────────────
            _buildHeader(theme, tierColor),
            SizedBox(height: h * 0.02),

            // ── Free badge ─────────────────────────────────────────────────
            _FreeBadge(theme: theme),
            SizedBox(height: h * 0.02),

            // ── Tier selector ───────────────────────────────────────────────
            Text(
              'Choose a plan',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              'All plans include a 7-day free trial',
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildTierSelector(theme, isDark),
            SizedBox(height: h * 0.02),

            // ── Billing toggle ─────────────────────────────────────────────
            _buildBillingToggle(theme, isDark),
            SizedBox(height: h * 0.015),

            // ── Price card ─────────────────────────────────────────────────
            _buildPriceCard(theme, tierColor),
            SizedBox(height: h * 0.02),

            // ── Feature list ────────────────────────────────────────────────
            _buildFeatureList(theme, tierColor),
            SizedBox(height: h * 0.02),

            // ── CTA ─────────────────────────────────────────────────────────
            _buildCtaButton(theme, h, tierColor),
            SizedBox(height: h * 0.01),
            Center(
              child: Text(
                '7-day free trial · No charges until trial ends',
                style: theme.titleSmall!.copyWith(
                  color: AppColors.textLighter,
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: h * 0.02),

            // ── Compare all plans ──────────────────────────────────────────
            _buildComparisonTable(theme, isDark),
            SizedBox(height: h * 0.02),

            // ── Testimonial ─────────────────────────────────────────────────
            _buildTestimonial(theme),
            SizedBox(height: h * 0.02),

            // ── Subscription details ────────────────────────────────────────
            _buildSubscriptionDetails(theme),
            SizedBox(height: h * 0.015),

            // ── Bottom links ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _linkButton('Restore Purchase', theme),
                Text(
                  '·',
                  style: TextStyle(color: AppColors.textLighter, fontSize: 11),
                ),
                _linkButton('Terms', theme),
                Text(
                  '·',
                  style: TextStyle(color: AppColors.textLighter, fontSize: 11),
                ),
                _linkButton('Privacy', theme),
              ],
            ),
            SizedBox(height: h * 0.06),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(TextTheme theme, Color tierColor) {
    return Column(
      children: [
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tierColor.withValues(alpha: .12),
            ),
            child: Icon(
              _currentTier['icon'] as IconData,
              color: tierColor,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Matches "Account Details" title style: titleMedium, w500, ~16px
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            key: ValueKey(_selectedTier),
            _currentTier['tagline'] as String,
            style: theme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Matches "Manage your account information" subtitle style
        Text(
          'Diaries are always free. Upgrade for AI, stories & more.',
          style: theme.titleSmall!.copyWith(
            color: AppColors.textLighter,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Tier selector ──────────────────────────────────────────────────────────
  Widget _buildTierSelector(TextTheme theme, bool isDark) {
    return Row(
      children: _tiers.map((tier) {
        final isSelected = _selectedTier == tier['id'];
        final color = tier['color'] as Color;
        final hasBadge = tier['badge'] != null;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTier = tier['id']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              margin: EdgeInsets.only(right: tier['id'] < 2 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isSelected
                    ? color.withValues(alpha: .08)
                    : (isDark
                          ? Colors.white.withValues(alpha: .04)
                          : Colors.grey.withValues(alpha: .05)),
                border: Border.all(
                  color: isSelected
                      ? color
                      : AppColors.border.withValues(alpha: .4),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  if (hasBadge)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: color.withValues(alpha: .12),
                      ),
                      child: Text(
                        tier['badge'] as String,
                        style: theme.titleSmall!.copyWith(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 0.4,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 18),
                  Icon(
                    tier['icon'] as IconData,
                    color: isSelected ? color : AppColors.textLighter,
                    size: 18,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    tier['name'] as String,
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppColors.textLighter,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Billing toggle ─────────────────────────────────────────────────────────
  Widget _buildBillingToggle(TextTheme theme, bool isDark) {
    return TRoundedContainer(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(4),
      backgroundColor: isDark
          ? Colors.white.withValues(alpha: .06)
          : Colors.grey.withValues(alpha: .08),
      child: Row(
        children: [
          _buildBillingOption(0, 'Monthly', null, theme, isDark),
          _buildBillingOption(
            1,
            'Yearly',
            'Save ${_savingsPercent()}%',
            theme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingOption(
    int index,
    String label,
    String? savingsTag,
    TextTheme theme,
    bool isDark,
  ) {
    final isSelected = _billingCycle == index;
    final tierColor = _currentTier['color'] as Color;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _billingCycle = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? (Colors.white) : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                // matches titleSmall style used throughout Account Details
                style: theme.titleSmall!.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? tierColor : AppColors.textLighter,
                  fontSize: 13,
                ),
              ),
              if (savingsTag != null) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: tierColor.withValues(alpha: isSelected ? .14 : .07),
                  ),
                  child: Text(
                    savingsTag,
                    style: theme.titleSmall!.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: tierColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Price card ─────────────────────────────────────────────────────────────
  Widget _buildPriceCard(TextTheme theme, Color tierColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: tierColor.withValues(alpha: .07),
        border: Border.all(color: tierColor.withValues(alpha: .2), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title style — matches "Subscription Plan" in Account Details
                Text(
                  _currentTier['name'] as String,
                  style: theme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: tierColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _billingLine,
                  style: theme.titleSmall!.copyWith(
                    color: AppColors.textLighter,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${_displayedMonthlyPrice.toStringAsFixed(2)}',
                // Large price — kept prominent but not displaySmall
                style: theme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: tierColor,
                  fontSize: 26,
                  letterSpacing: -0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  ' /mo',
                  style: theme.titleSmall!.copyWith(
                    color: AppColors.textLighter,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Feature list ───────────────────────────────────────────────────────────
  Widget _buildFeatureList(TextTheme theme, Color tierColor) {
    final features = _currentTier['features'] as List<Map<String, dynamic>>;
    final notIncluded = _currentTier['notIncluded'] as List<dynamic>;

    return TRoundedContainer(
      margin: EdgeInsets.zero,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              "What's included",
              // matches "Personal Information" section header
              style: theme.titleLarge,
            ),
          ),
          Divider(color: AppColors.border.withValues(alpha: .3)),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 6),
            itemCount: features.length,
            separatorBuilder: (_, __) => Divider(
              color: AppColors.border.withValues(alpha: .3),
              height: 1,
              indent: 52,
            ),
            itemBuilder: (context, i) {
              final f = features[i];
              final isFreeFeature = f['free'] as bool;
              return ListTile(
                dense: true,
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isFreeFeature
                        ? AppColors.border.withValues(alpha: .3)
                        : tierColor.withValues(alpha: .10),
                  ),
                  child: Icon(
                    f['icon'] as IconData,
                    color: isFreeFeature ? AppColors.textLighter : tierColor,
                    size: 15,
                  ),
                ),
                // matches list item title style in Account Details Security section
                title: Text(
                  f['text'] as String,
                  style: theme.titleLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                subtitle: isFreeFeature
                    ? Text(
                        'Free for everyone',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      )
                    : null,
                trailing: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFreeFeature
                        ? AppColors.border.withValues(alpha: .4)
                        : tierColor.withValues(alpha: .12),
                  ),
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    color: isFreeFeature ? AppColors.textLighter : tierColor,
                    size: 11,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                minVerticalPadding: 0,
                visualDensity: const VisualDensity(vertical: -4),
              );
            },
          ),
          if (notIncluded.isNotEmpty) ...[
            Divider(color: AppColors.border.withValues(alpha: .3), height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Not included in this plan',
                    style: theme.titleSmall!.copyWith(
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: notIncluded
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.border.withValues(alpha: .3),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.minus,
                                  size: 9,
                                  color: AppColors.textLighter.withValues(
                                    alpha: .5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item as String,
                                  style: theme.titleSmall!.copyWith(
                                    color: AppColors.textLighter.withValues(
                                      alpha: .7,
                                    ),
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── CTA button ─────────────────────────────────────────────────────────────
  Widget _buildCtaButton(TextTheme theme, double h, Color tierColor) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: h * 0.055,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [tierColor.withValues(alpha: .7), tierColor],
          ),
        ),
        alignment: Alignment.center,
        // matches "Edit Information" / "Upgrade to Premium" button text style
        child: Text(
          'Start 7-Day Free Trial',
          style: theme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Comparison table ───────────────────────────────────────────────────────
  Widget _buildComparisonTable(TextTheme theme, bool isDark) {
    final rows = [
      'Diary entries',
      'AI story generations',
      'Published stories',
      'AI rewrites',
      'Analytics',
      'Premium themes',
      'Export formats',
      'Priority support',
    ];
    final columns = [
      ['Free', null],
      ['Creator', const Color(0xFF6C8EF5)],
      ['Pro', AppColors.primary],
      ['Unlimited', const Color(0xFFE8A838)],
    ];
    final cellData = [
      ['Limited', 'Unlimited', 'Unlimited', 'Unlimited'],
      ['—', '5/mo', '30/mo', 'Unlimited'],
      ['—', '3', 'Unlimited', 'Unlimited'],
      ['—', '—', '✓', '✓'],
      ['—', '—', '✓', '✓'],
      ['—', '—', '—', '✓'],
      ['—', 'PDF', 'PDF, ePub', 'All'],
      ['—', '—', '—', '✓'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compare all plans',
          style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        TRoundedContainer(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .04)
                      : Colors.grey.withValues(alpha: .04),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(flex: 3, child: SizedBox()),
                    ...columns.map(
                      (col) => Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            col[0] as String,
                            style: theme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: col[1] == null
                                  ? AppColors.textLighter
                                  : col[1] as Color,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...rows.asMap().entries.map((entry) {
                return Column(
                  children: [
                    Divider(
                      color: AppColors.border.withValues(alpha: .3),
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              entry.value,
                              style: theme.titleSmall!.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textLighter,
                              ),
                            ),
                          ),
                          ...cellData[entry.key].asMap().entries.map((cell) {
                            final isCheck = cell.value == '✓';
                            final isDash = cell.value == '—';
                            final colColor = columns[cell.key][1] as Color?;
                            return Expanded(
                              flex: 2,
                              child: Center(
                                child: isCheck
                                    ? Icon(
                                        CupertinoIcons.checkmark_alt,
                                        size: 13,
                                        color:
                                            colColor ?? AppColors.textLighter,
                                      )
                                    : Text(
                                        cell.value,
                                        style: theme.titleSmall!.copyWith(
                                          fontSize: 10,
                                          color: isDash
                                              ? AppColors.textLighter
                                                    .withValues(alpha: .4)
                                              : (colColor ??
                                                    AppColors.textLighter),
                                          fontWeight: isDash
                                              ? FontWeight.normal
                                              : FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ── Testimonial ────────────────────────────────────────────────────────────
  Widget _buildTestimonial(TextTheme theme) {
    return TRoundedContainer(
      margin: EdgeInsets.zero,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .07),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.quote_bubble_fill,
              color: AppColors.primary.withValues(alpha: .5),
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"I turned a whole year of diary entries into a novel with DiaryAI. The AI story tool is unlike anything else."',
                    style: theme.titleSmall!.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: .12,
                        ),
                        child: Text(
                          'A',
                          style: theme.titleSmall!.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Alex R. · Pro writer',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
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
    );
  }

  // ── Subscription details ───────────────────────────────────────────────────
  Widget _buildSubscriptionDetails(TextTheme theme) {
    final details = [
      {
        'title': 'Billing',
        'body':
            'Payment is charged upon confirmation. Subscriptions renew automatically unless cancelled at least 24 hours before the period ends.',
      },
      {
        'title': 'Cancellation',
        'body':
            'Cancel anytime via your account settings. Access continues until the end of the billing period. No partial refunds.',
      },
      {
        'title': 'Free Trial',
        'body':
            "A 7-day free trial is available once per user. You won't be charged if you cancel before the trial ends.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Details',
          style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
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
              children: details.asMap().entries.map((entry) {
                final isLast = entry.key == details.length - 1;
                final item = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 8),
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
                                  style: theme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: item['body'],
                                  style: theme.titleSmall!.copyWith(
                                    color: AppColors.textLighter,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    height: 1.5,
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

// ── Free forever badge ─────────────────────────────────────────────────────────
class _FreeBadge extends StatelessWidget {
  final TextTheme theme;
  const _FreeBadge({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? Colors.green.withValues(alpha: .08)
            : Colors.green.withValues(alpha: .06),
        border: Border.all(
          color: Colors.green.withValues(alpha: .25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withValues(alpha: .12),
            ),
            child: const Icon(
              CupertinoIcons.lock_open_fill,
              color: Colors.green,
              size: 15,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diaries are always free',
                  style: theme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Write unlimited diary entries with no plan required.',
                  style: theme.titleSmall!.copyWith(
                    color: Colors.green.withValues(alpha: .7),
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
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
