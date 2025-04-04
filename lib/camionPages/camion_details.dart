import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/missionScreens/ajouter_misssion.dart';
import 'package:flutter_application_mobile_camion/missionScreens/editmission.dart';
import 'package:flutter_application_mobile_camion/shared/colors.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';

class CamionDetails extends StatefulWidget {
  final String camionId;
  final String userId;
  final String userRole;
  CamionDetails(
      {super.key,
      required this.camionId,
      required this.userId,
      required this.userRole});

  @override
  State<CamionDetails> createState() => _CamionDetailsState();
}

class _CamionDetailsState extends State<CamionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Les Missions de ce Camion",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Get.to(() => AjouterMission(
                      camionId: widget.camionId,
                      userId: widget.userId,
                    ));
              },
              icon: const Icon(Icons.add_circle_outline_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: Column(
          children: [
            const Gap(30),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('camions')
                    .doc(widget.camionId)
                    .collection("missions")
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
                          thirdRingColor: Colors.pink.shade400),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          widget.userRole == "Responsable"
                              ? Get.to(() => UpdateMission(
                                    camionId: widget.camionId,
                                    missionId: data["mission_id"],
                                    pointDepart: data["point_depart"],
                                    destination: data["destination"],
                                    consommation: data['consommation'],
                                    distance: data['distance'],
                                  ))
                              : widget.userRole == "chauffeur" &&
                                      data['user_id'] == widget.userId
                                  ? Get.to(() => UpdateMission(
                                        camionId: widget.camionId,
                                        missionId: data["mission_id"],
                                        pointDepart: data["point_depart"],
                                        destination: data["destination"],
                                        consommation: data['consommation'],
                                        distance: data['distance'],
                                      ))
                                  : QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      text:
                                          "Vous n'avez pas les droits pour modifier cette mission",
                                      onConfirmBtnTap: () async {
                                        Navigator.of(context).pop();
                                      },
                                    );

                          ;
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  color: mainColor, width: 1.2)),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Point de depart 📍",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Gap(10),
                                    Text(
                                      "Destination 📍",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Gap(10),
                                    Text(
                                      "De ⌚",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Gap(10),
                                    Text(
                                      "Jusqu' ⌚",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Gap(10),
                                    Text(
                                      "Distance 🗺️",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                const Gap(20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['point_depart'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Gap(10),
                                      Text(
                                        data['destination'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Gap(10),
                                      Text(
                                        DateFormat('MMMM d,' 'y').format(
                                            data['start_date'].toDate()),
                                        style: const TextStyle(
                                            // fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Gap(10),
                                      Text(
                                        DateFormat('MMMM d,' 'y')
                                            .format(data['end_date'].toDate()),
                                        style: const TextStyle(
                                            // fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Gap(10),
                                      Text(
                                        data['distance'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.userRole == 'Responsable'
                                    ? IconButton(
                                        onPressed: () async {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            title: 'Confirmation',
                                            text:
                                                'Voulez-vous vraiment Cloturer Cette Mission !',
                                            onConfirmBtnTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("camions")
                                                  .doc(widget.camionId)
                                                  .collection("missions")
                                                  .doc(data['mission_id'])
                                                  .delete();

                                              Navigator.of(context).pop();
                                            },
                                            onCancelBtnTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.trash_circle,
                                          size: 28,
                                        ),
                                        color: Colors.red,
                                      )
                                    : widget.userRole == 'chauffeur' &&
                                            data['user_id'] == widget.userId
                                        ? IconButton(
                                            onPressed: () async {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                title: 'Confirmation',
                                                text:
                                                    'Voulez-vous vraiment Cloturer Cette Mission !',
                                                onConfirmBtnTap: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("camions")
                                                      .doc(widget.camionId)
                                                      .collection("missions")
                                                      .doc(data['mission_id'])
                                                      .delete();
                                                  Navigator.of(context).pop();
                                                },
                                                onCancelBtnTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.trash_circle,
                                              size: 28,
                                            ),
                                            color: Colors.red,
                                          )
                                        : Container(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
