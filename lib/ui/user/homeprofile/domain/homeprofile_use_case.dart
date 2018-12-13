import 'package:my_wallet/ca/domain/ca_use_case.dart';

import 'package:my_wallet/ui/user/homeprofile/data/homeprofile_repository.dart';

class HomeProfileUseCase extends CleanArchitectureUseCase<HomeProfileRepository> {
  HomeProfileUseCase() : super(HomeProfileRepository());

  void createHomeProfile(String name, onNext<bool> next, onError err) async {
    try {
      // get user to be key of the host of new home
      User host = await repo.getCurrentUser();

      // create this data reference on Firebase database
      String homeKey = await repo.createHome(host, name);

      if(homeKey == null) throw HomeProfileException("Failed to create this new home");

      // save this key to shared preference
      await repo.saveKey(homeKey);

      next(true);
    } catch (e) {
      err(e);
    }
  }
}