// ignore_for_file: unused_local_variable, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter_application_mobile_camion/Screens/home.dart";
import 'package:flutter_application_mobile_camion/loginScreens/registartiontextfield.dart';
import 'package:flutter_application_mobile_camion/loginScreens/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/screens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../shared/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isLoading = false;

  login() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Screens()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'utilisateur non trouvé!',
        );
      } else if (e.code == 'wrong-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'mot de passe incorrect!',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Vérifiez votre e-mail ou votre mot de passe!',
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Parc GMAO',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Form(
          key: formstate,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'Asset/images/truck.svg',
                    height: 120.0,
                    width: 120.0,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Text(
                      "Connecter",
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Text("Accédez à votre espace personnel en toute sécurité.",
                          style: TextStyle(color: Colors.black)),
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
                        : "Entrer un email valide";
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Vérifier le mot de passe" : null;
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
                        color: greyColor,
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
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Mot de passe oublie?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            await login();
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Erreur',
                              text: 'Entrez votre e-mail et votre mot de passe',
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
                                "Connecter",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Vous n'avez pas de compte?",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.off(() => const RegisterPage(),
                            transition: Transition.downToUp);
                      },
                      child: const Text(
                        "S'enregistrer",
                        style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ))
                ]), 
                const  Gap(50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
