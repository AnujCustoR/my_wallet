import 'package:my_wallet/data/firebase/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_wallet/data/database_manager.dart' as db;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

const _data = "data";

DocumentReference _firestore;

bool _isInit = false;
bool _isDbSetup = false;

FirebaseApp _app;

List<StreamSubscription> subs = [];

Future<void> init(FirebaseApp app, {String homeProfile}) async {
  if (_isInit) return;

  _isInit = true;
  if(_app != null) _app = app;

  if (homeProfile != null && homeProfile.isNotEmpty) await setupDatabase(homeProfile);
}

Future<void> setupDatabase(final String homeKey) async {
  return _lock.synchronized(() async {
    if (_isDbSetup) return;

    _isDbSetup = true;

    _firestore = (await firestore(_app)).collection(_data).document(homeKey);

    DocumentSnapshot snapShot;
    try {
        snapShot = await _firestore.get();
    } catch (e) {
      print("timeout on homekey data");
    }

    if(snapShot == null || snapShot.documentID == null || snapShot.documentID.isEmpty) {
      print("drop all table");
      // drop database
      await db.dropAllTables();
    }

    _firestore.collection(tblAccount).snapshots().listen((f) => f.documentChanges.forEach((change) {
      switch(change.type) {
        case DocumentChangeType.added: _onAccountAdded(change.document); break;
        case DocumentChangeType.modified: _onAccountChanged(change.document); break;
        case DocumentChangeType.removed: _onAccountRemoved(change.document); break;
      }
    }));

    _firestore.collection(tblBudget).snapshots().listen((f) => f.documentChanges.forEach((change) {
      switch(change.type) {
        case DocumentChangeType.added: _onBudgetAdded(change.document); break;
        case DocumentChangeType.modified: _onBudgetChanged(change.document); break;
        case DocumentChangeType.removed: _onBudgetRemoved(change.document); break;
      }
    }));

    _firestore.collection(tblCategory).snapshots().listen((f) => f.documentChanges.forEach((change) {
      switch(change.type) {
        case DocumentChangeType.added: _onCategoryAdded(change.document); break;
        case DocumentChangeType.modified: _onCategoryChanged(change.document); break;
        case DocumentChangeType.removed: _onCategoryRemoved(change.document); break;
      }
    }));

    _firestore.collection(tblTransaction).snapshots().listen((f) => f.documentChanges.forEach((change) {
      switch(change.type) {
        case DocumentChangeType.added: _onTransactionAdded(change.document); break;
        case DocumentChangeType.modified: _onTransactionChanged(change.document); break;
        case DocumentChangeType.removed: _onTransactionRemoved(change.document); break;
      }
    }));

    _firestore.collection(tblUser).snapshots().listen((f) => f.documentChanges.forEach((change) {
      switch(change.type) {
        case DocumentChangeType.added: _onUserAdded(change.document); break;
        case DocumentChangeType.modified: _onUserChanged(change.document); break;
        case DocumentChangeType.removed: _onUserRemoved(change.document); break;
      }
    }));
  });
}

// ####################################################################################################
// private helper
Map<String, dynamic> _AccountToMap(Account acc) {
  return {fldName: acc.name, fldType: acc.type.id, fldBalance: acc.balance, fldCurrency: acc.currency};
}

Account _snapshotToAccount(DocumentSnapshot snapshot) {
  return Account(_toId(snapshot), snapshot.data[fldName], double.parse("${snapshot.data[fldBalance]}"), AccountType.all[snapshot.data[fldType]], snapshot.data[fldCurrency]);
}

Map<String, dynamic> _CategoryToMap(AppCategory cat) {
  return {fldName: cat.name, fldColorHex: cat.colorHex, fldBalance: cat.balance};
}

Map<String, dynamic> _UserToMap(User user, {int color}) {
  return {fldUuid: user.uuid, fldEmail: user.email, fldDisplayName: user.displayName, fldPhotoUrl: user.photoUrl, fldColor: color != null ? color : user.color};
}

Map<String, dynamic> _BudgetToMap(Budget budget) {
  return {fldCategoryId: budget.categoryId, fldAmount: budget.budgetPerMonth, fldStart: budget.budgetStart.millisecondsSinceEpoch, fldEnd: budget.budgetEnd != null ? budget.budgetEnd.millisecondsSinceEpoch : null};
}

Budget _snapshotToBudget(DocumentSnapshot snapshot) {
  return Budget(_toId(snapshot), snapshot.data[fldCategoryId], snapshot.data[fldAmount] * 1.0, DateTime.fromMillisecondsSinceEpoch(snapshot.data[fldStart]), snapshot.data[fldEnd] != null ? DateTime.fromMillisecondsSinceEpoch(snapshot.data[fldEnd]) : null);
}


AppCategory _snapshotToCategory(DocumentSnapshot snapshot) {
  return AppCategory(_toId(snapshot), snapshot.data[fldName], snapshot.data[fldColorHex], double.parse("${snapshot.data[fldBalance]}"));
}

Map<String, dynamic> _TransactionToMap(AppTransaction trans) {
  return {fldDateTime: trans.dateTime.millisecondsSinceEpoch, fldAccountId: trans.accountId, fldCategoryId: trans.categoryId, fldAmount: trans.amount, fldDesc: trans.desc, fldType: trans.type.id, fldUuid: trans.userUid};
}

