// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class ChatDetailsHeader extends StatelessWidget {
//   const ChatDetailsHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 90,
//           padding: EdgeInsets.only(left: 16, top: 22, bottom: 23, right: 12),
//           decoration: BoxDecoration(
//             border: Border(bottom: BorderSide(color: Color(0xFFE8E4DC))),
//           ),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: SvgPicture.asset('assets/images/go_back2.svg'),
//               ),
//               SizedBox(width: 13),
//               Container(
//                 width: 50,
//                 height: 45,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(17),
//                   border: Border.all(color: Color(0xFF888780), width: 0.5),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "JD",
//                     style: TextStyle(
//                       color: Color(0xff5BAB8B),
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "John Doe",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   Text(
//                     "online",
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF5BAB8B),
//                       height: 1.8,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xffF3EDE4),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 width: 50,
//                 height: 50,
//               ),
//               SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "iphone 14 Pro Max",
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       height: 1.8,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 4.0),
//                     child: Text(
//                       "500,000 SYR",
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFF8A8580),
//                         fontFamily: "IBM Plex Sans",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
