// import 'package:belaaraby/tutoCtr.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
//
//
// class Tuto extends StatefulWidget {
//   @override
//   _TutoState createState() => _TutoState();
// }
//
// class _TutoState extends State<Tuto> {
//
//   final TutoController ttr = Get.find<TutoController>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//             // key: keyButton1,
//             icon: Icon(Icons.add),
//             onPressed: () {},
//           ),
//           PopupMenuButton(
//             key: ttr.keyButton1,
//             icon: Icon(Icons.view_list, color: Colors.white),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 child: Text("Is this"),
//               ),
//               PopupMenuItem(
//                 child: Text("What"),
//               ),
//               PopupMenuItem(
//                 child: Text("You Want?"),
//               ),
//             ],
//           )
//         ],
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Stack(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(top: 100.0),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//                   key: ttr.keyButton,
//                   color: Colors.blue,
//                   height: 100,
//                   width: MediaQuery.of(context).size.width - 50,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: ElevatedButton(
//                       child: Icon(Icons.remove_red_eye),
//                       onPressed: () {
//                         ttr.showHomeTuto(context);
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: ElevatedButton(
//                   key: ttr.keyButton2,
//                   onPressed: () {},
//                   child: Container(),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(50.0),
//                 child: SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: ElevatedButton(
//                     key: ttr.keyButton3,
//                     onPressed: () {},
//                     child: Container(),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.all(50.0),
//                 child: SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: ElevatedButton(
//                     key: ttr.keyButton4,
//                     onPressed: () {},
//                     child: Container(),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.all(50.0),
//                 child: SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: ElevatedButton(
//                     key: ttr.keyButton5,
//                     onPressed: () {},
//                     child: Container(),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       bottomNavigationBar: Stack(
//         children: [
//           Container(
//             height: 50,
//             child: Row(
//               children: [
//                 Expanded(
//                     child: Center(
//                       child: SizedBox(
//                         key: ttr.keyBottomNavigation1,
//                         height: 40,
//                         width: 40,
//                       ),
//                     )),
//                 Expanded(
//                     child: Center(
//                       child: SizedBox(
//                         key: ttr.keyBottomNavigation2,
//                         height: 40,
//                         width: 40,
//                       ),
//                     )),
//                 Expanded(
//                   child: Center(
//                     child: SizedBox(
//                       key: ttr.keyBottomNavigation3,
//                       height: 40,
//                       width: 40,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.business),
//                 label: 'Business',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.school),
//                 label: 'School',
//               ),
//             ],
//             // currentIndex: _selectedIndex,
//             selectedItemColor: Colors.amber[800],
//             onTap: (index) {},
//           ),
//         ],
//       ),
//     );
//   }
//
// }