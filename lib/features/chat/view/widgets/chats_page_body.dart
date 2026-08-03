// import 'package:dealura/features/chat/view/widgets/chat_tile.dart';
// import 'package:flutter/material.dart';

// class ChatsPageBody extends StatelessWidget {
//   const ChatsPageBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 86, bottom: 67, left: 16),
//             child: Text(
//               "Messages",
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: "DM Serif Display",
//               ),
//             ),
//           ),

//           ChatTile(),
//           ChatTile(),
//           ChatTile(),
//           ChatTile(),
//         ],
//       ),
//     );
//   }
// }



// import 'package:dealura/core/utls/chat_client.dart';
// import 'package:dealura/features/chat/view/pages/chat_details_page.dart';
// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class ChatsPageBody extends StatelessWidget {
//   const ChatsPageBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamChat(
//       client: streamClient,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Messages"),
//         ),
//         body: StreamChannelListView(
//           onChannelTap: (channel) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ChatDetailsPage(channel: channel),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }