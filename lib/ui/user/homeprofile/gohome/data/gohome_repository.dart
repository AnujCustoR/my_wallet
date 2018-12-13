import 'package:my_wallet/ca/data/ca_repository.dart';

import 'package:my_wallet/data/firebase_manager.dart' as fm;
import 'package:my_wallet/shared_pref/shared_preference.dart';

class GoHomeRepository extends CleanArchitectureRepository {
  Future<void> updateHomeReference(String homeKey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString(prefHomeProfile, homeKey);
  }

  Future<void> switchReference() async {
    return fm.setupDatabase();
  }
}