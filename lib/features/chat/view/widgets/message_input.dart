import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(fontSize: 15, color: Color(0xff757575)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF888780), width: 0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF888780), width: 0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF888780), width: 0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF888780), width: 0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Color(0xff65B091),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(child: SvgPicture.asset('assets/images/send.svg')),
          ),
        ],
      ),
    );
  }
}
