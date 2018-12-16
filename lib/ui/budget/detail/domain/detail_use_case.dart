import 'package:my_wallet/ca/domain/ca_use_case.dart';

import 'package:my_wallet/ui/budget/detail/data/detail_repository.dart';

class BudgetDetailUseCase extends CleanArchitectureUseCase<BudgetDetailRepository> {
  BudgetDetailUseCase() : super(BudgetDetailRepository());

  void loadCategoryList(onNext<List<AppCategory>> next) {
    repo.loadCategoryList().then((value) => next(value));
  }

  void saveBudget(
      AppCategory _cat,
      double _amount,
      DateTime startMonth,
      DateTime endMonth,
      onNext<bool> next,
      onError error
      ) async {
    int id = await repo.generateBudgetId();
    Budget budget = Budget(id, _cat.id, _amount, startMonth, endMonth);
    repo.saveBudget(budget).then((value) => next(value)).catchError(error);
  }
}