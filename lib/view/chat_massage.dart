import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMassage extends StatelessWidget {
  const ChatMassage({
    super.key,
    required this.text,
    required this.sender,
  });

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender)
            .text
            .subtitle1(context)
            .make()
            .box
            .color(
              sender == "user" ? Vx.red200 : Vx.green200,
            )
            .p16
            .rounded
            .makeCentered(),
        Expanded(
          child: text.trim().text.bodyText1(context).make().px8(),
        ),
      ],
    ).py8();
  }
}
