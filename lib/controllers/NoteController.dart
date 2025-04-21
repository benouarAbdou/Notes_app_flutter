import 'package:get/get.dart';
import 'package:notes/models/note.dart';
import 'package:notes/myDataBase.dart';

class NoteController extends GetxController {
  final notes = <Note>[].obs;
  final filteredNotes = <Note>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
    // Listen to search query changes
    ever(searchQuery, (_) => filterNotes());
  }

  Future<void> fetchNotes() async {
    try {
      final database = SqlDb();
      final List<Map<String, dynamic>> data =
          await database.readData('SELECT * FROM note');
      final fetchedNotes = data.map((item) => Note.fromMap(item)).toList();
      notes.assignAll(fetchedNotes);
      filteredNotes.assignAll(fetchedNotes);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notes: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  void filterNotes() {
    final query = searchQuery.value.toLowerCase();
    filteredNotes.assignAll(
      notes.where((note) =>
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query)),
    );
  }

  Future<void> deleteNote(int id) async {
    try {
      final database = SqlDb();
      await database.deleteData('DELETE FROM note WHERE noteId = $id');
      Get.snackbar('Success', 'Note deleted',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      await fetchNotes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete note: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  Future<void> addOrUpdateNote({
    int? id,
    required String title,
    required String content,
    required DateTime date,
  }) async {
    try {
      final database = SqlDb();
      // Escape single quotes in title and content to prevent SQL injection
      final escapedTitle = title.replaceAll("'", "''");
      final escapedContent = content.replaceAll("'", "''");

      if (id != null) {
        // Update existing note
        final sql = '''
        UPDATE note 
        SET title = '$escapedTitle', 
            content = '$escapedContent'
        WHERE noteId = $id
        ''';
        await database.updateData(sql);
      } else {
        // Insert new note
        final sql = '''
        INSERT INTO note (title, content, iconColorIndex, date)
        VALUES ('$escapedTitle', '$escapedContent', 0, '${date.toIso8601String()}')
        ''';
        await database.insertData(sql);
      }
      await fetchNotes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save note: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }
}