AppTransaction _snapshotToTransaction(DocumentSnapshot snapshot) {
  return AppTransaction(_toId(snapshot), DateTime.fromMillisecondsSinceEpoch(snapshot.data[fldDateTime]), snapshot.data[fldAccountId], snapshot.data[fldCategoryId], double.parse("${snapshot.data[fldAmount]}"), snapshot.data[fldDesc], TransactionType.all[snapshot.data[fldType]], snapshot.data[fldUuid]);
}

int _toId(DocumentSnapshot snapshot) {
  return int.parse(snapshot.documentID);
}

void _onAccountAdded(DocumentSnapshot document) {
  db.insertAccount(_snapshotToAccount(document)).catchError((e) => _onAccountChanged(document));
}

void _onAccountChanged(DocumentSnapshot document) {
  db.updateAccount(_snapshotToAccount(document));
}

void _onAccountRemoved(DocumentSnapshot document) {
  db.deleteAccount(_toId(document));
}

void _onCategoryAdded(DocumentSnapshot document) {
  db.insertCagetory(_snapshotToCategory(document)).catchError((e) => _onCategoryChanged(document));
}

void _onCategoryChanged(DocumentSnapshot document) {
  db.updateCategory(_snapshotToCategory(document));
}

void _onCategoryRemoved(DocumentSnapshot document) {
  db.deleteCategory(_toId(document));
}

void _onTransactionAdded(DocumentSnapshot document) {
  db.insertTransaction(_snapshotToTransaction(document)).catchError((e) => _onTransactionChanged(document));
}

void _onTransactionChanged(DocumentSnapshot document) {
  db.updateTransaction(_snapshotToTransaction(document));
}

void _onTransactionRemoved(DocumentSnapshot document) {
  db.deleteTransaction(_toId(document));
}

void _onUserAdded(DocumentSnapshot document) {
  db.insertUser(snapshotToUser(document)).catchError((e) => _onUserChanged(document));
}

void _onUserChanged(DocumentSnapshot document) {
  db.updateUser(snapshotToUser(document));
}

void _onUserRemoved(DocumentSnapshot document) {
  db.deleteUser(document.data[fldUuid]);
}

void _onBudgetAdded(DocumentSnapshot document) {
  db.insertBudget(_snapshotToBudget(document)).catchError((e) => _onBudgetChanged(document));
}

void _onBudgetChanged(DocumentSnapshot document) {
  db.updateBudget(_snapshotToBudget(document));
}

void _onBudgetRemoved(DocumentSnapshot document) {
  db.deleteBudget(_toId(document));
}
// ####################################################################################################
// Account
Lock _lock = Lock();

Future<bool> addAccount(Account acc) async {
  return _lock.synchronized(() async {
    _firestore.collection(tblAccount).document("${acc.id}").setData(_AccountToMap(acc));
  return true;
  });
}

Future<bool> updateAccount(Account acc) async {
  return addAccount(acc);
}

Future<bool> deleteAccount(Account acc) async {
  return _lock.synchronized(() async {
    await _firestore.collection(tblAccount).document("${acc.id}").delete();
    return true;
  });
}

// ####################################################################################################
// Transaction
Future<bool> addTransaction(AppTransaction transaction) async {
  return _lock.synchronized(() async {
    _firestore.collection(tblTransaction).document("${transaction.id}").setData(_TransactionToMap(transaction));
    return true;
  });
}

Future<bool> updateTransaction(AppTransaction trans) async {
  return addTransaction(trans);
}

Future<bool> deleteTransaction(AppTransaction trans) async {
  return _lock.synchronized(() async {
    await _firestore.collection(tblTransaction).document("${trans.id}").delete();
    return true;
  });
}

// ####################################################################################################
// Category
Future<bool> addCategory(AppCategory cat) async {
  return _lock.synchronized(() async {
    _firestore.collection(tblCategory).document("${cat.id}").setData(_CategoryToMap(cat));

    return true;
  });
}

Future<bool> updateCategory(AppCategory cat) {
  return addCategory(cat);
}

Future<bool> deleteCategory(AppCategory cat) async {
  return _lock.synchronized(() async {
    await _firestore.collection(tblCategory).document("${cat.id}").delete();

    return true;
  });
}

// ####################################################################################################
// User
Future<bool> addUser(User user, {int color}) async {
  return _lock.synchronized(() async {
    _firestore.collection(tblUser).document(user.uuid).setData(_UserToMap(user, color: color));
    return true;
  });
}

Future<bool> updateUser(User user) {
  return addUser(user);
}

Future<bool> deleteUser(User user) async {
  return _lock.synchronized(() async {
    await _firestore.collection(tblUser).document(user.uuid).delete();
    return true;
  });
}

// ####################################################################################################
// Budget
Future<bool> addBudget(Budget budget) async {
  return _lock.synchronized(() async {
    _firestore.collection(tblBudget).document("${budget.id}").setData(_BudgetToMap(budget));
    return true;
  });
}

Future<bool> updateBudget(Budget budget) {
  return addBudget(budget);
}

Future<bool> deleteBudget(Budget budget) async {
  return _lock.synchronized(() async {
    await _firestore.collection(tblBudget).document("${budget.id}").delete();
    return true;
  });
}


Future<bool> removeRefenrence() async {
  return _lock.synchronized(() async {
    if(subs != null) subs.forEach((f) async => await f.cancel());

    _isDbSetup = false;
  });
}


