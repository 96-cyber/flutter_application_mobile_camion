import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/chauffeur/ajouterchauffeur.dart';
import 'package:flutter_application_mobile_camion/chauffeur/listchauffeur.dart';
import 'package:flutter_application_mobile_camion/responsablePages/add_responsable.dart';
import 'package:flutter_application_mobile_camion/responsablePages/list_responsable.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'mecanicienpages/addmecanicien.dart';
import 'mecanicienpages/listmecanicien.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

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
  
  Widget _buildSection({
    required String title,
    required VoidCallback onAdd,
    required Widget listContent,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec titre + bouton Ajouter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 28),
                  onPressed: onAdd,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Contenu de la liste (GridView, ListView…)
            SizedBox(
              height: 350, // ajuster selon le contenu
              child: listContent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 32,
                  color: const Color.fromARGB(255, 16, 16, 16),
                  secondRingColor: Colors.indigo,
                  thirdRingColor: Colors.pink.shade400),
            ),
          ) :
    Scaffold(
      appBar: AppBar(
      centerTitle: true,
              title: const Text(
                "Dashboard",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Chauffeurs
            _buildSection(
              title: "Chauffeurs",
              onAdd: () => Get.to(() => const AjouetrChauffeur()),
              listContent: const ListChaffeurs(), // votre widget existant
            ),

            // Section Responsables
            _buildSection(
              title: "Responsables",
              onAdd: () => Get.to(() => const AddResponsable()),
              listContent: const ListRresponsable(),
            ),

            // Section Mécaniciens
            _buildSection(
              title: "Mécaniciens",
              onAdd: () => Get.to(() => const AddMecanicien()),
              listContent: const ListMecanicien(),
            ),
          ],
        ),
      ),
    );
  }
}
