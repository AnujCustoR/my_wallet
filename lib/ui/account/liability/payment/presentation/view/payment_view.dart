import 'package:my_wallet/ca/presentation/view/ca_state.dart';

import 'package:my_wallet/ui/account/liability/payment/presentation/view/payment_data_view.dart';
import 'package:my_wallet/ui/account/liability/payment/presentation/presenter/payment_presenter.dart';

import 'package:my_wallet/data/data_observer.dart' as observer;
import 'package:intl/intl.dart';

class PayLiability extends StatefulWidget {
  final int _id;
  final String _name;

  PayLiability(this._id, this._name);

  @override
  State<StatefulWidget> createState() {
    return _PayLiabilityState();
  }
}

class _PayLiabilityState extends CleanArchitectureView<PayLiability, PayLiabilityPresenter> implements PayLiabilityDataView, observer.DatabaseObservable {
  _PayLiabilityState() : super(PayLiabilityPresenter());

  final _nf = NumberFormat("\$#,###.##");
  final _dateFormat = DateFormat("dd MMM, yyyy");
  final _timeFormat = DateFormat("HH:mm");

  final GlobalKey<NumberInputPadState> _numPadKey = GlobalKey();

  String _name;
  Account _account;
  List<Account> _accounts;
  AppCategory _category;
  List<AppCategory> _categories;
  double _amount = 0.0;
  DateTime _date = DateTime.now();

  @override
  void init() {
    presenter.dataView = this;
  }

  @override
  void onDatabaseUpdate(String table) {
    if(table == observer.tableAccount) _loadAccounts();
    if(table == observer.tableCategory) _loadCategories();
  }

  @override
  void initState() {
    super.initState();

    _name = widget._name;

    _loadAccounts();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: MyWalletAppBar(
        title: "Pay money",
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
              onPressed: _savePayment
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: AppTheme.white,
              child: FittedBox(
                child: Column(
                  children: <Widget>[
                    ConversationRow("Pay to", _name,),
                    ConversationRow(
                      "From ", _account == null ? "Select Account" : _account.name,
                      dataColor: AppTheme.darkBlue,
                    onPressed: _showAccountListSelection,),
                    ConversationRow(
                      "in",
                        _category == null ? "Select category" : _category.name,
                      dataColor: _category == null ? AppTheme.pinkAccent : Color(AppTheme.hexToInt(_category.colorHex)),
                      onPressed: _showCategoryListSelection,
                    ),
                    ConversationRow("Amount", _nf.format(_amount)),
                    Row(
                      children: <Widget>[
                        ConversationRow("on", _dateFormat.format(_date)),
                        ConversationRow("at", _timeFormat.format(_date))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            child: NumberInputPad(_numPadKey, _onNumberInput, null, null, showNumPad: true,),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }

  void _onNumberInput(double amount) {
    setState(() => _amount = amount);
  }

  void _showAccountListSelection() {
    showModalBottomSheet(context: context, builder: (context) =>
        BottomViewContent(_accounts, (f) => Align(
          child: InkWell(
            child: Padding(padding: EdgeInsets.all(10.0),
                child: Text(f.name, style: Theme.of(context).textTheme.title.apply(color: AppTheme.brightPink), overflow: TextOverflow.ellipsis, maxLines: 1,)
            ),
            onTap: () {
              setState(() => _account = f);

              Navigator.pop(context);
            },
          ),
        ))
    );
  }

  void _showCategoryListSelection() {
    showModalBottomSheet(context: context, builder: (context) =>
        BottomViewContent(_categories, (f) => Align(
          child: InkWell(
            child: Padding(padding: EdgeInsets.all(10.0),
                child: Text(f.name, style: Theme.of(context).textTheme.title.apply(color: AppTheme.brightPink), overflow: TextOverflow.ellipsis, maxLines: 1,)
            ),
            onTap: () {
              setState(() => _category = f);

              Navigator.pop(context);
            },
          ),
        ))
    );
  }

  void _savePayment() {
    presenter.savePayment(
      widget._id,
      _account,
      _category,
      _amount,
      _date
    );
  }

  @override
  void _loadAccounts() {
    presenter.loadAccounts(widget._id);
  }

  @override
  void _loadCategories() {
    presenter.loadCategories();
  }

  @override
  void onAccountListLoaded(List<Account> accounts) {
    setState(() => _accounts = accounts);
  }

  @override
  void onAccountLoadFailed(Exception e) {

  }

  @override
  void onCategoryLoaded(List<AppCategory> categories) {
    setState(() => _categories = categories);
  }

  @override
  void onCategoryLoadFailed(Exception e) {

  }

  @override
  void onSaveSuccess(bool result) {
    Navigator.pop(context);
  }

  @override
  void onSaveFailed(Exception e) {

  }
}