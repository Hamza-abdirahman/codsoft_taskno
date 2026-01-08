class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final int quizzesCompleted;
  final DateTime lastActiveDate;

  const UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.quizzesCompleted = 0,
    required this.lastActiveDate,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    int? quizzesCompleted,
    DateTime? lastActiveDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
