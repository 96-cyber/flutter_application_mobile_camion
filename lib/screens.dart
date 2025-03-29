import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/Screens/chauffeurs.dart';
import 'package:flutter_application_mobile_camion/Screens/mission.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {

    final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
     return 
         Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Padding(
              padding:
                   EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 4 ,
                   right: MediaQuery.of(context).size.width / 4, 
                   top: 4, 
                   bottom: 4),
              child: GNav(
                gap: 10,
                color: Colors.grey,
                activeColor: Colors.indigo,
                curve: Curves.decelerate,
                padding: const EdgeInsets.only(bottom: 10, left: 6, right: 6, top: 2),
                onTabChange: (index) {
                  _pageController.jumpToPage(index);
                  setState(() {
                    currentPage = index;
                  });
                },
                tabs: const [
                      GButton(
                          icon: Icons.person_2_outlined,
                          text: 'Chauffeurs',
                        ),
                         GButton(
                          icon: Icons.notification_add,
                          text: 'Mission',
                        ),
                ],
              ),
            ),
            body: PageView(
              onPageChanged: (index) {},
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                 Chauffeurs(),
                 Mission(),
              ],
            ),
          );
  }
}