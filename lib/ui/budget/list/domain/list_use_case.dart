import 'package:my_wallet/ca/domain/ca_use_case.dart';

import 'package:my_wallet/ui/budget/list/data/list_repository.dart';

class ListBudgetsUseCase extends CleanArchitectureUseCase<ListBudgetsRepository> {
  ListBudgetsUseCase() : super(ListBudgetsRepository());

  void loadThisMonthBudgetList(DateTime month, onNext<List<BudgetEntity>> next) async{
    var list = await repo.loadThisMonthBudgetList(month);

    print("list in usecase ${list.length}");
    next(list);
  }
}