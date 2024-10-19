
# Flutter Social App

This is a simple Flutter-based social app that allows users to sign up, log in, add posts, like posts, and comment on them. The app uses the `provider` package for state management, making it easy to manage user authentication and post operations.

## Features

- **User Sign Up and Login**: Users can create accounts and log in.
- **Add Posts**: Users can add posts with images and text.
- **Like Posts**: Users can like posts.
- **Comment on Posts**: Users can add comments on posts.
- **State Management**: Uses `Provider` for state management across the app.
- **SQLite Database**: Stores data using SQLite through the custom `DbHelper` class.

## Video
https://github.com/user-attachments/assets/818ecf71-e213-4051-92e0-66fafaf4090b

## Dependencies

The following dependencies are used in this project:

- **Flutter**: The main framework for building the app.
- **Provider**: For state management.
- **Shared Preferences**: To store user sessions.
- **Image Picker**: To allow users to select images for their posts.
- **Intl**: To format date and time in the app.

Add these dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  image_picker: ^0.8.5+3
  intl: ^0.17.0
```

## Project Structure

Here is an overview of the main folders and files:

```
lib/
├── helper/
│   └── db_helper.dart  # Handles SQLite operations
├── provider/
│   ├── log_in_provider.dart  # Manages user login state
│   ├── post_provider.dart  # Manages post-related state
│   └── sign_up_provider.dart  # Manages user signup state
├── views/
│   ├── pages/
│   │   ├── add_post_page.dart  # Screen for adding posts
│   │   ├── home_page.dart  # Main screen displaying posts
│   │   ├── login_page.dart  # Login screen
│   │   ├── sign_up.dart  # Sign up screen
│   │   └── splash_screen.dart  # Splash screen
├── main.dart  # Entry point of the application
```

## How to Run

1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/flutter-social-app.git
    ```

2. Navigate to the project directory:
    ```bash
    cd flutter-social-app
    ```

3. Install the dependencies:
    ```bash
    flutter pub get
    ```

4. Run the app on your connected device or emulator:
    ```bash
    flutter run
    ```

## Routes

The app uses named routes to navigate between pages. Here are the routes defined in the `MaterialApp`:

- **`splash`**: The splash screen route.
- **`/`**: The home page route (after login).
- **`sign_up`**: The sign-up page.
- **`login`**: The login page.
- **`add_post`**: The add post page.

## Providers

The app uses three main providers for state management:

1. **SignUpProvider**: Handles user sign-up logic.
2. **LoginProvider**: Manages login and authentication state.
3. **PostProvider**: Handles all the operations related to posts (like fetching, adding, editing, and deleting posts).
