import 'dart:ffi';

import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'fireBase.dart';


class FireBaseView extends StatefulWidget {
  @override
  State<FireBaseView> createState() => _FireBaseViewState();
}

class _FireBaseViewState extends State<FireBaseView> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            ListView(
              children: <Widget>[
                TextButton(
                    onPressed: () async {
                      await addElementsToList(['d'], 'garages', '90vy5O8Q11ZkM4OL8ic5', usersCollName, canAddExistingElements: false);
                    },
                    child: Text('add')),
                TextButton(
                    onPressed: () async {
                      await removeElementsFromList(['a', 'b'], 'garages', '90vy5O8Q11ZkM4OL8ic5', usersCollName);
                    },
                    child: Text('remove')),
                const Icon(Icons.access_alarm),
              ],
            ),

            /// Test btn 0
            Positioned(
              height: 60,
              width: 60,
              bottom: 150,
              left: 15,
              child: FloatingActionButton.extended(
                heroTag: 'test0',
                onPressed: () {
                  test();
                },
                label: const Icon(Icons.transfer_within_a_station),
              ),
            ),

            /// add
            Positioned(
              height: 60,
              width: 60,
              bottom: 210,
              left: 15,
              child: FloatingActionButton.extended(
                heroTag: 'test1',
                onPressed: () {
                  addDoc(testColl);
                },
                label: const Text('add'),
              ),
            ),

            /// update
            Positioned(
              height: 60,
              width: 60,
              bottom: 270,
              left: 15,
              child: FloatingActionButton.extended(
                heroTag: 'test1',
                onPressed: () {
                  updateDoc(testColl,'EMd6w5giITIhMXAAkJJj',{});
                },
                label: const Text('update'),
              ),
            ),

            /// get
            Positioned(
              height: 60,
              width: 60,
              bottom: 40,
              left: 15,
              child: FloatingActionButton.extended(
                heroTag: 'test2',
                onPressed: () {
                  getDocProps(testColl,'EMd6w5giITIhMXAAkJJj');
                },
                label: const Icon(Icons.download_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// type doc of documents in collection is <JsonQueryDocumentSnapshot>
// limit(3)=> first 3 docs
// limitToLast(3)=> last 3 docs
// descending = true => reversed

///lsit of documents can be :
//List<DocumentSnapshot> or List<QueryDocumentSnapshot>

//            stream: firestore.collection('messages').snapshots(),=>streamBuilder accepts only snapshots