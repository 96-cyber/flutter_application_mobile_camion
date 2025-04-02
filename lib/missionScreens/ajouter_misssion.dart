import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/shared/customtextfield.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';

import '../shared/colors.dart';

class AjouterMission extends StatefulWidget {
  const AjouterMission({super.key});

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



  TextEditingController pointdepartController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController consommationController = TextEditingController();

  afficherAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Mission ajouter avec succes!',
      onConfirmBtnTap: () {
        pointdepartController.clear();
        destinationController.clear();
        distanceController.clear();
        consommationController.clear();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
                  style:  TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
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
                  // width: MediaQuery.sizeOf(context).width * 0.43,
                  decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.black, width: 0.75),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: isPicking
                          ? Text(
                              "${startDate.day}/${startDate.month}/${startDate.year}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          : const Text("")),
                ),
              ),
              const Gap(10),
              const Text("Date Fin",
                  style:  TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
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
                  // width: MediaQuery.sizeOf(context).width * 0.43,
                  decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.black, width: 0.75),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: isPicking_2
                          ? Text(
                              "${finDate.day}/${finDate.month}/${finDate.year}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
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
                title: 'distance(Km)',
                text: '',
                controller: distanceController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),
              const Gap(10),
              AddAvisTField(
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
                      onPressed: () async {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding:
                            //  isLoading
                            //     ? MaterialStateProperty.all(
                            //         const EdgeInsets.all(9))
                            //     :
                            MaterialStateProperty.all(const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child:
                          // isLoading
                          //     ? Center(
                          //         child:
                          //             LoadingAnimationWidget.staggeredDotsWave(
                          //           color: whiteColor,
                          //           size: 32,
                          //         ),
                          //       )
                          //     :
                          const Text(
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
