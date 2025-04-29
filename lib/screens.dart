import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/camionPages/list_camion.dart';
import 'package:flutter_application_mobile_camion/chauffeur/listchauffeur.dart';
import 'package:flutter_application_mobile_camion/notificationsPages/notifications.dart';
import 'package:flutter_application_mobile_camion/notificationsPages/notifmecanicien.dart';
import 'package:flutter_application_mobile_camion/profileScreens/profile.dart';
import 'package:flutter_application_mobile_camion/responsablePages/list_responsable.dart';
import 'package:flutter_application_mobile_camion/shared/colors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'dashbord_admin.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
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

  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            bottomNavigationBar: Padding(
              padding:
                  const EdgeInsets.only(left: 25, right: 25, top: 4, bottom: 4),
              child: GNav(
                backgroundColor: Colors.white,
                gap: 10,
                color: Colors.grey,
                activeColor: mainColor,
                curve: Curves.decelerate,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 6, right: 6, top: 2),
                onTabChange: (index) {
                  _pageController.jumpToPage(index);
                  setState(() {
                    currentPage = index;
                  });
                },
                tabs: [
                  const GButton(
                    icon: Icons.list_alt,
                    text: 'List Camion',
                  ),
                  userData['role'] == 'chauffeur' ||
                          userData['role'] == 'mecanicien'
                      ? const GButton(
                          icon: Icons.notifications_active_outlined,
                          text: 'Notifications',
                        )
                      : userData['role'] == 'admin'
                          ? const GButton(
                              icon: CupertinoIcons.list_number_rtl,
                              text: 'Responsable',
                            )
                          : const GButton(
                              icon: CupertinoIcons.list_number_rtl,
                              text: 'Chauffeur',
                            ),
                  const GButton(
                    icon: CupertinoIcons.person_alt_circle,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
            body: PageView(
              onPageChanged: (index) {},
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                const ListCamion(),
                userData['role'] == 'chauffeur'
                    ? const Notifications()
                    : userData['role'] == 'admin'
                    ? const DashboardPage()
                       // ? const ListRresponsable()
                        : userData['role'] == 'Responsable'
                            ? const ListChaffeurs()
                            : const NotifMecanicien(),
                const Profile(),
              ],
            ),
          );
  }
}
