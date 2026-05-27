import 'package:dealura/core/utls/app_router.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.router.push('/chat_details');
      },
      child: Container(
        height: 90,
        padding: EdgeInsets.only(left: 16, top: 22, bottom: 23, right: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE8E4DC))),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: Color(0xFF888780), width: 0.5),
              ),
              child: Center(
                child: Text(
                  "JD",
                  style: TextStyle(
                    color: Color(0xff5BAB8B),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Hey, how are you?",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8580),
                    height: 1.8,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "2:30 PM",
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A8580)),
                ),
                SizedBox(height: 4),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFF5BAB8B),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
