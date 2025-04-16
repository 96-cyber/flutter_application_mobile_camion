// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';
import '../shared/colors.dart';
import '../shared/customtextfield.dart';
import '../shared/snackbar.dart';

class AjouterCamion extends StatefulWidget {
   AjouterCamion({super.key});

  @override
  State<AjouterCamion> createState() => _AjouterCamionState();
}

class _AjouterCamionState extends State<AjouterCamion> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  bool isPicking = false;
  TextEditingController marqueController = TextEditingController();
  TextEditingController kilometrageController = TextEditingController();
    bool isLoading = false;

  ajouterCamion() async {
    setState(() {
      isLoading = true;
    });

    try {
      CollectionReference camion =
          FirebaseFirestore.instance.collection('camions');
      String newCamionId = const Uuid().v1();
      camion.doc(newCamionId).set({
        'camion_id' : newCamionId,
        "marque": marqueController.text,
        "Kilometrage": kilometrageController.text,
        "date_achat": startDate,
        'etat' : 'disponible'
        
      });
    } catch (err) {
      if(!mounted) return;
        showSnackBar(context, "ERROR :  $err ");
    }
    setState(() {
      isLoading = false;
    });
  }

    afficherAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Camion ajouter avec succes!',
      onConfirmBtnTap: () async{
       setState(() {
        marqueController.clear();
        kilometrageController.clear();
        isPicking = false;
      });
        Navigator.of(context).pop();
        // Get.off(()=>const Screens());
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
          "Ajouter un Camion",
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
              const Text("Date achat",
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
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.75),
                      borderRadius: BorderRadius.circular(12)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                      child: isPicking
                          ? Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                                "${startDate.day}/${startDate.month}/${startDate.year}",
                                style: const TextStyle(
                                    fontSize: 16),
                              ),
                          )
                          : const Text("")),
                ),
              ),
               const Gap(10),
              AddAvisTField(
                title: 'Marque',
                text: '',
                controller: marqueController,
                validator: (value) {
                  return value!.isEmpty ? "ne peut être vide" : null;
                },
              ),

              const Gap(10),
              AddAvisTField(
                title: 'Kilometrage',
                text: '',
                controller: kilometrageController,
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
                             await ajouterCamion();
                          afficherAlert();
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Erreur',
                              text: 'Ajouter Les informations necessaires', 
                            );
                          }
                        
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding:
                             isLoading
                                ? MaterialStateProperty.all(
                                    const EdgeInsets.all(9))
                                :
                            MaterialStateProperty.all(const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child:
                          isLoading
                              ? Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: whiteColor,
                                    size: 32,
                                  ),
                                )
                              :
                          const Text(
                        "Ajouter un Camion",
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