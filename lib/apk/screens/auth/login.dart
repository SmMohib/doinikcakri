//import 'package:card_swiper/card_swiper.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doinikcakri/admin/screens/loading_manager.dart';
import 'package:doinikcakri/admin/services/global_method.dart';
import 'package:doinikcakri/apk/bottomNev.dart';
import 'package:doinikcakri/apk/screens/auth/register.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:get/get.dart';
import '../../../widgets/customButton.dart';
import '../../../consts/firebase_consts.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
        );
        print('Succefully logged in');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        body: LoadingManager(
            isLoading: _isLoading,
            child: Stack(children: [
              SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              height: 120.0,
                            ),
                            Center(
                                child: Image.asset('assets/doinik cakri.png')),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    //email
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () =>
                                          FocusScope.of(context)
                                              .requestFocus(_passFocusNode),
                                      controller: _emailTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: const TextStyle(
                                          color: textsecondColor),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: textsecondColor,
                                          size: 20,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 8.0, top: 8.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: primaryColor),
                                          borderRadius:
                                              new BorderRadius.circular(25.7),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: primaryColor),
                                          borderRadius:
                                              new BorderRadius.circular(25.7),
                                        ),
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                            )),
                                        hintText: 'Email',
                                        hintStyle: const TextStyle(
                                            color: textsecondColor),
                                      ),
                                    ),
                                    //Password
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onEditingComplete: () {
                                        _submitFormOnLogin();
                                      },
                                      controller: _passTextController,
                                      focusNode: _passFocusNode,
                                      obscureText: _obscureText,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 7) {
                                          return 'Please enter a valid password';
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: const TextStyle(
                                          color: textsecondColor),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: textsecondColor,
                                          size: 20,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 8.0, top: 8.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: primaryColor),
                                          borderRadius:
                                              new BorderRadius.circular(25.7),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: primaryColor),
                                          borderRadius:
                                              new BorderRadius.circular(25.7),
                                        ),
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              // color: Colors.white,
                                            )),
                                        hintText: 'Password',
                                        hintStyle: const TextStyle(
                                            color: textsecondColor),
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CustomButton(
                                  title: 'Login',
                                  onPressed: () {
                                    _submitFormOnLogin();
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't Have Account?"),
                                TextButton(
                                    onPressed: () {
                                     
                                        Get.to(RegisterScreen());
                                    },
                                    child: const Text('Sign Up')),
                              ],
                            ),
                          ])))
            ])));
  }
}
