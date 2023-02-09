import 'dart:async';

import 'package:chat_gpt/view/chat_massage.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMassage> _massage = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMassage() {
    ChatMassage massages = ChatMassage(text: _controller.text, sender: "user");

    setState(() {
      _massage.insert(0, massages);
    });

    _controller.clear();

    final request = CompleteReq(
        prompt: massages.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder(
          "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",
        )
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);

      ChatMassage botMessage = ChatMassage(
        text: response.choices[0].text,
        sender: "bot",
      );

      setState(() {
        _massage.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextCompose() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) {
              _sendMassage();
            },
            decoration: const InputDecoration.collapsed(
              hintText: "Send a massage",
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            _sendMassage();
          },
          icon: const Icon(Icons.send),
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.teal,
          elevation: 10,
          title: const Center(
            child: Text('Demo'),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                reverse: true,
                padding: Vx.m8,
                itemCount: _massage.length,
                itemBuilder: (context, index) {
                  return _massage[index];
                },
              )),
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: _buildTextCompose(),
              ).p16()
            ],
          ),
        ));
  }
}
