import 'package:flutter/material.dart';
import 'package:doinikcakri/widgets/text_widget.dart';
//import 'package:google_sign_in/google_sign_in.dart';



class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleAccount = await googleSignIn.signIn();
  //   if (googleAccount != null) {
  //     final googleAuth = await googleAccount.authentication;
  //     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //       try {
  //         final authResult = await authInstance.signInWithCredential(
  //           GoogleAuthProvider.credential(
  //               idToken: googleAuth.idToken,
  //               accessToken: googleAuth.accessToken),
  //         );

  //         if (authResult.additionalUserInfo!.isNewUser) {
  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(authResult.user!.uid)
  //               .set({
  //             'id': authResult.user!.uid,
  //             'name': authResult.user!.displayName,
  //             'email': authResult.user!.email,
  //             'shipping-address': '',
  //             'userWish': [],
  //             'userCart': [],
  //             'createdAt': Timestamp.now(),
  //           });
  //         }
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(
  //             builder: (context) => const FetchScreen(),
  //           ),
  //         );
  //       } on FirebaseException catch (error) {
  //         GlobalMethods.errorDialog(
  //             subtitle: '${error.message}', context: context);
  //       } catch (error) {
  //         GlobalMethods.errorDialog(subtitle: '$error', context: context);
  //       } finally {}
  //     }
  //   }
   }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/google.png',
              width: 40.0,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          TextWidget(
              text: 'Sign in with google', color: Colors.white, textSize: 18)
        ]),
      ),
    );
  }
}
