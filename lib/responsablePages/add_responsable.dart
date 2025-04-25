import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';

import '../loginScreens/login.dart';
import '../loginScreens/registartiontextfield.dart';
import '../shared/colors.dart';

class AddResponsable extends StatefulWidget {
  const AddResponsable({super.key});

  @override
  State<AddResponsable> createState() => _AddResponsableState();
}

class _AddResponsableState extends State<AddResponsable> {
    GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  addChauffeur() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        "nom": nomController.text,
        "prenom": prenomController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "role": "Responsable",
        "anniversaire": '',
        "phone": '',
        "uid": credential.user!.uid,
      });

      if (!mounted) return;
      afficherAlert(); // ➕ Affiche alert et déclenchera la déconnexion
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erreur...',
          text: 'Mot de passe trop faible!',
        );
      } else if (e.code == 'email-already-in-use') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erreur...',
          text: 'Cet utilisateur existe déjà!',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Erreur inattendue : $e',
      );
    }
  }

  afficherAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Responsable ajouté !',
      confirmBtnText: "OK",
      onConfirmBtnTap: () async {
        // Nettoyer les champs
        nomController.clear();
        prenomController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        Navigator.of(context).pop();

        // 🚪 Déconnexion après confirmation
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      },
    );

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Ajouter un Responsable",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19)),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Form(
          key: formstate,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(60),
                Center(
                  child: SvgPicture.asset(
                    'Asset/images/chauffeur.svg',
                    height: 110.0,
                    width: 110.0,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RegistrationTextField(
                        icon: CupertinoIcons.person,
                        text: "  Nom",
                        controller: nomController,
                        validator: (value) {
                          return value!.isEmpty ? "Entrez un nom valide" : null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RegistrationTextField(
                        icon: CupertinoIcons.person,
                        text: "Prenon",
                        controller: prenomController,
                        validator: (value) {
                          return value!.isEmpty
                              ? "Entrez un prenom valide"
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                RegistrationTextField(
                  icon: CupertinoIcons.mail,
                  text: "  Email",
                  controller: emailController,
                  validator: (email) {
                    return email!.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        ? null
                        : "Entrez un email valide";
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty
                        ? "Entrer au moins 6 caractères"
                        : null;
                  },
                  obscureText: isPasswordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: isPasswordVisible
                            ? const Icon(
                                CupertinoIcons.eye,
                                color: Colors.black,
                                size: 22,
                              )
                            : const Icon(
                                CupertinoIcons.eye_slash,
                                color: Colors.black,
                                size: 22,
                              )),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(
                        top: 2.0,
                        left: 3.0,
                      ),
                      child: Icon(
                        CupertinoIcons.lock_rotation_open,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    hintText: "Mot de passe",
                    hintStyle:
                        const TextStyle(color: Colors.black, fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty
                        ? "Entrer au moins 6 caractères"
                        : null;
                  },
                  obscureText: isPasswordVisible,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: isPasswordVisible
                            ? const Icon(
                                CupertinoIcons.eye,
                                color: Colors.black,
                                size: 22,
                              )
                            : const Icon(
                                CupertinoIcons.eye_slash,
                                color: Colors.black,
                                size: 22,
                              )),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(
                        top: 2.0,
                        left: 3.0,
                      ),
                      child: Icon(
                        CupertinoIcons.lock_rotation_open,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    hintText: "Confirmer mot de passe",
                    hintStyle:
                        const TextStyle(color: Colors.black, fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const Gap(50),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            await addChauffeur();
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Erreur',
                              text:
                                  'Ajoutez toutes les informations necessaires',
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(mainColor),
                          padding: isLoading
                              ? WidgetStateProperty.all(
                                  const EdgeInsets.all(10))
                              : WidgetStateProperty.all(
                                  const EdgeInsets.all(13)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                        ),
                        child: isLoading
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: whiteColor,
                                  size: 32,
                                ),
                              )
                            : const Text(
                                "Ajouter Un Responsable",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
                const Gap(30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}