import 'package:flutter/material.dart';

import '../../shared/shared.dart';
import '../../../core/core.dart';
import 'custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    @required Widget child,
    Color textColor = Colors.black87,
    Color color = buttonColor,
    ViewState viewState = ViewState.Idle,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: child,
          height: 44.0,
          color: color ?? buttonColor,
          textColor: textColor ?? Colors.black87,
          borderRadius: 8,
          loading: viewState == ViewState.Busy,
          onPressed: onPressed,
        );
}
