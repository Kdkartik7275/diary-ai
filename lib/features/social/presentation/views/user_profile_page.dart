import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeline/config/constants/colors.dart';

import 'package:lifeline/features/social/domain/entity/follow_entity.dart';

// ---------------------------------------------------------------------------
// Static placeholder data — replace with real data later
// ---------------------------------------------------------------------------
class _StaticProfile {
  static String bio(String username) =>
      'Health enthusiast & wellness advocate ✨\nTurning small habits into big changes 🌿';

  static int followers(String id) => 2400;
  static int following(String id) => 156;
  static int posts(String id) => 28;

  static List<_StatPost> recentPosts(String id) => [
        _StatPost(emoji: '🏃', title: 'Morning run — 5km!', tag: 'Fitness', time: '2h ago', likes: 18),
        _StatPost(emoji: '🥗', title: 'Tried a new salad recipe', tag: 'Nutrition', time: '1d ago', likes: 31),
        _StatPost(emoji: '💧', title: 'Hit my water goal today', tag: 'Hydration', time: '2d ago', likes: 12),
        _StatPost(emoji: '🧘', title: '20 min meditation session', tag: 'Mindfulness', time: '3d ago', likes: 27),
        _StatPost(emoji: '🍎', title: 'Clean eating day 7 streak!', tag: 'Nutrition', time: '4d ago', likes: 44),
      ];
}

class _StatPost {
  const _StatPost({required this.emoji, required this.title, required this.tag, required this.time, required this.likes});
  final String emoji, title, tag, time;
  final int likes;
}

// ---------------------------------------------------------------------------
// Avatar palette
// ---------------------------------------------------------------------------
const _avatarBgColors   = [Color(0xFFFFECEA), Color(0xFFE8F4FF), Color(0xFFEEFAF5), Color(0xFFFFF4E6), Color(0xFFF3EEFF)];
const _avatarTextColors = [Color(0xFFCC5A52), Color(0xFF2D78CC), Color(0xFF1A8A72), Color(0xFFCC7A00), Color(0xFF6B48D4)];

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.user});
  final FollowEntity user;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _following = false;

  String get _initials {
    final name = widget.user.fullName.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  Color get _avatarBg   => _avatarBgColors[widget.user.id.hashCode.abs() % _avatarBgColors.length];
  Color get _avatarText => _avatarTextColors[widget.user.id.hashCode.abs() % _avatarTextColors.length];

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K' : '$n';

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final posts = _StaticProfile.recentPosts(user.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [

          // ── App bar ───────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.text),
            ),
            title: Text(
              '@${user.username}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, size: 22, color: AppColors.text),
                onPressed: () {},
              ),
            ],
          ),

          // ── Profile section ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Avatar row + stats
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _avatarBg,
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2.5),
                        ),
                        child: user.profileUrl != null && user.profileUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  user.profileUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      Center(child: Text(_initials, style: TextStyle(color: _avatarText, fontWeight: FontWeight.w800, fontSize: 24))),
                                ),
                              )
                            : Center(child: Text(_initials, style: TextStyle(color: _avatarText, fontWeight: FontWeight.w800, fontSize: 24))),
                      ),

                      const SizedBox(width: 28),

                      // Stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatCol(value: _fmt(_StaticProfile.posts(user.id)), label: 'Posts'),
                            _StatCol(value: _fmt(_StaticProfile.followers(user.id)), label: 'Followers'),
                            _StatCol(value: _fmt(_StaticProfile.following(user.id)), label: 'Following'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text),
                  ),

                  const SizedBox(height: 5),

                  // Bio
                  Text(
                    _StaticProfile.bio(user.username),
                    style: const TextStyle(fontSize: 13.5, color: AppColors.textLighter, height: 1.55),
                  ),

                  const SizedBox(height: 18),

                  // Buttons row
                  Row(
                    children: [
                      Expanded(
                        child: _FollowBtn(
                          following: _following,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _following = !_following);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      _OutlineIconBtn(icon: Icons.chat_bubble_outline_rounded, onTap: () {}),
                      const SizedBox(width: 8),
                      _OutlineIconBtn(icon: Icons.person_add_outlined, onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Section divider
                  Row(
                    children: [
                      Container(width: 3, height: 18, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      const Text('Activity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text)),
                    ],
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // ── Posts list ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PostCard(post: posts[i]),
                ),
                childCount: posts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _StatCol extends StatelessWidget {
  const _StatCol({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text, letterSpacing: -0.5)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.hintText, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _FollowBtn extends StatelessWidget {
  const _FollowBtn({required this.following, required this.onTap});
  final bool following;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        decoration: BoxDecoration(
          color: following ? Colors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: following ? AppColors.border : AppColors.primary),
        ),
        child: Center(
          child: Text(
            following ? 'Following' : 'Follow',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: following ? AppColors.text : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineIconBtn extends StatelessWidget {
  const _OutlineIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 17, color: AppColors.text),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final _StatPost post;

  // Tag colors
  static const _tagColors = {
    'Fitness':     (Color(0xFFFFECEA), Color(0xFFCC5A52)),
    'Nutrition':   (Color(0xFFEEFAF5), Color(0xFF1A8A72)),
    'Hydration':   (Color(0xFFE8F4FF), Color(0xFF2D78CC)),
    'Mindfulness': (Color(0xFFF3EEFF), Color(0xFF6B48D4)),
  };

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColors[post.tag] ?? (const Color(0xFFF4F4F6), AppColors.hintText);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Emoji
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(post.emoji, style: const TextStyle(fontSize: 21))),
          ),

          const SizedBox(width: 12),

          // Title + tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.text)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagColor.$1,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(post.tag, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tagColor.$2)),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Time + likes
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(post.time, style: const TextStyle(fontSize: 11, color: AppColors.hintText)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.favorite_rounded, size: 13, color: AppColors.primary),
                  const SizedBox(width: 3),
                  Text('${post.likes}', style: const TextStyle(fontSize: 12, color: AppColors.hintText, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}