import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management/features/parent/presentation/screens/dashboard/parent_dashboard_screen.dart';
import 'package:management/features/parent/presentation/screens/diary/parent_diary_screen.dart';
import 'package:management/features/parent/presentation/screens/fees/parent_fees_screen.dart';
import 'package:management/features/parent/presentation/screens/profile_tab.dart';

class ParentPortalMain extends StatefulWidget {
  const ParentPortalMain({super.key});

  @override
  State<ParentPortalMain> createState() => _ParentPortalMainState();
}

class _ParentPortalMainState extends State<ParentPortalMain> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    ParentDashboardScreen(),
    ParentFeesScreen(),
    ParentDiaryScreen(),
    ParentProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = Color(0xFFE28743);

    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: brandOrange,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Fees',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
