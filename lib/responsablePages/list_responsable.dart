import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/responsablePages/add_responsable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../shared/colors.dart';

class ListRresponsable extends StatefulWidget {
  const ListRresponsable({super.key});

  @override
  State<ListRresponsable> createState() => _ListRresponsableState();
}

class _ListRresponsableState extends State<ListRresponsable> {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Responsable')
      .snapshots();

      
      Map userData = {};
  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data()!;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
     return  Scaffold(
            appBar: AppBar(
              actions: [
        userData['role'] == 'admin' ? SizedBox():           IconButton(
                  icon: const Icon(
                    CupertinoIcons.add_circled_solid,
                    color: mainColor,
                  ),
                  onPressed: () async {
                   Get.to(()=>const AddResponsable());
                  },
                )
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Liste des Responsables",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erreur de chargement'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chauffeurs = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: chauffeurs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 🟩 2 colonnes
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final data = chauffeurs[index].data()!
                          as Map<String, dynamic>;

                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Image.asset(
  'Asset/images/res.png',
  height: 95.0,
  width: 95.0,
  fit: BoxFit.cover,
),
                              const Gap(10),
                              Text(
                                data['nom'] ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: blackColor,
                                ),
                              ),
                              const Gap(5),
                              Text(
                                data['prenom'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
  }
  }