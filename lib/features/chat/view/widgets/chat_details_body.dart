import 'package:dealura/features/chat/view/widgets/chat_bubble.dart';
import 'package:dealura/features/chat/view/widgets/chat_details_header.dart';
import 'package:dealura/features/chat/view/widgets/message_input.dart';
import 'package:flutter/material.dart';

class ChatDetailsBody extends StatelessWidget {
  const ChatDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatDetailsHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Container(
                  width: double.infinity,
                  height: 490,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ChatBubble();
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 30),
                    itemCount: 20,
                  ),
                ),
              ),
              MessageInput(),
            ],
          ),
        ),
      ),
    );
  }
}
