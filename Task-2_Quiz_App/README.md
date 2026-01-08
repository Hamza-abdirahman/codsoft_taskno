# Quiz App

A modern, feature-rich quiz application built with Flutter and Riverpod for state management.

## Features

- **Beautiful UI Design**: Gradient backgrounds, rounded cards, and smooth animations
- **State Management**: Riverpod for efficient state management
- **Responsive Design**: MediaQuery used throughout for responsive layouts
- **Multiple Screens**:
  - Home Screen with user stats, daily challenge, and categories
  - Explore Screen to browse quizzes
  - Quiz Screen with progress tracking
  - Results Screen with detailed performance analysis
  - Leaderboard Screen
  - Profile Screen
- **User Progress**: Track streaks, points, and quiz completion
- **Daily Challenges**: Special featured quizzes
- **Categories**: Science, History, Geography, and Arts

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # App-wide constants
│   └── theme/
│       └── app_theme.dart          # Color palette and theme configuration
├── models/
│   ├── quiz.dart                   # Quiz model
│   ├── quiz_category.dart          # Quiz category model
│   ├── quiz_progress.dart          # Quiz progress tracking
│   ├── quiz_question.dart          # Question model
│   ├── quiz_result.dart            # Quiz result model
│   └── user_profile.dart           # User profile model
├── providers/
│   ├── category_provider.dart      # Category data provider
│   ├── quiz_progress_provider.dart # Quiz progress state management
│   ├── quiz_provider.dart          # Quiz data and filtering
│   └── user_provider.dart          # User profile state management
├── screens/
│   ├── explore/
│   │   └── explore_screen.dart     # Browse all quizzes
│   ├── home/
│   │   └── home_screen.dart        # Main home screen
│   ├── leaderboard/
│   │   └── leaderboard_screen.dart # Global leaderboard
│   ├── navigation/
│   │   └── main_navigation.dart    # Bottom navigation bar
│   ├── profile/
│   │   └── profile_screen.dart     # User profile and settings
│   ├── quiz/
│   │   └── quiz_screen.dart        # Quiz taking screen
│   └── results/
│       └── results_screen.dart     # Quiz results screen
├── widgets/
│   ├── categories/
│   │   └── category_card.dart      # Category selection card
│   ├── common/
│   │   ├── gradient_button.dart    # Reusable gradient button
│   │   └── gradient_card.dart      # Reusable gradient card
│   ├── home/
│   │   ├── daily_challenge_card.dart # Daily challenge widget
│   │   └── user_stats_card.dart    # User statistics widget
│   └── quiz/
│       ├── answer_option.dart      # Answer option widget
│       ├── question_card.dart      # Question display card
│       └── quiz_card.dart          # Quiz preview card
└── main.dart                        # App entry point
```

## Design System

### Colors
- **Primary Colors**: Teal (#0D7C8A) and Blue (#1B8A9F)
- **Accent Colors**: Green (#4ECDC4), Orange (#FF6B35), Yellow (#FFA630)
- **Background**: Light (#E8F5F5) and White (#F8FEFF)
- **Status Colors**: Success Green, Error Red

### Gradients
- Primary gradient (Teal to Blue)
- Card gradient (Light teal)
- Orange gradient (for featured content)
- Button gradient

### Typography
- Font Family: Poppins (via Google Fonts)
- Responsive font sizes using theme
- Clear hierarchy with bold headings

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd quiz_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **flutter_riverpod**: ^2.6.1 - State management
- **google_fonts**: ^6.2.1 - Custom fonts

## State Management

The app uses Riverpod for state management with the following providers:

- `userProfileProvider`: Manages user data, points, and streaks
- `quizProgressProvider`: Tracks current quiz progress
- `quizzesProvider`: Provides quiz data
- `categoriesProvider`: Provides category data
- `selectedTabProvider`: Manages navigation state

## Features in Detail

### Home Screen
- User greeting with avatar
- Streak and points display
- Daily challenge card
- Continue playing section
- Category grid

### Quiz Screen
- Progress indicator
- Question cards with gradient backgrounds
- Multiple choice answers
- Submit and next question flow

### Results Screen
- Circular progress indicator
- Performance message
- Detailed statistics
- Answer review
- Play again and share options

### Profile Screen
- User statistics
- Settings and preferences
- Quiz history

### Leaderboard
- Top 3 podium display
- Ranked user list
- Current user highlighting

## Responsive Design

All screens use `MediaQuery` for responsive layouts:
- Adaptive padding and spacing
- Responsive card widths
- Scalable text sizes
- Flexible grid layouts

## Future Enhancements

- Backend integration for data persistence
- User authentication
- Real-time leaderboards
- More quiz categories
- Timer for questions
- Sound effects and haptic feedback
- Social sharing
- Achievements and badges

## License

This project is created for educational purposes.
