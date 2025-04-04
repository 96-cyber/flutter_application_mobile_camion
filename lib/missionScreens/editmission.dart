// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/shared/snackbar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import '../shared/colors.dart';
import '../shared/customtextfield.dart';

class UpdateMission extends StatefulWidget {
  final String camionId;
  final String missionId;
  final String pointDepart;
  final String destination;
  final String consommation;
  final String distance;
  UpdateMission(
      {super.key,
      required this.missionId,
      required this.pointDepart,
      required this.destination,
      required this.consommation,
      required this.distance, 
      required this.camionId,
      });

  @override
  State<UpdateMission> createState() => _UpdateMissionState();
}

class _UpdateMissionState extends State<UpdateMission> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  // DateTime finDate = DateTime.now();
  // DateTime startDate = DateTime.now();
  bool isPicking = false;
  bool isPicking_2 = false;
  bool isLoading = false;

  TextEditingController pointDepartController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController consommationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();


   modifierMission() async {
    setState(() {
      isLoading = true;
    });

    try {
      CollectionReference mission = FirebaseFirestore.instance
          .collection('camions')
          .doc(widget.camionId)
          .collection("missions");
      mission.doc(widget.missionId).update({


        // 'start_date': startDate,
        // 'end_date': finDate,
        'point_depart': pointDepartController.text == "" ? widget.pointDepart : pointDepartController.text,
        'destination': destinationController.text == "" ? widget.destination : destinationController.text,
        'distance': distanceController.text == "" ? widget.distance : distanceController.text,
        'consommation': consommationController.text == "" ? widget.consommation : consommationController.text,
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
      text: 'Votre mission a été Modifier !',
      onConfirmBtnTap: () async {
       Get.back();
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
          "Modifier une Mission",
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
              // const Text("Date debut",
              //     style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              // const SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //   onTap: () async {
              //     DateTime? newStartDate = await showDatePicker(
              //         context: context,
              //         initialDate: startDate,
              //         firstDate: DateTime(2000),
              //         lastDate: DateTime(2100));
              //     if (newStartDate == null) return;

              //     setState(() {
              //       isPicking = true;
              //       startDate = newStartDate;
              //     });
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(vertical: 5),

              //     height: 48,
              //     // width: MediaQuery.sizeOf(context).width * 0.43,
              //     decoration: BoxDecoration(
              //         // color: const Color.fromARGB(255, 255, 255, 255),
              //         border: Border.all(color: Colors.black, width: 0.75),
              //         borderRadius: BorderRadius.circular(12)),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 12.0),
              //       child: Align(
              //           alignment: Alignment.centerLeft,
              //           child: isPicking
              //               ? Text(
              //                   "${startDate.day}/${startDate.month}/${startDate.year}",
              //                   style: const TextStyle(fontSize: 16),
              //                 )
              //               : const Text("")),
              //     ),
              //   ),
              // ),
              // const Gap(10),
              // const Text("Date Fin",
              //     style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              // const SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //   onTap: () async {
              //     DateTime? newFinDate = await showDatePicker(
              //         context: context,
              //         initialDate: finDate,
              //         firstDate: DateTime(2000),
              //         lastDate: DateTime(2100));
              //     if (newFinDate == null) return;

              //     setState(() {
              //       isPicking_2 = true;
              //       finDate = newFinDate;
              //     });
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(vertical: 5),
              //     height: 48,
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.black, width: 0.75),
              //         borderRadius: BorderRadius.circular(12)),
              //     child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: isPicking_2
              //             ? Padding(
              //                 padding: const EdgeInsets.only(left: 12.0),
              //                 child: Text(
              //                   "${finDate.day}/${finDate.month}/${finDate.year}",
              //                   style: const TextStyle(fontSize: 16),
              //                 ),
              //               )
              //             : const Text("")),
              //   ),
              // ),
              
              // const Gap(10),
              AddAvisTField(
                title: 'Point de depart',
                text: widget.pointDepart,
                controller: pointDepartController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
                title: 'destination',
                text: widget.destination,
                controller: destinationController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
                title: 'distance(Km)',
                text: widget.distance,
                controller: distanceController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
                title: 'Consommation',
                text: widget.consommation,
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
                          await modifierMission();
                          afficherAlert();
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Erreur',
                            text: 'Verifier tous les champs',
                          );
                        }
                      },
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
                              "Modifier votre Mission",
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
