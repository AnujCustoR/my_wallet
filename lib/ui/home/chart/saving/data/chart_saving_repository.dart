import 'package:my_wallet/ui/home/chart/saving/data/chart_saving_entity.dart';
import 'package:my_wallet/database/database_manager.dart' as _db;
import 'package:my_wallet/database/data.dart';
import 'package:my_wallet/utils.dart' as Utils;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_wallet/shared_pref/shared_preference.dart';

class SavingChartRepository {
  Future<SavingEntity> loadSaving() async {
    DateFormat df = DateFormat("dd MMM");

    var start = Utils.firstMomentOfMonth(DateTime.now());
    var today = DateTime.now();


    var incomeThisMonth = await _db.sumAllTransactionBetweenDateByType(start, today, TransactionType.Income);
    var expenseThisMonth = await _db.sumAllTransactionBetweenDateByType(start, today, TransactionType.Expenses);

    var monthlySaving = incomeThisMonth - expenseThisMonth;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var targetSaving = sharedPreferences.get(keyTargetSaving) ?? 0.0;

    return SavingEntity(monthlySaving, targetSaving > 0 ? monthlySaving/targetSaving : 1.0);
  }
}