import 'package:my_wallet/database/database_manager.dart' as db;
import 'package:my_wallet/database/data.dart';

class CategoryListRepository {
  final _CategoryListDatabaseRepository _dbRepo = _CategoryListDatabaseRepository();

  Future<List<AppCategory>> loadCategories() {
    return _dbRepo.loadCategories();
  }
}

class _CategoryListDatabaseRepository {
  Future<List<AppCategory>> loadCategories() async {
      return await db.queryCategory();
  }
}