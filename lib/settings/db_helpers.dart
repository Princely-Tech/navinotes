import 'package:navinotes/models/tag.dart';
import 'package:navinotes/packages.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  static const int _databaseVersion = 6; // Increment this number

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
      mind_map_data TEXT,
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
  sort_order INTEGER DEFAULT 0, -- for card ordering
  last_reviewed INTEGER DEFAULT 0,
  next_review INTEGER DEFAULT 0,
  interval_days INTEGER DEFAULT 1,
  ease_factor REAL DEFAULT 2.5,
  review_count INTEGER DEFAULT 0,
  streak INTEGER DEFAULT 0,
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
      synced_at INTEGER,

      -- Mind Map Node fields
      mind_map_x REAL,
      mind_map_y REAL,
      connected_content_ids TEXT,
      node_color TEXT,
      node_shape TEXT,
      node_width REAL,
      node_height REAL
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
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
     ALTER TABLE boards ADD COLUMN mind_map_data TEXT;
      ''');
    }

    if (oldVersion < 3) {
      // Add mind map node fields to contents table
      await db.execute('ALTER TABLE contents ADD COLUMN mind_map_x REAL;');
      await db.execute('ALTER TABLE contents ADD COLUMN mind_map_y REAL;');
      await db.execute(
        'ALTER TABLE contents ADD COLUMN connected_content_ids TEXT;',
      );
      await db.execute('ALTER TABLE contents ADD COLUMN node_color TEXT;');
      await db.execute('ALTER TABLE contents ADD COLUMN node_shape TEXT;');
      await db.execute('ALTER TABLE contents ADD COLUMN node_width REAL;');
      await db.execute('ALTER TABLE contents ADD COLUMN node_height REAL;');
    }

    if (oldVersion < 4) {
      // Add sort_order field to flashcards table
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN sort_order INTEGER DEFAULT 0;',
      );
    }

    if (oldVersion < 6) {
      // Add spaced repetition fields to flashcards table
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN last_reviewed INTEGER DEFAULT 0;',
      );
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN next_review INTEGER DEFAULT 0;',
      );
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN interval_days INTEGER DEFAULT 1;',
      );
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN ease_factor REAL DEFAULT 2.5;',
      );
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN review_count INTEGER DEFAULT 0;',
      );
      await db.execute(
        'ALTER TABLE flashcards ADD COLUMN streak INTEGER DEFAULT 0;',
      );
      
      // Initialize next_review for existing cards (set to current time + 1 day)
      final currentTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      final nextReviewDefault = currentTime + (24 * 60 * 60);
      await db.execute(
        'UPDATE flashcards SET next_review = ? WHERE next_review = 0;',
        [nextReviewDefault],
      );
    }
  }

  // Example CRUD for Boards
  Future<bool> insertBoard(Board board) async {
    final db = await instance.database;
    return 0 != await db.insert('boards', board.toMap());
  }

  Future<bool> insertContent(Content content) async {
    final db = await instance.database;

    // Insert the content first
    final result = 0 != await db.insert('contents', content.toMap());

    if (result) {
      // Auto-add content node to board's mind map
      await _addContentNodeToBoard(content);
    }

    // content.syncToBackend(apiServiceProvider); //TODO Work on synching created files to backend
    return result;
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

  Future<List<Content>> getAllContentsByType(
    String boardId,
    AppContentType type,
  ) async {
    final db = await instance.database;
    debugPrint('Getting contents of $boardId');
    final result = await db.query(
      'contents',
      where: 'board_id = ? AND type = ?',
      whereArgs: [boardId, type.toString()],
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

    // Get the content before deleting to remove from mind map
    final content = await getContentById(contentId);

    final result =
        0 !=
        await db.delete('contents', where: 'id = ?', whereArgs: [contentId]);

    if (result && content != null) {
      // Auto-remove content node from board's mind map
      await _removeContentNodeFromBoard(content);
    }

    return result;
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

  /// Check for contents with invalid types (types not in AppContentType enum)
  Future<List<Map<String, dynamic>>> getContentsWithInvalidTypes({
    String? boardId,
  }) async {
    final db = await instance.database;

    // Get all valid AppContentType values as strings
    final validTypes = AppContentType.values.map((e) => e.toString()).toList();

    String whereClause =
        'type NOT IN (${validTypes.map((_) => '?').join(', ')})';
    List<dynamic> whereArgs = validTypes;

    // Optionally filter by board
    if (boardId != null) {
      whereClause += ' AND board_id = ?';
      whereArgs.add(boardId);
    }

    final invalidContents = await db.query(
      'contents',
      where: whereClause,
      whereArgs: whereArgs,
    );

    debugPrint(
      'Found ${invalidContents.length} contents with invalid types${boardId != null ? ' in board $boardId' : ''}:',
    );
    for (final content in invalidContents) {
      debugPrint(
        '  - ID: ${content['id']}, Type: ${content['type']}, Title: ${content['title']}, Board: ${content['board_id']}',
      );
    }

    return invalidContents;
  }

  /// Delete all contents with invalid types (types not in AppContentType enum)
  Future<int> deleteContentsWithInvalidTypes({String? boardId}) async {
    final db = await instance.database;

    // Get all valid AppContentType values as strings
    final validTypes = AppContentType.values.map((e) => e.toString()).toList();
    debugPrint('Valid content types: $validTypes');

    // First check what we're about to delete
    final invalidContents = await getContentsWithInvalidTypes(boardId: boardId);

    if (invalidContents.isEmpty) {
      debugPrint('No contents with invalid types found');
      return 0;
    }

    String whereClause =
        'type NOT IN (${validTypes.map((_) => '?').join(', ')})';
    List<dynamic> whereArgs = validTypes;

    // Optionally filter by board
    if (boardId != null) {
      whereClause += ' AND board_id = ?';
      whereArgs.add(boardId);
    }

    // Delete contents with invalid types
    final deletedCount = await db.delete(
      'contents',
      where: whereClause,
      whereArgs: whereArgs,
    );

    debugPrint(
      'Deleted $deletedCount contents with invalid types${boardId != null ? ' from board $boardId' : ''}',
    );
    return deletedCount;
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
    final success = 0 != id;

    // Update parent deck's timestamp when flashcard is created
    if (success) {
      await _updateDeckTimestamp(flashcard.deckId);
    }

    return success;
  }

  // Get all flashcards for a deck
  Future<List<FlashCard>> getDeckFlashCards(String deckId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'deck_id = ?',
      whereArgs: [deckId],
      orderBy:
          'sort_order ASC, created_at ASC', // Order by sort_order first, then creation time
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
    final success =
        0 !=
        await db.update(
          'flashcards',
          flashcard.toMap(),
          where: 'id = ?',
          whereArgs: [flashcard.id],
        );

    // Update parent deck's timestamp when flashcard is updated
    if (success) {
      await _updateDeckTimestamp(flashcard.deckId);
    }

    return success;
  }

  // Delete a flashcard
  Future<bool> deleteFlashCard(String id) async {
    final db = await instance.database;

    // First get the flashcard to find its deckId
    final result = await db.query(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      final deckId = result.first['deck_id'] as String;
      final success =
          0 != await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);

      // Update parent deck's timestamp when flashcard is deleted
      if (success) {
        await _updateDeckTimestamp(deckId);
      }

      return success;
    }

    return false;
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

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  /// Automatically add a content node to the board's mind map
  Future<void> _addContentNodeToBoard(Content content) async {
    try {
      // Get the board
      final board = await getBoard(content.boardId);

      // Add content node to board's mind map
      final updatedBoard = board.addContentNode(content);

      // Save the updated board
      await updateBoard(updatedBoard);

      debugPrint(
        'Added content node ${content.id} to board ${board.id} mind map',
      );
    } catch (e) {
      debugPrint('Error adding content node to board mind map: $e');
    }
  }

  /// Automatically remove a content node from the board's mind map
  Future<void> _removeContentNodeFromBoard(Content content) async {
    try {
      // Get the board
      final board = await getBoard(content.boardId);

      // Remove content node from board's mind map
      final updatedBoard = board.removeContentNode(content.id);

      // Save the updated board
      await updateBoard(updatedBoard);

      debugPrint(
        'Removed content node ${content.id} from board ${board.id} mind map',
      );
    } catch (e) {
      debugPrint('Error removing content node from board mind map: $e');
    }
  }

  // Update card sort orders for reordering
  Future<void> updateCardSortOrders(List<FlashCard> cards) async {
    final db = await instance.database;

    // Use batch operation for better performance
    final batch = db.batch();

    for (int i = 0; i < cards.length; i++) {
      batch.update(
        'flashcards',
        {'sort_order': i},
        where: 'id = ?',
        whereArgs: [cards[i].id],
      );
    }

    await batch.commit();
  }

  // Get the next sort order for new cards (to add at bottom)
  Future<int> getNextSortOrder(String deckId) async {
    final db = await instance.database;

    final result = await db.query(
      'flashcards',
      columns: ['MAX(sort_order) as max_order'],
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );

    final maxOrder = result.first['max_order'] as int?;
    return (maxOrder ?? -1) + 1;
  }

  // Helper method to update deck's timestamp when flashcards are modified
  Future<void> _updateDeckTimestamp(String deckId) async {
    try {
      // Get the deck (Content)
      final deck = await getContentById(deckId);
      if (deck != null) {
        // Update deck's timestamp
        final updatedDeck = deck.getUpdatedContent(
          updatedAt: generateUnixTimestamp(),
        );
        await updateContent(updatedDeck);
        debugPrint('Updated deck timestamp for deck: $deckId');
      }
    } catch (e) {
      debugPrint('Error updating deck timestamp: $e');
    }
  }

  // Fix invalid timestamps for existing decks
  Future<void> fixInvalidDeckTimestamps() async {
    try {
      final db = await instance.database;

      // Get all flashcard decks
      final result = await db.query(
        'contents',
        where: 'type = ?',
        whereArgs: [AppContentType.flashcardDeck.toString()],
      );

      int fixedCount = 0;
      for (final deckMap in result) {
        final updatedAt = deckMap['updated_at'] as int;

        // Check if timestamp is invalid (too large - likely in milliseconds instead of seconds)
        // Valid Unix timestamp in seconds should be around 1700000000 (year 2023)
        // If it's > 2000000000000 (around year 2033 in milliseconds), it's likely wrong
        if (updatedAt > 2000000000000) {
          // Convert from milliseconds to seconds
          final correctedTimestamp = updatedAt ~/ 1000;

          await db.update(
            'contents',
            {'updated_at': correctedTimestamp},
            where: 'id = ?',
            whereArgs: [deckMap['id']],
          );

          fixedCount++;
          debugPrint(
            'Fixed invalid timestamp for deck ${deckMap['id']}: $updatedAt -> $correctedTimestamp',
          );
        }
      }

      if (fixedCount > 0) {
        debugPrint('Fixed $fixedCount deck timestamps');
      }
    } catch (e) {
      debugPrint('Error fixing deck timestamps: $e');
    }
  }
}
