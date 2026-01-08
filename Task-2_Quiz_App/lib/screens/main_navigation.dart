import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';

// Selected tab provider
final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              ref.read(selectedTabProvider.notifier).state = index;
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primaryTeal,
            unselectedItemColor: AppTheme.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.home_rounded,
                  isSelected: selectedIndex == 0,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.search_rounded,
                  isSelected: selectedIndex == 1,
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.person_rounded,
                  isSelected: selectedIndex == 2,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _NavIcon({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppTheme.primaryTeal.withOpacity(0.15)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? AppTheme.primaryTeal : AppTheme.textSecondary,
      ),
    );
  }
}
