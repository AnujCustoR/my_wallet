import 'package:my_wallet/data/database_manager.dart' as db;
import 'package:my_wallet/utils.dart' as Utils;
import 'package:my_wallet/ca/data/ca_repository.dart';
import 'package:my_wallet/ui/transaction/list/data/transaction_list_entity.dart';
import 'package:my_wallet/data/data.dart';

class TransactionListRepository extends CleanArchitectureRepository {
  final _TransactionListDatabaseRepository _dbRepo = _TransactionListDatabaseRepository();

  Future<List<TransactionEntity>> loadDataFor(
      int accountId,
      int categoryId,
      DateTime day
      ) {
    return _dbRepo.loadDataFor(accountId, categoryId, day);
  }
}

class _TransactionListDatabaseRepository {
  Future<List<TransactionEntity>> loadDataFor(
      int accountId,
      int categoryId,
      DateTime day
      ) async {
    List<TransactionEntity> entities = [];

    List<AppTransaction> transactions = [];
    if(accountId != null) {
      transactions = await db.queryTransactionForAccount(accountId);
    }

    if(categoryId != null) {
      transactions = await db.queryTransactionForCategory(categoryId);
    }

    if(day != null) {
      transactions = await db.queryTransactionsBetweenDates(Utils.startOfDay(day), Utils.endOfDay(day));
    }

    if (transactions != null) {
      // update category names to transactions which does not have description
      List<AppTransaction> noDesc = transactions.where((f) => f.desc == null || f.desc.isEmpty).toList();

      if (noDesc != null && noDesc.isNotEmpty) {
        transactions.removeWhere((f) => f.desc == null || f.desc.isEmpty);

        if (categoryId != null) {
          var cat = await db.queryCategory(id: categoryId);

          noDesc.forEach((f) =>
              transactions.add(AppTransaction(
                  f.id,
                  f.dateTime,
                  f.accountId,
                  f.categoryId,
                  f.amount,
                  cat[0].name,
                  f.type,
                  f.userUid)));
        } else {
          for (int i = 0; i < noDesc.length; i++) {
            var cat = await db.queryCategory(id: noDesc[i].categoryId);

            transactions.add(AppTransaction(
                noDesc[i].id,
                noDesc[i].dateTime,
                noDesc[i].accountId,
                noDesc[i].categoryId,
                noDesc[i].amount,
                cat[0].name,
                noDesc[i].type,
                noDesc[i].userUid));
          }
        }
      }

      // sort transactions by date
      transactions.sort((a, b) => a.dateTime.millisecondsSinceEpoch - b.dateTime.millisecondsSinceEpoch);

      // get user initial
      for(AppTransaction trans in transactions) {
        if(trans.userUid == null || trans.userUid.isEmpty) continue;

        List<User> users = await db.queryUserWithUuid(trans.userUid);

        if(users != null && users.isNotEmpty) {
          print("users ${users.length}");
          User user = users[0];
          var splits = user.displayName.split(" ");
          var initial = splits.map((f) => f.substring(0, 1).toUpperCase()).join();
          initial = initial.substring(0, initial.length < 2 ? initial.length : 2);

          print("user ${user.email} has color ${user.color}");
          entities.add(TransactionEntity(trans.id, initial, trans.desc, trans.amount, trans.dateTime, user.color));
        }
      }
    }

    return entities;
  }
}
