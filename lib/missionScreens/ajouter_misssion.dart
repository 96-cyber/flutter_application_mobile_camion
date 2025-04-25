// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
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

  const AjouterMission({super.key, required this.camionId, required this.userId});

  @override
  State<AjouterMission> createState() => _AjouterMissionState();
}

class _AjouterMissionState extends State<AjouterMission> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  DateTime finDate = DateTime.now();
  DateTime startDate = DateTime.now();
  bool isPicking = false;
  bool isPicking_2 = false;
  bool isLoading = false;

  TextEditingController pointdepartController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController consommationController = TextEditingController();

  List<Map<String, dynamic>> chauffeursList = [];
  String? selectedChauffeurId;
  bool isLoadingChauffeurs = true;

  @override
  void initState() {
    super.initState();
    fetchChauffeurs();
  }

  Future<void> fetchChauffeurs() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('role', isEqualTo: 'chauffeur')
          .get();

      chauffeursList = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'nom': doc.data()['nom'] ?? 'Sans nom',
              })
          .toList();

      if (mounted) {
        setState(() {
          isLoadingChauffeurs = false;
          if (chauffeursList.isNotEmpty) {
            selectedChauffeurId = chauffeursList.first['id'];
          }
        });
      }
    } catch (e) {
      print("Erreur lors du chargement des chauffeurs : $e");
    }
  }

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

      final selectedChauffeur = chauffeursList.firstWhere(
        (chauffeur) => chauffeur['id'] == selectedChauffeurId,
        orElse: () => {'id': '', 'nom': ''},
      );

      // 🔹 Récupérer le responsable (user courant)
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      String nomResponsable = userSnapshot.data()?['nom'] ?? '';
      String prenomResponsable = userSnapshot.data()?['prenom'] ?? '';

      // 🔹 Ajouter la mission
      await mission.doc(newMissionId).set({
        'mission_id': newMissionId,
        'user_id': widget.userId,
        'start_date': startDate,
        'end_date': finDate,
        'point_depart': pointdepartController.text,
        'destination': destinationController.text,
        'distance': "${distanceController.text}Km",
        'consommation': "${consommationController.text}L",
        'chauffeur_id': selectedChauffeur['id'],
        'chauffeur_nom': selectedChauffeur['nom'],
      });

      // 🔹 Ajouter une notification pour le chauffeur
     await FirebaseFirestore.instance
    .collection('users')
    .doc(selectedChauffeur['id'])
    .collection('notifications')
    .add({
      'nom_responsable': nomResponsable,
      'prenom_responsable': prenomResponsable,
      'content': 'Vous avez une nouvelle mission',
      'date': Timestamp.now(),
    });

      afficherAlert();
    } catch (err) {
      if (!mounted) return;
      showSnackBar(context, "Erreur : $err");
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
        child: SingleChildScrollView(
          child: Form(
            key: formstate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(30),
                const Text("Date debut",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
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
                            : const Text(""),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                const Text("Date Fin",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
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
                    height: 48,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.75),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: isPicking_2
                            ? Text(
                                "${finDate.day}/${finDate.month}/${finDate.year}",
                                style: const TextStyle(fontSize: 16),
                              )
                            : const Text(""),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                AddAvisTField(
                  title: 'Point de depart',
                  text: '',
                  controller: pointdepartController,
                  validator: (value) => value!.isEmpty ? "ne peut être vide" : null,
                ),
                const Gap(10),
                AddAvisTField(
                  title: 'Destination',
                  text: '',
                  controller: destinationController,
                  validator: (value) => value!.isEmpty ? "ne peut être vide" : null,
                ),
                const Gap(10),
                AddAvisTField(
                  textInputType: TextInputType.number,
                  title: 'Distance (Km)',
                  text: '',
                  controller: distanceController,
                  validator: (value) => value!.isEmpty ? "ne peut être vide" : null,
                ),
                const Gap(10),
                AddAvisTField(
                  textInputType: TextInputType.number,
                  title: 'Consommation',
                  text: '',
                  controller: consommationController,
                  validator: (value) => value!.isEmpty ? "ne peut être vide" : null,
                ),
                const Gap(10),
                isLoadingChauffeurs
                    ? const Center(child: CircularProgressIndicator())
                    : chauffeursList.isEmpty
                        ? const Text("Aucun chauffeur disponible.")
                        : DropdownButtonFormField<String>(
                            value: selectedChauffeurId,
                            decoration: InputDecoration(
                              labelText: 'Chauffeur',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) =>
                                value == null ? 'Veuillez sélectionner un chauffeur' : null,
                            items: chauffeursList.map((chauffeur) {
                              return DropdownMenuItem<String>(
                                value: chauffeur['id'],
                                child: Text(chauffeur['nom']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedChauffeurId = value;
                              });
                            },
                          ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
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
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Erreur',
                              text: 'Ajouter les informations nécessaires',
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(mainColor),
                          padding: isLoading
                              ? MaterialStateProperty.all(const EdgeInsets.all(9))
                              : MaterialStateProperty.all(const EdgeInsets.all(12)),
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
      ),
    );
  }
}
