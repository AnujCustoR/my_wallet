import 'package:flutter/material.dart';
import 'package:my_wallet/widget/my_wallet_app_bar.dart';
import 'package:my_wallet/database/data.dart';
import 'package:my_wallet/app_theme.dart' as theme;
import 'package:my_wallet/ca/presentation/view/ca_state.dart';

import 'package:my_wallet/ui/account/create/presentation/presenter/create_account_presenter.dart';
import 'package:my_wallet/ui/account/create/presentation/view/create_account_dataview.dart';

import 'package:my_wallet/widget/conversation_row.dart';
import 'package:my_wallet/widget/number_input_pad.dart';
import 'package:intl/intl.dart';

import 'package:my_wallet/widget/bottom_sheet_list.dart';

class CreateAccount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateAccountState();
  }
}

class _CreateAccountState extends CleanArchitectureView<CreateAccount, CreateAccountPresenter> implements CreateAccountDataView {
  _CreateAccountState() : super(CreateAccountPresenter());

  final _nf = NumberFormat("\$#,##0.00");

  AccountType _type = AccountType.paymentAccount;
  String _name = "";
  double _amount = 0;

  bool showNumberInputPad = false;

  init() {
    presenter.dataView = this;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWalletAppBar(
        title: "Create Account",
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
            onPressed: _saveAccount,
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ConversationRow(
                    "Create new",
                    _type.name,
                    theme.darkBlue,
                    onPressed: _showAccountTypeSelection),
                ConversationRow(
                    "with name",
                    _name == null || _name.isEmpty ? "Enter a name" : _name,
                    theme.darkBlue,
                    onPressed: _showAccountNameDialog,),
                ConversationRow(
                  "and intial amount",
                  _nf.format(_amount),
                  theme.brightPink,
                style: Theme.of(context).textTheme.display2,),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NumberInputPad(_onNumberInput, () {}, null, null),
          )
        ],
      )
    );
  }

  void _showAccountTypeSelection() {
    showModalBottomSheet(context: context, builder: (context) =>
        BottomViewContent(AccountType.all, (f) =>
            Align(
              child: InkWell(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(f.name, style: Theme.of(context).textTheme.title.apply(color: theme.darkBlue))
                ),
                onTap: () {
                  setState(() => _type = f);

                  Navigator.pop(context);
                },
              ),
              alignment: Alignment.center,
            )
        )
    );
  }

  void _showAccountNameDialog() {
    TextEditingController _nameTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Enter your account name", style: Theme.of(context).textTheme.title.apply(color: Colors.white),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: TextField(
            controller: _nameTextController,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.tealAccent)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.tealAccent)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: theme.tealAccent))
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.white.withOpacity(0.5)),),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Choose this name"),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _name = _nameTextController.text;
                  });
                },
            )
          ],
        )
    );
  }

  void _onNumberInput(String number, String decimal) {
    setState(() => _amount = double.parse("${number == null || number.isEmpty ? "0" : number}.${decimal == null || decimal.isEmpty ? "0" : decimal}"));
  }

  void _saveAccount() {
    presenter.saveAccount(_type, _name, _amount);
  }

  void onAccountSaved(bool result) {
    if(result) Navigator.pop(context, result);
  }

  void onError(Exception e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(e.toString()),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ));  }
}