import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

// Shared preferences instance provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

// User profile state notifier
class UserProfileNotifier extends StateNotifier<UserProfile> {
  final SharedPreferences? _prefs;

  UserProfileNotifier(this._prefs)
    : super(
        UserProfile(
          id: 'user-1',
          name: _prefs?.getString('user_name') ?? 'Alex',
          totalPoints: _prefs?.getInt('user_points') ?? 1200,
          currentStreak: _prefs?.getInt('user_streak') ?? 5,
          longestStreak: _prefs?.getInt('user_longest_streak') ?? 12,
          quizzesCompleted: _prefs?.getInt('user_quizzes_completed') ?? 15,
          lastActiveDate: DateTime.now(),
        ),
      );

  // Save user name to shared preferences
  Future<void> _saveUserName(String name) async {
    await _prefs?.setString('user_name', name);
  }

  // Save user points
  Future<void> _saveUserPoints(int points) async {
    await _prefs?.setInt('user_points', points);
  }

  // Save user streak
  Future<void> _saveUserStreak(int streak) async {
    await _prefs?.setInt('user_streak', streak);
  }

  // Save longest streak
  Future<void> _saveLongestStreak(int streak) async {
    await _prefs?.setInt('user_longest_streak', streak);
  }

  // Save quizzes completed
  Future<void> _saveQuizzesCompleted(int count) async {
    await _prefs?.setInt('user_quizzes_completed', count);
  }

  void updatePoints(int points) {
    final newPoints = state.totalPoints + points;
    state = state.copyWith(totalPoints: newPoints);
    _saveUserPoints(newPoints);
  }

  void incrementStreak() {
    final newStreak = state.currentStreak + 1;
    final newLongestStreak =
        newStreak > state.longestStreak ? newStreak : state.longestStreak;
    state = state.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastActiveDate: DateTime.now(),
    );
    _saveUserStreak(newStreak);
    _saveLongestStreak(newLongestStreak);
  }

  void resetStreak() {
    state = state.copyWith(currentStreak: 0);
    _saveUserStreak(0);
  }

  void incrementQuizzesCompleted() {
    final newCount = state.quizzesCompleted + 1;
    state = state.copyWith(quizzesCompleted: newCount);
    _saveQuizzesCompleted(newCount);
  }

  void updateProfile({String? name, String? avatarUrl}) {
    if (name != null) {
      state = state.copyWith(name: name);
      _saveUserName(name);
    }
  }
}

// User profile provider
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
      final prefsAsync = ref.watch(sharedPreferencesProvider);
      return UserProfileNotifier(prefsAsync.value);
    });
