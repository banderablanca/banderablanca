import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../shared/shared.dart';
import 'custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key? key,
    required Widget child,
    Color textColor = Colors.black87,
    Color color = buttonColor,
    ViewState viewState = ViewState.Idle,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          icon: Icon(Icons.radio_button_on),
          child: child,
          height: 44.0,
          color: color,
          textColor: textColor,
          borderRadius: 8,
          loading: viewState == ViewState.Busy,
          onPressed: onPressed,
        );
}
