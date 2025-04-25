import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../shared/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("notifications")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
            
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      size: 32,
                      color: const Color.fromARGB(255, 16, 16, 16),
                      secondRingColor: Colors.indigo,
                      thirdRingColor: Colors.pink.shade400,
                    ),
                  );
                }
            
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['nom_responsable'] + " " + data["prenom_responsable"], 
                          style: const TextStyle(
                              color: mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          data['content'],
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "Asset/images/point.svg",
                              height: 14,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              // "12/01/2023",
                              DateFormat('yMMMd')
                                  .format(data['date'].toDate()),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                    ;
                  }).toList(),
                );
              },
            )));
  }
}
