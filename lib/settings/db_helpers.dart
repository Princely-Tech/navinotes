import 'package:navinotes/models/tag.dart';
import 'package:navinotes/packages.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  static const int _databaseVersion = 3; // Increment this number

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('navinotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE boards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      guid TEXT,
      user_id INTEGER,
      type TEXT,
      name TEXT,
      customization TEXT,
      is_public INTEGER DEFAULT 0,
      cover_image_need_sync INTEGER DEFAULT 0,
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
      guid TEXT,
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      meta_data TEXT,
      board_id INTEGER,
      title TEXT,
      cover_image TEXT,
      tags TEXT,
      content TEXT,
      file TEXT,
      created_at INTEGER,

      cover_image_need_sync INTEGER DEFAULT 0,
      file_need_sync INTEGER DEFAULT 0,

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

  // Add this new method to handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the guid column to the boards table
      await db.execute('ALTER TABLE boards ADD COLUMN guid TEXT');

      // get all boards with null guid and update it
      final boards = await db.query('boards', where: 'guid IS NULL');
      for (var board in boards) {
        final guid = "0${board['user_id']}0_${Uuid().v4()}";
        await db.update(
          'boards',
          {'guid': guid},
          where: 'id = ?',
          whereArgs: [board['id']],
        );
      }
    }

    if (oldVersion < 3) {
      await db.execute('ALTER TABLE contents ADD COLUMN title TEXT');
      await db.execute('ALTER TABLE contents ADD COLUMN cover_image TEXT');
    }

    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE boards ADD COLUMN cover_image_need_sync INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE contents ADD COLUMN cover_image_need_sync INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE contents ADD COLUMN file_need_sync INTEGER DEFAULT 0',
      );
    }
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

  Future<List<Board>> getAllBoards({
    NoteSortType sortType = NoteSortType.updatedAt,
  }) async {
    String sortOrder = 'DESC';
    if (sortType == NoteSortType.createdAt) {
      sortOrder = 'ASC';
    }
    final sortBy = sortType.toString();
    final db = await instance.database;
    final result = await db.query('boards', orderBy: '$sortBy $sortOrder');
    return result.map((json) => Board.fromMap(json)).toList();
  }

  Future<Board> getBoard(int boardId) async {
    final db = await instance.database;
    final result = await db.query(
      'boards',
      where: 'id = ?',
      whereArgs: [boardId],
    );
    return result.map((json) => Board.fromMap(json)).first;
  }

  Future<List<Content>> getAllContents(
    int boardId, {
    NoteSortType sortType = NoteSortType.updatedAt,
  }) async {
    String sortOrder = 'DESC';
    if (sortType == NoteSortType.createdAt) {
      sortOrder = 'ASC';
    }
    final db = await instance.database;
    final sortBy = sortType.toString();
    debugPrint('Getting contents of $boardId sorted by $sortBy $sortOrder');
    final result = await db.query(
      'contents',
      where: 'board_id = ?',
      whereArgs: [boardId],
      orderBy: '$sortBy $sortOrder',
    );
    return result.map((json) => Content.fromMap(json)).toList();
  }

  Future<List<Content>> getAllNotes(
    int boardId, {
    NoteSortType sortType = NoteSortType.updatedAt,
  }) async {
    List<Content> notes = await getAllContents(boardId);
    return notes.where((note) => note.type == AppContentType.note).toList();
  }

  Future<Content?> getContentById(int contentId) async {
    final db = await instance.database;
    final result = await db.query(
      'contents',
      where: 'id = ?',
      whereArgs: [contentId],
    );
    debugPrint('Getting content $contentId');

    if (result.isNotEmpty) {
      return Content.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContent(int contentId) async {
    final db = await instance.database;
    return await db.delete('contents', where: 'id = ?', whereArgs: [contentId]);
  }

  Future<int> updateContent(Content content) async {
    final db = await instance.database;
    debugPrint('Updating content ${content.id}');
    return await db.update(
      'contents',
      content.toMap(),
      where: 'id = ?',
      whereArgs: [content.id],
    );
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
