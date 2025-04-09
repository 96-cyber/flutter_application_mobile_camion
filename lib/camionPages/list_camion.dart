import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/camionPages/ajouter_camion.dart';
import 'package:flutter_application_mobile_camion/camionPages/camion_details.dart';
import 'package:flutter_application_mobile_camion/shared/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ListCamion extends StatefulWidget {
  const ListCamion({super.key});

  @override
  State<ListCamion> createState() => _ListCamionState();
}

class _ListCamionState extends State<ListCamion> {
  TextEditingController marqueController = TextEditingController();
  TextEditingController kilometrageController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String searchText = ""; // 🆕 pour la recherche

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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                size: 32,
                color: const Color.fromARGB(255, 16, 16, 16),
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600, width: 1.1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Expanded(
  child: TextField(
    controller: searchController, 
    onChanged: (value) {
      setState(() {
        searchText = value.toLowerCase();
      });
    },
    decoration: const InputDecoration(
      hintText: 'Recherche...',
      border: InputBorder.none,
    ),
  ),
),
                    userData['role'] == 'Responsable'
                        ? IconButton(
                            onPressed: () {
                              Get.to(() => AjouterCamion());
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "Liste des Camions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('camions')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              size: 32,
                              color: const Color.fromARGB(255, 16, 16, 16),
                              secondRingColor: Colors.indigo,
                              thirdRingColor: Colors.pink.shade400,
                            ),
                          );
                        }

                        final filteredDocs = snapshot.data!.docs.where((doc) {
                          final data = doc.data()! as Map<String, dynamic>;
                          final marque =
                              data['marque'].toString().toLowerCase();
                          return marque.contains(searchText);
                        }).toList();

                        return ListView(
                          children: filteredDocs.map((document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchText =
                                      ""; 
                                      searchController.clear(); 
                                });
                                Get.to(() => CamionDetails(
                                      camionId: data['camion_id'],
                                      userId: userData['uid'],
                                      userRole: userData['role'],
                                    ));
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: mainColor, width: 1.2),
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'Asset/images/truck.svg',
                                            height: 120.0,
                                            width: 120.0,
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['marque'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    DateFormat('MMMM d, y')
                                                        .format(
                                                            data['date_achat']
                                                                .toDate()),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    data['Kilometrage'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                          userData['role'] == 'Responsable'
                                              ? Column(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Retour",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'camions')
                                                                      .doc(data[
                                                                          'camion_id'])
                                                                      .update({
                                                                    'marque': marqueController
                                                                            .text
                                                                            .isEmpty
                                                                        ? data[
                                                                            'marque']
                                                                        : marqueController
                                                                            .text,
                                                                    'Kilometrage': kilometrageController
                                                                            .text
                                                                            .isEmpty
                                                                        ? data[
                                                                            'Kilometrage']
                                                                        : kilometrageController
                                                                            .text,
                                                                  });
                                                                  marqueController
                                                                      .clear();
                                                                  kilometrageController
                                                                      .clear();
                                                                  if (!mounted)
                                                                    return;
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Modifier",
                                                                  style: TextStyle(
                                                                      color:
                                                                          mainColor),
                                                                ),
                                                              ),
                                                            ],
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                            content: SizedBox(
                                                              height: 250,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: 100,
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          marqueController,
                                                                      maxLines:
                                                                          null,
                                                                      expands:
                                                                          true,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            data['marque'],
                                                                        hintStyle:
                                                                            const TextStyle(color: Colors.black87),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            borderSide: const BorderSide(color: Color.fromARGB(255, 220, 220, 220))),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25)),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            borderSide: const BorderSide(color: Color.fromARGB(255, 220, 220, 220))),
                                                                        contentPadding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                15,
                                                                            vertical:
                                                                                15),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Gap(20),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: 100,
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          kilometrageController,
                                                                      maxLines:
                                                                          null,
                                                                      expands:
                                                                          true,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            data['Kilometrage'],
                                                                        hintStyle:
                                                                            const TextStyle(color: Colors.black87),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            borderSide: const BorderSide(color: Color.fromARGB(255, 220, 220, 220))),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25)),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            borderSide: const BorderSide(color: Color.fromARGB(255, 220, 220, 220))),
                                                                        contentPadding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                15,
                                                                            vertical:
                                                                                15),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Color.fromARGB(
                                                            255, 117, 244, 121),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "camions")
                                                            .doc(data[
                                                                'camion_id'])
                                                            .delete();
                                                      },
                                                      child: const Icon(
                                                        CupertinoIcons
                                                            .trash_circle,
                                                        color: Colors.red,
                                                        size: 28,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
