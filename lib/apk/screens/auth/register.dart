//import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/customButton.dart';
import 'package:doinikcakri/widgets/customTextfield.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:doinikcakri/admin/screens/dashboard_screen.dart';
import 'package:doinikcakri/admin/screens/loading_manager.dart';
import 'package:doinikcakri/admin/services/global_method.dart';
import 'package:doinikcakri/apk/screens/auth/login.dart';
import 'package:get/get.dart';

import '../../../consts/firebase_consts.dart';
import '../../../widgets/auth_button.dart';
import '../../../widgets/text_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _mobileTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _mobileTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _mobileFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': _fullNameController.text,
          'phoneNumber': _mobileTextController.text,
          'email': _emailTextController.text.toLowerCase(),
          'shipping-address': _addressTextController.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>  DashboardScreen(),
        ));
        print('Succefully registered');
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
        child: Stack(
          children: <Widget>[
          
          
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 60.0,
                  ),
                  
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextWidget(
                    text: 'Welcome',
                    color: primaryColor,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "Sign up to continue",
                    color: primaryColor,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(labelText: 'Full name', controller: _fullNameController),
                        CustomTextField(labelText: 'Email', controller: _emailTextController),
                        CustomTextField(labelText: 'Address', controller: _addressTextController),
                        CustomTextField(labelText: 'Mobile Number', controller: _mobileTextController),
                        CustomTextField(labelText: 'Password', controller: _passTextController),
                       
                       SizedBox(height: 20,) 
          
                      ],
                    ),
                  ),
                  
                 CustomButton(onPressed: () {
                      _submitFormOnRegister();
                    }, title: 'Sign up')
                  ,
                 SizedBox(height: 20,) ,
                  RichText(
                    text: TextSpan(
                        text: 'Already a user?',
                        style:
                            const TextStyle(color: primaryColor, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Sign in',
                              style: const TextStyle(
                                  color: Colors.lightBlue, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                 Get.to(LoginScreen());
                                }),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
