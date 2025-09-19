import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});