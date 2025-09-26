import 'package:navinotes/models/notebook_page.dart';
import 'package:navinotes/models/tag.dart';
import 'package:navinotes/packages.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  static const int _databaseVersion = 1; // Increment this number

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('navi_notes_db_dev.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // Use WebAssembly-backed SQLite on web
      databaseFactory = databaseFactoryFfiWeb;
      return await databaseFactory.openDatabase(
        filePath,
        options: OpenDatabaseOptions(
          version: _databaseVersion,
          onCreate: _createDB,
          onUpgrade: _onUpgrade,
        ),
      );
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    }
  }

  // all id are gui. Generated when creating the models.
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE boards (
      id TEXT,
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
      course_info TEXT,
      course_timelines TEXT,
      syllabus_content_id TEXT DEFAULT NULL,
      created_at INTEGER,
      updated_at INTEGER,
      synced_at INTEGER
    );
    ''');

    await db.execute('''
   CREATE TABLE flashcards (
  id TEXT,
  difficulty TEXT,
  deck_id TEXT,
  front TEXT,
  back TEXT,
  tags TEXT,            -- optional
  created_at INTEGER,
  updated_at INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE contents (
      id TEXT,
      type TEXT,
      meta_data TEXT,
      board_id TEXT,
      title TEXT,
      cover_image TEXT,
      tags TEXT,
      content TEXT,
      drawing TEXT,
      file TEXT,
      created_at INTEGER,
      voice_notes TEXT,

      cover_image_need_sync INTEGER DEFAULT 0,
      file_need_sync INTEGER DEFAULT 0,

      updated_at INTEGER,
      synced_at INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE tags (
      id TEXT,
      user_id INTEGER,
      name TEXT,
      created_at INTEGER,
      updated_at INTEGER,
      synced_at INTEGER
    )
    ''');


    await db.execute('''
    CREATE TABLE notebook_pages (
      id TEXT PRIMARY KEY,
      notebook_id TEXT,
      page_number INTEGER,
      template_data TEXT,
      handwriting_data TEXT,
      text_content TEXT,
      drawing_data TEXT,
      text_boxes TEXT,
      voice_notes TEXT,
      annotations TEXT,
      has_content INTEGER DEFAULT 0,
      created_at INTEGER,
      updated_at INTEGER,
    )
    ''');

    await db.execute('''
    CREATE TABLE paper_templates (
      id TEXT PRIMARY KEY,
      name TEXT,
      size TEXT,
      type TEXT,
      color TEXT,
      line_spacing TEXT,
      show_margins INTEGER DEFAULT 1,
      margin_left REAL DEFAULT 72.0,
      margin_right REAL DEFAULT 72.0,
      margin_top REAL DEFAULT 72.0,
      margin_bottom REAL DEFAULT 72.0,
      is_custom INTEGER DEFAULT 0,
      created_at INTEGER,
      updated_at INTEGER
    )
    ''');
  }

  // Add this new method to handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // Example CRUD for Boards
  Future<bool> insertBoard(Board board) async {
    final db = await instance.database;
    return 0 != await db.insert('boards', board.toMap());
  }

  Future<bool> insertContent(Content content) async {
    final db = await instance.database;
    // content.syncToBackend(apiServiceProvider); //TODO Work on synching created files to backend
    return 0 != await db.insert('contents', content.toMap());
  }

  Future<bool> insertTags(Tag tag) async {
    final db = await instance.database;
    return 0 != await db.insert('tags', tag.toMap());
  }

  Future<List<Board>> getAllBoards() async {
    final db = await instance.database;
    final result = await db.query(
      'boards',
      orderBy: 'updated_at DESC, created_at DESC',
    );
    debugPrint(result.toString());
    return result.map((json) => Board.fromMap(json)).toList();
  }

  Future<Board> getBoard(String boardId) async {
    final db = await instance.database;
    final result = await db.query(
      'boards',
      where: 'id = ?',
      whereArgs: [boardId],
    );
    debugPrint('Getting board $boardId');
    debugPrint(result.toString());
    return result.map((json) => Board.fromMap(json)).first;
  }

  Future<List<Content>> getAllContents(String boardId) async {
    final db = await instance.database;
    debugPrint('Getting contents of $boardId');
    final result = await db.query(
      'contents',
      where: 'board_id = ?',
      whereArgs: [boardId],
      orderBy: 'updated_at DESC, created_at DESC',
    );
    return result.map((json) => Content.fromMap(json)).toList();
  }

  Future<List<Content>> getAllFiles(String boardId) async {
    final contents = await getAllContents(boardId);
    return contents.where((c) => c.type == AppContentType.file).toList();
  }

  Future<List<Content>> getAllNotes(
    String boardId, {
    NoteSortType sortType = NoteSortType.updatedAt,
  }) async {
    List<Content> notes = await getAllContents(boardId);
    return notes.where((note) => note.type == AppContentType.note).toList();
  }

  Future<Content?> getContentById(String contentId) async {
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

  Future<bool> deleteContent(String contentId) async {
    final db = await instance.database;
    return 0 !=
        await db.delete('contents', where: 'id = ?', whereArgs: [contentId]);
  }

  Future<List<Content>> getRecentContentsAcrossAllBoards({
    int limit = 10,
  }) async {
    final db = await instance.database;
    final result = await db.query(
      'contents',
      orderBy: 'updated_at DESC',
      limit: limit,
    );
    return result.map((map) => Content.fromMap(map)).toList();
  }

  Future<bool> updateContent(Content content) async {
    final db = await instance.database;
    debugPrint('Updating content ${content.id}');
    return 0 !=
        await db.update(
          'contents',
          content.toMap(),
          where: 'id = ?',
          whereArgs: [content.id],
        );
  }

  Future<bool> updateBoard(Board board) async {
    final db = await instance.database;
    debugPrint('Updating board ${board.id}');
    return 0 !=
        await db.update(
          'boards',
          board.toMap(),
          where: 'id = ?',
          whereArgs: [board.id],
        );
  }

  Future<List<Tag>> getAllTags() async {
    final db = await instance.database;
    final result = await db.query('tags');
    return result.map((json) => Tag.fromMap(json)).toList();
  }

  // Insert flashcard
  Future<bool> insertFlashCard(FlashCard flashcard) async {
    final db = await instance.database;
    final id = await db.insert('flashcards', flashcard.toMap());
    return 0 != id;
  }

  // Get all flashcards for a deck
  Future<List<FlashCard>> getDeckFlashCards(String deckId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'deck_id = ?',
      whereArgs: [deckId],
      orderBy: 'updated_at DESC, created_at DESC',
    );

    return List.generate(maps.length, (i) => FlashCard.fromMap(maps[i]));
  }

  // Get all flashcards for a deck
  Future<int> getDeckCardsCount(String deckId) async {
    final db = await instance.database;
    final result = await db.query(
      'flashcards',
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );
    return result.length;
  }

  // Update a flashcard
  Future<bool> updateFlashCard(FlashCard flashcard) async {
    final db = await instance.database;
    return 0 !=
        await db.update(
          'flashcards',
          flashcard.toMap(),
          where: 'id = ?',
          whereArgs: [flashcard.id],
        );
  }

  // Delete a flashcard
  Future<bool> deleteFlashCard(String id) async {
    final db = await instance.database;
    return 0 != await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Content>> getBoardDecks(String boardId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'contents',
      where: 'board_id = ? AND type = ?',
      whereArgs: [boardId, AppContentType.flashcardDeck.toString()],
      orderBy: 'updated_at DESC, created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Content.fromMap(maps[i]);
    });
  }

  Future<Content?> getDeck(String id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contents',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Content.fromMap(maps.first);
    }
    return null;
  }


  // NotebookPage CRUD Operations
  Future<bool> insertNotebookPage(NotebookPage page) async {
    final db = await instance.database;
    return 0 != await db.insert('notebook_pages', page.toMap());
  }

  Future<NotebookPage?> getNotebookPage(String pageId) async {
    final db = await instance.database;
    final result = await db.query(
      'notebook_pages',
      where: 'id = ?',
      whereArgs: [pageId],
    );
    if (result.isNotEmpty) {
      return NotebookPage.fromMap(result.first);
    }
    return null;
  }

  Future<List<NotebookPage>> getPagesForNotebook(String notebookId) async {
    final db = await instance.database;
    final result = await db.query(
      'notebook_pages',
      where: 'notebook_id = ?',
      whereArgs: [notebookId],
      orderBy: 'page_number ASC',
    );
    return result.map((json) => NotebookPage.fromMap(json)).toList();
  }

  Future<bool> updateNotebookPage(NotebookPage page) async {
    final db = await instance.database;
    return 0 != await db.update(
      'notebook_pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<bool> deleteNotebookPage(String pageId) async {
    final db = await instance.database;
    return 0 != await db.delete('notebook_pages', where: 'id = ?', whereArgs: [pageId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
