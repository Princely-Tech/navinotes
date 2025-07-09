import 'package:navinotes/packages.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('navinotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE boards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      type TEXT,
      name TEXT,
      customization TEXT,
      is_public INTEGER DEFAULT 0,
      description TEXT,
      subject TEXT,
      level TEXT,
      term TEXT,
      cover_image TEXT,
      created_at INTEGER,
      updated_at INTEGER,
      synced_at INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE contents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      meta_data TEXT,
      board_id INTEGER,
      tags TEXT,
      content TEXT,
      file TEXT,
      created_at INTEGER,
      updated_at INTEGER,
      synced_at INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE tags (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      name TEXT,
      created_at INTEGER,
      updated_at INTEGER,
      synced_at INTEGER
    )
    ''');
  }

  // Example CRUD for Boards
  Future<int> insertBoard(Board board) async {
    final db = await instance.database;
    return await db.insert('boards', board.toMap());
  }

  Future<int> insertContent(Content content) async {
    final db = await instance.database;
    return await db.insert('contents', content.toMap());
  }

  Future<int> insertTags(Tag tag) async {
    final db = await instance.database;
    return await db.insert('tags', tag.toMap());
  }

  Future<List<Board>> getAllBoards() async {
    final db = await instance.database;
    final result = await db.query('boards');
    return result.map((json) => Board.fromMap(json)).toList();
  }


  Future<Board> getBoard(int boardId) async {
    final db = await instance.database;
    final result = await db.query('boards', where: 'id = ?', whereArgs: [boardId]);
    return result.map((json) => Board.fromMap(json)).first;
  }

  Future<List<Content>> getAllContents(int boardId) async {
    final db = await instance.database;
    final result = await db.query(
      'contents',
      where: 'board_id = ?',
      whereArgs: [boardId],
    );
    return result.map((json) => Content.fromMap(json)).toList();
  }

  Future<List<Tag>> getAllTags() async {
    final db = await instance.database;
    final result = await db.query('tags');
    return result.map((json) => Tag.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
