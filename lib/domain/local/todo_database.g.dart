// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $TodoDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $TodoDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $TodoDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<TodoDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorTodoDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TodoDatabaseBuilderContract databaseBuilder(String name) =>
      _$TodoDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TodoDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$TodoDatabaseBuilder(null);
}

class _$TodoDatabaseBuilder implements $TodoDatabaseBuilderContract {
  _$TodoDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $TodoDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $TodoDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<TodoDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TodoDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TodoDatabase extends TodoDatabase {
  _$TodoDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Todo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'Todo',
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description
                }),
        _todoDeletionAdapter = DeletionAdapter(
            database,
            'Todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  final DeletionAdapter<Todo> _todoDeletionAdapter;

  @override
  Future<List<Todo>> findAllTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Todo',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String));
  }

  @override
  Future<void> insertTodo(Todo todo) async {
    await _todoInsertionAdapter.insert(todo, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await _todoDeletionAdapter.delete(todo);
  }
}
