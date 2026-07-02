import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../models/category_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_sepeti.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE categories (
  id $idType,
  name $textType
)
''');

    await db.execute('''
CREATE TABLE notes (
  id $idType,
  title $textType,
  content $textType,
  categoryName $textType,
  priority $textType,
  createdAt $textType
)
''');

    // Prepopulate default categories
    final defaultCategories = ['Genel', 'Spor', 'Aile', 'Okul'];
    for (var cat in defaultCategories) {
      await db.insert('categories', {'name': cat});
    }
  }

  // --- Category Operations ---
  Future<int> createCategory(String name) async {
    final db = await instance.database;
    return await db.insert('categories', {'name': name});
  }

  Future<List<Category>> getCategories() async {
    final db = await instance.database;
    final result = await db.query('categories');
    return result.map((json) => Category.fromMap(json)).toList();
  }

  Future<int> deleteCategory(String categoryName) async {
    final db = await instance.database;
    // Delete notes associated with this category
    await db.delete('notes', where: 'categoryName = ?', whereArgs: [categoryName]);
    // Delete the category itself
    return await db.delete('categories', where: 'name = ?', whereArgs: [categoryName]);
  }

  // --- Note Operations ---
  Future<int> createNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'createdAt DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
