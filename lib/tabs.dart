import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/diary/presentation/view/diaries_view.dart';
import 'package:lifeline/features/home/presentation/view/home_view.dart';
import 'package:lifeline/features/profile/presentation/views/profile_view.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  late UserController _userController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
    HomeView(),
    DiariesView(),
    const Center(child: Text('Stories Page')),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
    loadUser();
  }

  Future<void> loadUser() async {
    await _userController.loadUser(sl<FirebaseAuth>().currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.border,
          onTap: _onItemTapped,
          iconSize: 26,
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              activeIcon: Icon(CupertinoIcons.home, color: AppColors.primary),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.book),
              activeIcon: Icon(
                CupertinoIcons.book_fill,
                color: AppColors.primary,
              ),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.collections),
              activeIcon: Icon(
                CupertinoIcons.collections_solid,
                color: AppColors.primary,
              ),
              label: 'Stories',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              activeIcon: Icon(
                CupertinoIcons.person_fill,
                color: AppColors.primary,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
