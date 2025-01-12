
import 'package:flutter/material.dart';

//stackable widget that is intended to be stack on top of UI widgets to create a custom splash and execute a function
class InkWellButton extends StatelessWidget {
  final VoidCallback onTap;
  final double splashRadius;
  final double buttonHeight;

  const InkWellButton({
    Key? key,
    required this.onTap,
    this.splashRadius = 44,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: buttonHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Theme.of(context).primaryColorDark.withValues(alpha: 0.1),
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }
}