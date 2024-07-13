# Flutter Notes App

## Introduction

The Flutter Notes App is a simple yet powerful note-taking application built using Flutter. It allows users to create, read, update, and delete notes, with a clean and intuitive user interface. The app supports both light and dark themes and uses local storage to persist notes.

## Features

- Create new notes with title and content
- View list of all notes in a grid layout
- Search notes by title or content
- Edit existing notes
- Delete notes with swipe-to-delete functionality
- Dark mode support with theme toggle
- Persistent storage using SQLite database

## Technologies Used

- Flutter SDK
- Dart programming language
- SQLite for local database storage
- Provider package for state management
- flutter_slidable package for swipe actions
- shared_preferences package for theme persistence

## Project Structure

The project is structured as follows:

- `lib/`
  - `main.dart`: Entry point of the application
  - `Components/`: Custom widgets used in the app
  - `pages/`: Individual pages/screens of the app
  - `provider/`: State management using Provider
  - `myDataBase.dart`: SQLite database operations
- `assets/`: Contains app assets (if any)

## Usage

1. Launch the app to view the list of notes.
2. Tap the floating action button to create a new note.
3. Tap on a note to view or edit its details.
4. Swipe left on a note to delete it.
5. Use the search bar at the top to filter notes.
6. Toggle between light and dark themes using the icon in the app bar.

## Theming

The app supports both light and dark themes:

- Light theme: White background with blue accents
- Dark theme: Dark background with teal accents

Theme preferences are persisted using SharedPreferences.

## Database

The app uses SQLite for local storage of notes. The database operations are encapsulated in the `SqlDb` class in `myDataBase.dart`. This includes:

- Creating and initializing the database
- CRUD operations for notes (Create, Read, Update, Delete)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
