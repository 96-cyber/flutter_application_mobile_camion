// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/loginScreens/login.dart';
import 'package:flutter_application_mobile_camion/profileScreens/edit_profile.dart';
import 'package:flutter_application_mobile_camion/profileScreens/profilecard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          backgroundColor: Colors.white,
                     appBar: AppBar(
                      backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
                  "Profile",
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                ),),
         body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
              ),
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset(
                    'Asset/images/profilepic.svg',
                    height: 100.0,
                    width: 100.0,
                    allowDrawingOutsideViewBox: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['nom'].substring(0, 1).toUpperCase() +
                        userData['nom'].substring(1) +
                        " " +
                        userData['prenom'].substring(0, 1).toUpperCase() +
                        userData['prenom'].substring(1),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Text(
                    userData['email'],
                    style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                         Get.to(() => const EditProfile(),
                            transition: Transition.rightToLeft);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Modifier Votre Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileCard(
                    text: "Paramétres",
                    icon: LineAwesomeIcons.cog_solid,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileCard(
                    text: "Obtenir de l'aide",
                    icon: LineAwesomeIcons.question_solid,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileCard(
                    text: "À propos de nous",
                    icon: LineAwesomeIcons.info_solid,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                
                  ProfileCard(
                    text: "Supprimer le compte",
                    icon: LineAwesomeIcons.trash_solid,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false);
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child: const Icon(
                        LineAwesomeIcons.sign_out_alt_solid,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text(
                      "Déconnecter",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.red),
                    ),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: const Icon(
                        LineAwesomeIcons.angle_right_solid,
                        color: Colors.black45,
                        size: 18,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
  }
}