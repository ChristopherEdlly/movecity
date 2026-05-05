import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/displacement_model.dart';
import '../models/route_model.dart';

class DatabaseHelper {
  static const _databaseName = 'movecity.db';
  static const _databaseVersion = 1;

  static const tableRoutes = 'routes';
  static const tableDisplacements = 'displacements';

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableRoutes (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        nome            TEXT    NOT NULL,
        origem          TEXT    NOT NULL,
        destino         TEXT    NOT NULL,
        transporte      TEXT    NOT NULL,
        tempo_estimado  INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableDisplacements (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        route_id          INTEGER NOT NULL,
        data_hora_saida   TEXT    NOT NULL,
        data_hora_chegada TEXT,
        duracao           INTEGER,
        observacao        TEXT,
        FOREIGN KEY (route_id) REFERENCES $tableRoutes (id)
          ON DELETE CASCADE
      )
    ''');
  }

  // ---------------------------------------------------------------------------
  // CRUD – Routes
  // ---------------------------------------------------------------------------

  Future<int> insertRoute(RouteModel route) async {
    final db = await database;
    return db.insert(
      tableRoutes,
      route.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RouteModel>> getAllRoutes() async {
    final db = await database;
    final maps = await db.query(tableRoutes);
    return maps.map(RouteModel.fromMap).toList();
  }

  Future<RouteModel?> getRouteById(int id) async {
    final db = await database;
    final maps = await db.query(
      tableRoutes,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return RouteModel.fromMap(maps.first);
  }

  Future<int> updateRoute(RouteModel route) async {
    final db = await database;
    return db.update(
      tableRoutes,
      route.toMap(),
      where: 'id = ?',
      whereArgs: [route.id],
    );
  }

  Future<int> deleteRoute(int id) async {
    final db = await database;
    return db.delete(
      tableRoutes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------------------------------------------------------------------
  // CRUD – Displacements
  // ---------------------------------------------------------------------------

  Future<int> insertDisplacement(DisplacementModel displacement) async {
    final db = await database;
    return db.insert(
      tableDisplacements,
      displacement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DisplacementModel>> getAllDisplacements() async {
    final db = await database;
    final maps = await db.query(tableDisplacements);
    return maps.map(DisplacementModel.fromMap).toList();
  }

  Future<DisplacementModel?> getDisplacementById(int id) async {
    final db = await database;
    final maps = await db.query(
      tableDisplacements,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return DisplacementModel.fromMap(maps.first);
  }

  Future<List<DisplacementModel>> getDisplacementsByRoute(int routeId) async {
    final db = await database;
    final maps = await db.query(
      tableDisplacements,
      where: 'route_id = ?',
      whereArgs: [routeId],
    );
    return maps.map(DisplacementModel.fromMap).toList();
  }

  Future<int> updateDisplacement(DisplacementModel displacement) async {
    final db = await database;
    return db.update(
      tableDisplacements,
      displacement.toMap(),
      where: 'id = ?',
      whereArgs: [displacement.id],
    );
  }

  Future<int> deleteDisplacement(int id) async {
    final db = await database;
    return db.delete(
      tableDisplacements,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------------------------------------------------------------------
  // History – Displacements filtered by date range
  // ---------------------------------------------------------------------------

  /// Returns all displacements whose [dataHoraSaida] falls within
  /// [startDate] (inclusive, start of day) and [endDate] (inclusive, end of day).
  Future<List<DisplacementModel>> getDisplacementHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await database;
    final start = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    ).toIso8601String();
    // Use the beginning of the next day as an exclusive upper bound so the
    // entire last day is covered regardless of millisecond/microsecond precision.
    final end = DateTime(
      endDate.year,
      endDate.month,
      endDate.day + 1,
    ).toIso8601String();

    final maps = await db.query(
      tableDisplacements,
      where: 'data_hora_saida >= ? AND data_hora_saida < ?',
      whereArgs: [start, end],
      orderBy: 'data_hora_saida ASC',
    );
    return maps.map(DisplacementModel.fromMap).toList();
  }

  // ---------------------------------------------------------------------------
  // Utility
  // ---------------------------------------------------------------------------

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
