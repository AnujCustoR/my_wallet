import 'package:my_wallet/ca/presentation/view/ca_state.dart';
import 'package:my_wallet/ui/user/register/presentation/presenter/register_presenter.dart';
import 'package:my_wallet/ui/user/register/presentation/view/register_data_view.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends CleanArchitectureView<Register, RegisterPresenter> implements RegisterDataView {
  _RegisterState() : super(RegisterPresenter());

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _displayNameController = TextEditingController();

  final GlobalKey<RoundedButtonState> _registerKey = GlobalKey();

  bool _obscureText = true;

  @override
  void init() {
    presenter.dataView = this;
  }

  @override
  Widget build(BuildContext context) {
    return PlainScaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.all(20.0),
                icon: Icon(Icons.arrow_back,
                color: AppTheme.blueGrey),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.display1.apply(color: AppTheme.black),
                ),
              ),
            ),
//            Align(
//                alignment: Alignment.center,
//                child: Padding(
//                  padding: EdgeInsets.only(top: 00.0, bottom: 10.0),
//                  child: Text(
//                    "Signup with Social Network or Email",
//                    style: Theme.of(context).textTheme.title.apply(color: AppTheme.blueGrey),
//                  ),
//                )
//            ),
//            Padding(
//              padding: EdgeInsets.only(left: 20.0, right: 20.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                mainAxisSize: MainAxisSize.max,
//                children: <Widget>[
//                  Expanded(
//                    child: RoundedButton(
//                      onPressed: _onFacebookButtonPressed,
//                      padding: EdgeInsets.all(10.0),
//                      child: Icon(
//                        MyFlutterApp.facebook_rect,
//                        color: AppTheme.white,
//                      ),
//                      radius: 5.0,
//                      color: AppTheme.facebookColor,
//                    ),
//                  ),
//                  Expanded(
//                    child: RoundedButton(
//                      onPressed: _onGoogleButtonPressed,
//                      padding: EdgeInsets.all(10.0),
//                      child: Icon(
//                        MyFlutterApp.googleplus_rect,
//                        color: AppTheme.white,
//                      ),
//                      radius: 5.0,
//                      color: AppTheme.googleColor,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: Container(
//                      height: 1.0,
//                      color: AppTheme.blueGrey,
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(5.0),
//                    child: Text(
//                      "OR",
//                      style: Theme.of(context).textTheme.title.apply(color: AppTheme.blueGrey),
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(
//                      height: 1.0,
//                      color: AppTheme.blueGrey,
//                    ),
//                  )
//                ],
//              ),
//            ),
            Container(
              height: 0.5,
              color: AppTheme.blueGrey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Text(
                "NAME",
                style: Theme.of(context).textTheme.title.apply(color: AppTheme.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: TextField(
                controller: _displayNameController,
                decoration: InputDecoration(hintText: "Sample Name", hintStyle: Theme.of(context).textTheme.title.apply(color: AppTheme.blueGrey)),
                style: Theme.of(context).textTheme.title.apply(color: AppTheme.black),
              ),
            ),
            Container(
              height: 0.5,
              color: AppTheme.blueGrey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Text(
                "EMAIL ADDRESS",
                style: Theme.of(context).textTheme.title.apply(color: AppTheme.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "SampleEmail@domain.com", hintStyle: Theme.of(context).textTheme.title.apply(color: AppTheme.blueGrey)),
                style: Theme.of(context).textTheme.title.apply(color: AppTheme.black),
              ),
            ),
            Container(
              height: 0.5,
              color: AppTheme.blueGrey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Text(
                "PASSWORD",
                style: Theme.of(context).textTheme.title.apply(color: AppTheme.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: "samplepassword",
                    hintStyle: Theme.of(context).textTheme.title.apply(color: AppTheme.blueGrey),
                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye, color: _obscureText ? AppTheme.blueGrey : AppTheme.blueGrey.withOpacity(0.4),), onPressed: () => setState(() => _obscureText = !_obscureText))
                ),
                obscureText: _obscureText,
                style: Theme.of(context).textTheme.title.apply(color: AppTheme.black),
              ),
            ),
            Container(
              height: 0.5,
              color: AppTheme.blueGrey,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RoundedButton(
                      key: _registerKey,
                      onPressed: _registerEmail,
                      child: Text("Register", style: TextStyle(color: AppTheme.white),),
                      color: AppTheme.blue,
                    ),
//                      child: FlatButton(
//                        padding: EdgeInsets.all(15.0),
//                        onPressed: _registerEmail,
//                        child: Text("Register"),
//                        color: AppTheme.darkBlue,))
                  )
                ],
              ),
            )
          ],
        ),
      ],
    ));
  }

//  void _onFacebookButtonPressed() {
//    debugPrint("Facebook");
//  }
//
//  void _onGoogleButtonPressed() {
//    debugPrint("Google");
//  }

  void _registerEmail() {
    _registerKey.currentState.process();
    presenter.registerEmail(_displayNameController.text, _emailController.text, _passwordController.text);
  }

  @override
  void onRegisterSuccess(bool result) {
    _registerKey.currentState.stop();
    Navigator.pop(context);
    Navigator.of(context).pushReplacementNamed(routes.ValidationProcessing);
  }

  @override
  void onRegisterFailed(Exception e) {
    _registerKey.currentState.stop();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Registration failed"),
      content: Text("Registration failed with error ${e.toString()}"),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Try Again"),
        )
      ],
    ));
  }
}
