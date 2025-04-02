import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/missionScreens/ajouter_misssion.dart';
import 'package:flutter_application_mobile_camion/shared/colors.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CamionDetails extends StatefulWidget {
  const CamionDetails({super.key});

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
              onPressed: () async{
                Get.to(()=>const AjouterMission());
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: mainColor, width: 1.2)),
              elevation: 5,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        "Point de depart 📍",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Gap(10),
                      Text(
                        "Destination 📍",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Gap(10),
                      Text(
                        "De ⌚",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Gap(10),
                      Text(
                        "Jusqu' ⌚",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Gap(10),
                      Text(
                        "Distance 🗺️",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ], 
                    
                    
                    ),
                    Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Text(
                          "Tunis",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                         Gap(10),
                        Text(
                          "Bizerte",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Gap(10),
                        Text(
                          "12/06/2023",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Gap(10),
                        Text(
                          "13/06/2023",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                         Gap(10),
                        Text(
                          "250km",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                    ,Gap(80),
                  ],
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
