import 'package:my_wallet/ca/domain/ca_use_case.dart';

import 'package:my_wallet/ui/user/homeprofile/main/data/homeprofile_repository.dart';

class HomeProfileUseCase extends CleanArchitectureUseCase<HomeProfileRepository> {
  HomeProfileUseCase() : super(HomeProfileRepository());

  void findUserHome(onNext<HomeEntity> next) async {
    User user = await repo.getCurrentUser();

    HomeEntity entity = await repo.searchUserHome(user);

    next(entity);
  }
}