// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart' as path_pac;
// import 'package:image_picker/image_picker.dart';
//
//  class MyStorage{
//
//   firebase_storage.FirebaseStorage mainStorage = firebase_storage.FirebaseStorage.instance;
//
//   Future<void> uploadFile(String filePath,String fileName) async{
//     File file = File(filePath);
//     try{
//       await mainStorage.ref('testFolder/$fileName').putFile(file);
//     }on firebase_core.FirebaseException catch (e){
//       print(e);
//     }
//
//
//   }
//
//   Future<firebase_storage.ListResult> load_files_fromPath(String path) async{
//     firebase_storage.ListResult results = await mainStorage.ref(path).listAll();
//
//     results.items.forEach((firebase_storage.Reference ref) {
//       print('Found file: $ref');
//     });
//     return results;
//   }
//
//
//   Future<void> list_file_directories(String path) async {
//     firebase_storage.ListResult result = await mainStorage.ref(path).listAll();
//
//     result.items.forEach((firebase_storage.Reference ref) {
//      // print('Found file: $ref');
//     });
//
//     result.prefixes.forEach((firebase_storage.Reference ref) {
//      // print('Found directory: $ref');
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> _loadImages() async {
//     List<Map<String, dynamic>> files = [];
//
//     final ListResult results = await mainStorage.ref().list();
//     final List<Reference> allFiles = results.items;
//
//     await Future.forEach<Reference>(allFiles, (file) async {
//
//       final String fileUrl = await file.getDownloadURL();
//       final FullMetadata fileMeta = await file.getMetadata();
//
//       files.add({
//         "url": fileUrl,
//         "path": file.fullPath,
//         "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
//         "description": fileMeta.customMetadata?['description'] ?? 'No description'
//       });
//     });
//
//     return files;
//   }
//
//   Future<void> uploadString() async {
//     String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';
//
//     try {
//       await firebase_storage.FirebaseStorage.instance
//           .ref('uploads/hello-world.text')
//           .putString(dataUrl, format: firebase_storage.PutStringFormat.dataUrl);
//     } on firebase_core.FirebaseException catch (e) {
//       // e.g, e.code == 'canceled'
//     }
//   }
//
//
// //#################################################"
//
//   Future<XFile?> selectImage(ImageSource source,BuildContext context) async {
//
//     final pickedFile = await ImagePicker().pickImage(
//       source: source,
//     );
//     Navigator.pop(context);
//
//     return pickedFile!;
//
//   }
//
//    Future<XFile?> _showChoiceDialog( ctx) async{
//     XFile? pickedFile;
//      showDialog(
//         context: ctx,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               "Choose option",
//               style: TextStyle(color: Colors.blue),
//             ),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: [
//                   Divider(
//                     height: 1,
//                     color: Colors.blue,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       pickedFile =  selectImage(ImageSource.gallery,context) as XFile?;
//                     },
//                     title: Text("Gallery"),
//                     leading: Icon(
//                       Icons.account_box,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   Divider(
//                     height: 1,
//                     color: Colors.blue,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       pickedFile =  selectImage(ImageSource.camera,context) as XFile?;
//                     },
//                     title: Text("Camera"),
//                     leading: Icon(
//                       Icons.camera,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//
//     return pickedFile!;
//   }
//   // Select and image from the gallery or take a picture with the camera
//   // Then upload to Firebase Storage
//   Future<void> upload_X(String path , BuildContext context) async {
//
//     try {
//
//       XFile? pickedImage = await _showChoiceDialog(context);
//
//      //print('####${pickedImage?.name.toString()}');
//      print('#### image picked after awaitng ');
//
//       // choose img from phone
//       // pickedImage = await ImagePicker().pickImage(
//       //     source: inputSource == 'camera'
//       //         ? ImageSource.camera
//       //         : ImageSource.gallery,
//       //     maxWidth: 1920);
//
//       String fileName = path_pac.basename(pickedImage!.path);
//       File imageFile = File(pickedImage.path);
//
//       // Upload Image to Fb
//       try {
//         // Uploading the selected image with some custom meta data
//         Reference strRef = mainStorage.ref('$path/$fileName');//path to store image
//
//         final metadata = SettableMetadata(customMetadata: {
//           'uploaded_by': 'A bad guy',
//           'description': 'Some description...'
//         });
//
//         UploadTask uploadTask = strRef.putFile(imageFile,metadata);
//
//         String url = await (await uploadTask).ref.getDownloadURL();
//
//         print('#### added File with name : ($fileName) in path :"$path" and url :($url)');
//
//
//       } on FirebaseException catch (e) {
//         if (kDebugMode) {
//           print('FirebaseException while upload file to storage: $e');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('catch (e) while upload file to storage: $e');
//       }
//     }
//   }
//
//   // Retriew the uploaded images
//   // This function is called when the app launches for the first time or when an image is uploaded or deleted
//   Future<List<Map<String, dynamic>>> loadImages_X(String path) async {
//     List<Map<String, dynamic>> files = [];
//
//     final ListResult result = await mainStorage.ref(path).list();
//     final List<Reference> allFiles = result.items;
//
//     // forEach image in this path
//     await Future.forEach<Reference>(allFiles, (file) async {
//       final String fileUrl = await file.getDownloadURL();
//       final FullMetadata fileMeta = await file.getMetadata();
//       files.add({
//         "url": fileUrl,
//         "path": file.fullPath,
//         "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
//         "description": fileMeta.customMetadata?['description'] ?? 'No description'
//       });
//     });
//
//     return files;
//   }
//
//   // Delete the selected image
//   // This function is called when a trash icon is pressed
//   Future<void> delete_X(String ref) async {
//     await mainStorage.ref(ref).delete();
//
//   }
//
//
//
//  }
//
//
//
// class StorageUI extends StatefulWidget {
//
//   @override
//   _StorageUIState createState() => _StorageUIState();
// }
// class _StorageUIState extends State<StorageUI> {
//   FirebaseAuth auth = FirebaseAuth.instance;
//
//
//   @override
//   void initState() {
//     super.initState();
//     if (auth.currentUser != null) {
//       print('registered as user');
//     } else {
//       signInAnonymously();
//
//     }
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     auth.signOut();
//   }
//
//   void signInAnonymously() async{
//      try {
//        final userCredential = await FirebaseAuth.instance.signInAnonymously();
//        print('registered as anony');
//      } on FirebaseAuthException catch (e) {
//        switch (e.code) {
//          case "operation-not-allowed":
//            print("Anonymous auth hasn't been enabled for this project.");
//            break;
//          default:
//            print("Unknown error.");
//        }
//      }
//   }
//
//
//   //firebase_storage.FirebaseStorage Storage = firebase_storage.FirebaseStorage.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('my storage UI'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton.icon(
//                     onPressed: () {
//                       MyStorage().upload_X('',context).whenComplete(() {
//                         if(this.mounted){
//                           setState((){});
//
//                         }
//                       });
//                       },
//                     icon: const Icon(Icons.camera),
//                     label: const Text('camera')),
//                 ElevatedButton.icon(
//                     onPressed: () {
//                       MyStorage().upload_X('',context).whenComplete(() {
//                         if(this.mounted){
//                           setState((){});
//
//                         }
//                       });
//                     },
//                     icon: const Icon(Icons.library_add),
//                     label: const Text('Gallery')),
//               ],
//             ),
//             Expanded(
//               child: FutureBuilder(
//                 future: MyStorage().loadImages_X(''),// select path to get images from
//                 builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     if(snapshot.data!.isEmpty){
//                       return const Center(
//                         child: Text('No Images Found'),
//                       );
//                     }else{
//                       return ListView.builder(
//                         itemCount: snapshot.data?.length ,
//                         itemBuilder: (context, index) {
//                           final Map<String, dynamic> image = snapshot.data![index];
//
//                           print('### image = ${image.runtimeType}');
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             child: ListTile(
//                               dense: false,
//                               leading: Image.network(image['url']),
//                               title: Text(image['uploaded_by']),
//                               subtitle: Text(image['description']),
//                               trailing: IconButton(
//                                 onPressed: ()  {
//                                   print('## deleted path ${image['path']}');
//                                   MyStorage().delete_X(image['path']);
//                                   if(this.mounted){
//                                     setState((){});
//                                    }
//                                   },
//
//                                 icon: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }
//
//                   }
//                   return const Center(
//                       child: CircularProgressIndicator(),
//                   );
//
//
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.add_circle,
//         ),
//         onPressed: (){
//
//           MyStorage().upload_X('',context).whenComplete(() {
//             print('## img added');
//             if(this.mounted){
//               setState((){});
//             }
//           });
//
//         },
//       ),
//     );
//   }
// }
