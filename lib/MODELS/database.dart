import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JournalData {
  int id;
  String symbol;
  String date;
  String setup;
  String entryLevel;
  String lotSize;
  String stoploss;
  String takeProfit;
  File ?images;
  String open;
  String hitby;
  String notes;

  JournalData({
    required this.id,
    required this.symbol,
    required this.date,
    required this.setup,
    required this.entryLevel,
    required this.lotSize,
    required this.stoploss,
    required this.takeProfit,
    required this.images,
    required this.open,
     required this.hitby,
    required this.notes
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'symbol': symbol,
      'date': date,
      'setup': setup,
      'entryLevel': entryLevel,
      'lotSize': lotSize,
      'stoploss': stoploss,
      'takeProfit': takeProfit,
      'images':images,
      'open':open,
      'hitby':hitby,
      'notes':notes
    };
  }
  factory JournalData.fromMap(Map<String, dynamic> map) {
    return JournalData(
      id: map['id'],
      symbol: map['symbol'],
      date: map['date'],
      setup: map['setup'],
      entryLevel: map['entryLevel'],
      lotSize: map['lotSize'],
      stoploss: map['stoploss'],
      takeProfit: map['takeProfit'],
      images: map['images'],
      open: map['open'],
      hitby: map["hitby"],
      notes: map["notes"]

    );
  }
// Implement fromMap function if you want to retrieve data from the database.
}
class DatabaseHelper {
  static Database ?_database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'journal_database.db'),
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE JournalData(id INTEGER PRIMARY KEY, symbol TEXT, date TEXT, setup TEXT, entryLevel TEXT, lotSize TEXT, stoploss TEXT, takeProfit TEXT,images TEXT,open TEXT,hitby TEXT,notes TEXT)",
        );
        await db.execute(
          "CREATE TABLE account(id INTEGER PRIMARY KEY, account_name TEXT, balance REAL,date TEXT)",
        );
        await db.execute(
          "CREATE TABLE accountHistory(amount REAL, name TEXT,date TEXT,total REAL)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertJournalData(JournalData journalData) async {
    final Database db = await database;
    await db.insert(
      'JournalData',
      journalData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<JournalData>> getJournalData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('JournalData');

    return List.generate(maps.length, (i) {
      return JournalData.fromMap(maps[i]);
    });
  }
  Future<void> updateJournalData(JournalData journalData) async {
    final db = await database;

    await db.update(
      'JournalData',
      journalData.toMap(),
      where: 'id = ?',
      whereArgs: [journalData.id],
    );
  }

  Future<void> deleteJournalData(int id) async {
    final db = await database;

    await db.delete(
      'JournalData',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> insertAccountData(AccountData accountData) async {
    final Database db = await database;
    await db.insert(
      'account',
      accountData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAccounthistory(AccountHistory accountData) async {
    final Database db = await database;
    await db.insert(
      'accountHistory',
      accountData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<AccountHistory>> getAccountHistoryData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('accountHistory');

    return List.generate(maps.length, (i) {
      return AccountHistory.fromMap(maps[i]);
    });
  }
  Future<List<AccountData>> getAccountData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('account');

    return List.generate(maps.length, (i) {
      return AccountData.fromMap(maps[i]);
    });
  }

  Future<void> updateAccountData(AccountData accountData) async {
    final db = await database;

    await db.update(
      'account',
      accountData.toMap(),
      where: 'id = ?',
      whereArgs: [accountData.id],
    );
  }

  Future<void> deleteAccountData(int id) async {
    final db = await database;

    await db.delete(
      'account',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// Implement other database operations as needed.
}

class AccountHistory{
 // final int id;
  final double amount;
  final String name;
  final String date;
  final double total;

  AccountHistory({ required this.amount, required this.name,required this.date,required this.total});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'name': name,
      'date':date,
      'total':total
    };
  }

  factory AccountHistory.fromMap(Map<String, dynamic> map) {
    return AccountHistory(
        amount: map['amount'],
        name: map['name'],
        date:map['date'],
        total: map['total']
    );
  }
}




class AccountData {
  final int id;
  final String currency;
  final double balance;
  final String date;

  AccountData({required this.id, required this.currency, required this.balance,required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_name': currency,
      'balance': balance,
      'date':date
    };
  }

  factory AccountData.fromMap(Map<String, dynamic> map) {
    return AccountData(
      id: map['id'],
      currency: map['account_name'],
      balance: map['balance'],
        date:map['date']
    );
  }
}
