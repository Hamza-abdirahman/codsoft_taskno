# Quiz App - Developer Guide

## Quick Start

### Running the App

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d chrome  # For web
flutter run -d <device-id>  # For specific device
```

### Building the App

```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android)
flutter build appbundle

# Build iOS
flutter build ios

# Build Web
flutter build web
```

## Architecture

### State Management with Riverpod

This app uses Riverpod for state management. Key concepts:

1. **Providers**: Declare providers at the top level
2. **ConsumerWidget**: Use instead of StatelessWidget to access providers
3. **ConsumerStatefulWidget**: Use instead of StatefulWidget to access providers
4. **ref.watch()**: Subscribe to provider changes
5. **ref.read()**: Read provider value without subscribing

### Folder Structure Convention

- **models/**: Data models (immutable classes)
- **providers/**: Riverpod providers for state management
- **screens/**: Full-page screens
- **widgets/**: Reusable UI components
- **core/**: Theme, constants, utilities

## Key Implementations

### Adding a New Quiz

Edit [quiz_provider.dart](lib/providers/quiz_provider.dart):

```dart
Quiz(
  id: 'unique-id',
  title: 'Quiz Title',
  description: 'Quiz description',
  category: 'Category',
  difficulty: QuizDifficulty.medium,
  questions: [
    QuizQuestion(
      id: 'q1',
      question: 'Question text?',
      options: ['A', 'B', 'C', 'D'],
      correctAnswerIndex: 0, // Index of correct answer
    ),
    // Add more questions...
  ],
),
```

### Adding a New Category

Edit [category_provider.dart](lib/providers/category_provider.dart):

```dart
QuizCategory(
  id: 'category-id',
  name: 'Category Name',
  icon: Icons.icon_name,
  color: Color(0xFFHEXCODE),
),
```

### Customizing Theme

Edit [app_theme.dart](lib/core/theme/app_theme.dart):

- Change primary colors
- Modify gradients
- Update text styles
- Adjust spacing constants

## Common Tasks

### 1. Modify User Initial State

Edit [user_provider.dart](lib/providers/user_provider.dart):

```dart
UserProfileNotifier()
    : super(UserProfile(
        id: 'user-1',
        name: 'YourName',
        totalPoints: 0,
        currentStreak: 0,
        // ...
      ));
```

### 2. Change Points System

Edit [quiz_progress_provider.dart](lib/providers/quiz_progress_provider.dart):

```dart
final pointsEarned = (state!.score * 10) +  // Points per question
                    (state!.score == quiz.questions.length ? 50 : 0); // Bonus
```

### 3. Add Animation

Import the animations package and wrap widgets:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  // properties
)
```

### 4. Add New Screen to Navigation

1. Create screen file in `screens/` directory
2. Import in [main.dart](lib/main.dart)
3. Add to screens list in `AppNavigator`
4. Add navigation item in [main_navigation.dart](lib/screens/navigation/main_navigation.dart)

## Responsive Design Guidelines

All widgets should use MediaQuery for responsive sizing:

```dart
final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;

// Use percentage-based sizing
width: screenWidth * 0.9,  // 90% of screen width
padding: EdgeInsets.all(screenWidth * 0.05),  // 5% padding
```

## Color Usage Guide

```dart
// Primary UI elements
AppTheme.primaryTeal
AppTheme.primaryBlue

// Accents
AppTheme.accentGreen   // Success, positive actions
AppTheme.accentOrange  // Streak, fire
AppTheme.accentYellow  // Points, stars

// Backgrounds
AppTheme.backgroundLight
AppTheme.cardBackground

// Text
AppTheme.textPrimary
AppTheme.textSecondary
AppTheme.textLight

// Status
AppTheme.successGreen
AppTheme.errorRed
```

## Testing

### Widget Testing

```dart
testWidgets('Home screen displays user name', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: HomeScreen()),
    ),
  );
  
  expect(find.text('Alex'), findsOneWidget);
});
```

### Provider Testing

```dart
test('User profile updates points correctly', () {
  final container = ProviderContainer();
  
  container.read(userProfileProvider.notifier).updatePoints(100);
  
  expect(
    container.read(userProfileProvider).totalPoints,
    equals(1300), // 1200 initial + 100
  );
});
```

## Performance Tips

1. **Use const constructors** where possible
2. **Avoid rebuilds** with `ref.read()` for one-time reads
3. **Extract widgets** into separate files for better tree shaking
4. **Use ListView.builder** for long lists
5. **Optimize images** and use cached network images

## Debugging

### Print Provider State

```dart
ref.listen(userProfileProvider, (previous, next) {
  print('User profile changed: $next');
});
```

### Debug Layout

```dart
// Add border to see widget boundaries
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.red),
  ),
  child: YourWidget(),
)
```

## Common Issues & Solutions

### Issue: Hot reload not working
**Solution**: Try hot restart (Shift+R) instead

### Issue: Provider not updating UI
**Solution**: Make sure you're using `ref.watch()` not `ref.read()`

### Issue: Layout overflow
**Solution**: Wrap with SingleChildScrollView or use Flexible/Expanded

### Issue: Colors not showing
**Solution**: Check if gradient is properly defined and Material widget exists

## Best Practices

1. ✅ Always use `const` for static widgets
2. ✅ Extract complex widgets into separate files
3. ✅ Use meaningful variable names
4. ✅ Add comments for complex logic
5. ✅ Keep provider logic separate from UI
6. ✅ Use `copyWith` for model updates
7. ✅ Handle null safety properly
8. ✅ Use `MediaQuery` for responsive design

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design Guidelines](https://m3.material.io/)
- [Google Fonts](https://fonts.google.com/)

## Support

For issues or questions:
1. Check existing issues in project repository
2. Review Flutter and Riverpod documentation
3. Create a new issue with detailed description

---

Happy coding! 🚀
