import 'package:flutter/material.dart';
import 'package:my_wallet/ui/transaction/list/presentation/presenter/transaction_list_presenter.dart';
import 'package:my_wallet/database/data.dart';
import 'package:my_wallet/my_wallet_view.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/app_theme.dart' as theme;
import 'package:my_wallet/ca/presentation/view/ca_state.dart';
import 'package:my_wallet/ui/transaction/list/presentation/view/transaction_list_data_view.dart';

class TransactionList extends StatefulWidget {
  final String title;
  final int accountId;
  final int categoryId;
  final DateTime day;

  TransactionList(this.title, {this.accountId, this.categoryId, this.day}) : super();

  @override
  State<StatefulWidget> createState() {
    return _TransactionListState();
  }
}

class _TransactionListState extends CleanArchitectureView<TransactionList, TransactionListPresenter> implements TransactionListDataView {
  _TransactionListState() : super(TransactionListPresenter());

  List<AppTransaction> entities = [];

  NumberFormat nf = NumberFormat("#,##0.00");
  DateFormat df = DateFormat("dd MMM, yyyy");

  @override
  void init() {
    presenter.dataView = this;
  }

  @override
  void initState() {
    super.initState();

    presenter.loadDataFor(widget.accountId, widget.categoryId, widget.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWalletAppBar(
        title: widget.title,
      ),
      body: ListView.builder(
          itemCount: entities.length,
          itemBuilder: (context, index) => Container(
            child: ListTile(
              title: Text(entities[index].desc, style: Theme.of(context).textTheme.body2.apply(color: theme.darkBlue),),
              subtitle: Text(df.format(entities[index].dateTime)),
              trailing: Text("\$${nf.format(entities[index].amount)}", style: Theme.of(context).textTheme.title.apply(color: theme.darkBlue),),
            ),
            color: index % 2 == 0 ? Colors.white : Colors.grey.withOpacity(0.2),
          )
      ),
    );
  }

  @override
  void onTransactionListLoaded(List<AppTransaction> value) {
    setState(() {
      this.entities = value;
    });
  }
}
