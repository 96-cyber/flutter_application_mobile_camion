import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/profileScreens/profilebutton.dart';
import 'package:flutter_application_mobile_camion/profileScreens/profiletextfield.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  DateTime startDate = DateTime.now();
  bool isPicking = false;
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController anniversaireController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 32,
                  color: const Color.fromARGB(255, 16, 16, 16),
                  secondRingColor: Colors.indigo,
                  thirdRingColor: Colors.pink.shade400),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(LineAwesomeIcons.angle_left_solid),
              ),
              title: const Text(
                "Profile",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SvgPicture.asset(
                      'Asset/images/profilepic.svg',
                      height: 100.0,
                      width: 100.0,
                      allowDrawingOutsideViewBox: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ProfileTextField(
                          title: "Nom",
                          text: userData['nom'] == ""
                              ? "Entrer votre nom"
                              : userData['nom'].substring(0, 1).toUpperCase() +
                                  userData['nom'].substring(1),
                          controller: nomController,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ProfileTextField(
                          title: "Prénom",
                          text: userData['prenom'] == ""
                              ? "Entrer votre prenom"
                              : userData['prenom'].substring(0, 1).toUpperCase() +
                                  userData['prenom'].substring(1),
                          controller: prenomController,
                        )),
                      ],
                    ),
                
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ProfileTextField(
                          title: "Email",
                          text: userData['email'] == ""
                              ? "Entrer votre email"
                              : userData['email'],
                          controller: emailController,
                        )),
                      ],
                    ),
                
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ProfileTextField(
                          title: "Télphone",
                          text: userData['phone'] == ""
                              ? "Entrer votre numéro de télphone"
                              : userData['phone'],
                          controller: phoneController,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                title: "Accès refusé",
                                text:
                                    "Vous n'avez pas les droits pour modifier Role",
                                onConfirmBtnTap: () async {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            child: AbsorbPointer(
                              // empêche toute interaction avec le champ
                              child: ProfileTextField(
                                title: "Rôle",
                                text: userData['role'],
                                controller: roleController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                
                    const SizedBox(
                      height: 10,
                    ),
                    userData['anniversaire'] == ""
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Anniversaire :",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime? newStartDate =
                                            await showDatePicker(
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
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey, width: 1.2),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: isPicking
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0),
                                                    child: Text(
                                                      "${startDate.day}/${startDate.month}/${startDate.year}",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )
                                                : const Text("")),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Anniversaire :",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime? newStartDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: startDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (newStartDate == null) return;
                
                                        setState(() {
                                          isPicking = true;
                                          startDate = newStartDate;
                                        });
                                      },
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12.0),
                                            child: Text(
                                              "${startDate.day}/${startDate.month}/${startDate.year}",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                
                    const SizedBox(
                      height: 20,
                    ),
                    //  const Spacer(),
                    Row(
                      children: [
                        Expanded(
                            child: ProfileButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                      .update({
                                    "nom": nomController.text == ""
                                        ? userData['nom']
                                        : nomController.text,
                                    "prenom": prenomController.text == ""
                                        ? userData['prenom']
                                        : prenomController.text,
                                    "email": emailController.text == ""
                                        ? userData['email']
                                        : emailController.text,
                                    "role": roleController.text == ""
                                        ? userData['role']
                                        : roleController.text,
                                    "anniversaire": isPicking
                                        ? DateFormat('MMMM d,' 'y')
                                            .format(startDate)
                                        : userData['anniversaire'],
                                  });
                                  setState(() {});
                                  Get.back();
                                },
                                textButton: "Mettre à jour votre profil")),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
