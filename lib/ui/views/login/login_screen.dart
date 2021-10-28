import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../core/core.dart';
import '../../../core/models/models.dart';
import '../../../ui/shared/helpers.dart';
import '../../../ui/shared/keys.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  void _handleSubmitted(context) {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      Provider.of<UserModel>(context, listen: false).signInWithEmailAndPassword(
          AuthFormData(email: email, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            constraints: BoxConstraints(maxWidth: 375),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Hero(
                  tag: AppKeys.logo,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bienvenido",
                    style: theme.textTheme.headline5!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "signInToContinue",
                    style: theme.textTheme.subtitle1!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _formSignIn(),
                SizedBox(
                  height: 24,
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "¿Aún no tienes cuenta?",
                      style: theme.textTheme.subtitle1,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.RegisterScreen);
                      },
                      child: Text(
                        "signUp",
                        style: theme.textTheme.subtitle1!.copyWith(
                            color: theme.accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSignIn() {
    final UserModel userModel = context.read<UserModel>();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
              enableInteractiveSelection:
                  defaultTargetPlatform != TargetPlatform.iOS,
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "enterYourEmail",
                labelText: "email",
              ),
              // validator: (value) => validateEmail(context, value),
              onSaved: (String? value) {
                email = value ?? '';
              }),
          SizedBox(
            height: 16,
          ),
          TextFormField(
              enableInteractiveSelection:
                  defaultTargetPlatform != TargetPlatform.iOS,
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "enterYourPassword",
                labelText: "password",
              ),
              validator: (value) => validatePassword(context, value ?? ''),
              onSaved: (String? value) {
                password = value ?? '';
              }),
          _buildErrorMessage(context),
          SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RoutePaths.ForgotPassword);
              },
              child: Text(
                "forgotYourPassword",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            width: double.infinity,
            child: FormSubmitButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "signIn".toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () => _handleSubmitted(context),
              viewState: userModel.state,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(context) {
    final UserModel model = context.read<UserModel>();
    if (model.errorMessage.isEmpty) return Container();
    return Padding(
      padding: EdgeInsets.all(24),
      child: Container(
        child: Text(model.errorMessage,
            style: TextStyle(
              color: Colors.red,
            )),
      ),
    );
  }
}
