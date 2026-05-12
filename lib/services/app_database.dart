import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/app_user.dart';
import '../models/repository_item.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const _databaseName = 'fluidocs.db';
  static const _databaseVersion = 2;
  static const _repositoriesTable = 'repositories';
  static const _usersTable = 'users';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await databaseFactoryFfiWeb.openDatabase(
      _databaseName,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _createDatabase,
        onUpgrade: _upgradeDatabase,
      ),
    );

    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await _createRepositoriesTable(db);
    await _createUsersTable(db);
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createUsersTable(db);
      await db.delete(
        _repositoriesTable,
        where: 'title = ? AND url = ?',
        whereArgs: ['Documentos RH', 'https://drive.google.com/rh'],
      );
    }
  }

  Future<void> _createRepositoriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_repositoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        type TEXT NOT NULL,
        tags TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<List<RepositoryItem>> getRepositories() async {
    final db = await database;
    final rows = await db.query(_repositoriesTable, orderBy: 'created_at DESC');

    return rows.map(RepositoryItem.fromMap).toList();
  }

  Future<RepositoryItem> insertRepository(RepositoryItem repository) async {
    final db = await database;
    final id = await db.insert(_repositoriesTable, repository.toMap());

    return repository.copyWith(id: id);
  }

  Future<void> deleteRepository(int id) async {
    final db = await database;
    await db.delete(_repositoriesTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<AppUser> insertUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;
    final user = AppUser(
      name: name,
      email: email.trim().toLowerCase(),
      passwordHash: AppUser.hashPassword(password),
    );

    final id = await db.insert(_usersTable, user.toMap());

    return AppUser(
      id: id,
      name: user.name,
      email: user.email,
      passwordHash: user.passwordHash,
      createdAt: user.createdAt,
    );
  }

  Future<AppUser?> findUserByEmail(String email) async {
    final db = await database;
    final rows = await db.query(
      _usersTable,
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return AppUser.fromMap(rows.first);
  }

  Future<AppUser?> authenticateUser({
    required String email,
    required String password,
  }) async {
    final user = await findUserByEmail(email);
    if (user == null) return null;

    final passwordHash = AppUser.hashPassword(password);
    if (user.passwordHash != passwordHash) return null;

    return user;
  }
}
