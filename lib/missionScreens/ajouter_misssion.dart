// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/shared/customtextfield.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';

import '../shared/colors.dart';
import '../shared/snackbar.dart';

class AjouterMission extends StatefulWidget {
  final String camionId;
  final String userId;
  AjouterMission({super.key, required this.camionId, required this.userId});

  @override
  State<AjouterMission> createState() => _AjouterMissionState();
}

class _AjouterMissionState extends State<AjouterMission> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  DateTime finDate = DateTime.now();
  DateTime startDate = DateTime.now();
  bool isPicking = false;
  bool isPicking_2 = false;
  String newMissionId = const Uuid().v1();
  bool isLoading = false;

  TextEditingController pointdepartController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController consommationController = TextEditingController();

  ajouterMission() async {
    setState(() {
      isLoading = true;
    });

    try {
      CollectionReference mission = FirebaseFirestore.instance
          .collection('camions')
          .doc(widget.camionId)
          .collection("missions");
      String newMissionId = const Uuid().v1();
      mission.doc(newMissionId).set({
        'mission_id': newMissionId,
        'user_id': widget.userId,
        'start_date': startDate,
        'end_date': finDate,
        'point_depart': pointdepartController.text,
        'destination': destinationController.text,
        'distance': "${distanceController.text}Km",
        'consommation': "${consommationController.text}L",
      });
    } catch (err) {
      if (!mounted) return;
      showSnackBar(context, "Erreur :  $err ");
    }
    setState(() {
      isLoading = false;
    });
  }

  afficherAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Votre mission a été ajoutée !',
      onConfirmBtnTap: () async {
        setState(() {
          pointdepartController.clear();
          destinationController.clear();
          distanceController.clear();
          consommationController.clear();
          isPicking = false;
          isPicking_2 = false;
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Ajouter une Mission",
          style: TextStyle(
            fontSize: 17,
            color: blackColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formstate,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              const Text("Date debut",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? newStartDate = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (newStartDate == null) return;
          
                  setState(() {
                    isPicking = true;
                    startDate = newStartDate;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 48,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.75),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: isPicking
                            ? Text(
                                "${startDate.day}/${startDate.month}/${startDate.year}",
                                style: const TextStyle(fontSize: 16),
                              )
                            : const Text("")),
                  ),
                ),
              ),
              const Gap(10),
              const Text("Date Fin",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? newFinDate = await showDatePicker(
                      context: context,
                      initialDate: finDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (newFinDate == null) return;
          
                  setState(() {
                    isPicking_2 = true;
                    finDate = newFinDate;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 48,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.75),
                      borderRadius: BorderRadius.circular(12)),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: isPicking_2
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "${finDate.day}/${finDate.month}/${finDate.year}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            )
                          : const Text("")),
                ),
              ),
              const Gap(10),
              AddAvisTField(
                title: 'Point de depart',
                text: '',
                controller: pointdepartController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
                title: 'destination',
                text: '',
                controller: destinationController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
                textInputType: TextInputType.number,
                title: 'distance(Km)',
                text: '',
                controller: distanceController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
                  textInputType: TextInputType.number,
                title: 'Consommation',
                text: '',
                controller: consommationController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
  if (formstate.currentState!.validate()) {
    // Vérifier que la date de début est avant la date de fin
    if (!startDate.isBefore(finDate)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Date invalide',
        text: 'La date de début doit être antérieure à la date de fin.',
      );
      return;
    }

    await ajouterMission();
    afficherAlert();
  } else {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Erreur',
      text: 'Ajouter les informations nécessaires',
    );
  }
},

                      // onPressed: () async {
                        // if (formstate.currentState!.validate()) {
                        //   await ajouterMission();
                        //   afficherAlert();
                        // } else {
                        //   QuickAlert.show(
                        //     context: context,
                        //     type: QuickAlertType.error,
                        //     title: 'Erreur',
                        //     text: 'Ajouter Les informations necessaires',
                        //   );
                        // }
                        
                      // },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding: isLoading
                            ? MaterialStateProperty.all(const EdgeInsets.all(9))
                            : MaterialStateProperty.all(
                                const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: isLoading
                          ? Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: whiteColor,
                                size: 32,
                              ),
                            )
                          : const Text(
                              "Ajouter une Mission",
                              style: TextStyle(fontSize: 16, color: whiteColor),
                            ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
