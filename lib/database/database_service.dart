import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  return openDatabase(join(path, 'pdf_files.db'),
      onCreate: (database, version) async {
    await database.execute(
        '''CREATE TABLE IF NOT EXISTS pdfs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, path TEXT NOT NULL, timestamp INTEGER NOT NULL)''');
  }, version: 1);
}

Future<void> insertPDF(String name, String path) async {
  final db = await initializeDB();
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  await db.insert(
    'pdfs',
    {'name': name, 'path': path, 'timestamp': timestamp},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deletePDF(int id) async {
  final db = await initializeDB();
  await db.delete(
    'pdfs',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<List<Map<String, dynamic>>> retrievePDFs() async {
  final db = await initializeDB();
  return db.query(
    'pdfs',
    orderBy: 'timestamp DESC',
  );
}
