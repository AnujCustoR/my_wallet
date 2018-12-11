import 'package:my_wallet/data/data.dart';

import 'package:my_wallet/ui/category/list/presentation/presenter/list_category_presenter.dart';

import 'package:my_wallet/ui/transaction/list/presentation/view/transaction_list_view.dart';
import 'package:my_wallet/ca/presentation/view/ca_state.dart';
import 'package:my_wallet/ui/category/list/presentation/view/list_category_data_view.dart';

class CategoryList extends StatefulWidget {
  final String _title;
  final bool returnValue;

  CategoryList(this._title, {this.returnValue = false});

  @override
  State<StatefulWidget> createState() {
    return _CategoryListState();
  }
}

class _CategoryListState extends CleanArchitectureView<CategoryList, ListCategoryPresenter> implements CategoryListDataView {
  _CategoryListState() : super(ListCategoryPresenter());

  List<AppCategory> _categories = [];

  var isEditMode = false;

  @override
  void init() {
    presenter.dataView = this;
  }

  @override
  void initState() {
    super.initState();

    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: MyWalletAppBar(
        title: widget._title,
        actions: <Widget>[
          FlatButton(
            child: Text(isEditMode ? "Done" : "Edit"),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (_, index) => Card(
                  color: Colors.white.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0), side: BorderSide(width: 1.0, color: Colors.white)),
                  child: ListTile(
                    title: Text(
                      _categories[index].name,
                      style: TextStyle(color: AppTheme.darkBlue),
                    ),
                    onTap: () => widget.returnValue
                        ? Navigator.pop(context, _categories[index])
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TransactionList(
                                      _categories[index].name,
                                      categoryId: _categories[index].id,
                                    ))),
                  ),
                )),
      ),
      floatingActionButton: isEditMode
          ? RoundedButton(
              onPressed: () => Navigator.pushNamed(context, routes.CreateCategory).then((value) {
                    if (value != null) _loadCategories();
                  }),
              child: Text(
                ("Create Category"),
              ),
              color: AppTheme.pinkAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _loadCategories() {
    presenter.loadCategories();
  }

  void onCategoriesLoaded(List<AppCategory> value) {
    if (value != null)
      setState(() {
        _categories = value;
      });
  }

  int stageCrossAxisCellCount(String name) {
    if (name.length > 12)
      return 3;
    else if (name.length > 7)
      return 2;
    else
      return 1;
  }

  int stageMainAxisCellCount(String name) {
    return 1;
  }
}
