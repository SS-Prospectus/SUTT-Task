import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sutt_task_final/utils/showSnackbar.dart';
import 'package:sutt_task_final/utils/showOtpDialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sutt_task_final/services/userprovider.dart';



class FirebaseAuthMethods{
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  Future<void> setData(String name, UserProvider userProvider) async{
    userProvider.setLoggedIn('1');
    userProvider.setUsername(name);
}


  //EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await sendEmailVerification(context);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setData(name, userProvider);
      GoRouter.of(context).go('/home');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      else{
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        setData(name, userProvider);
        GoRouter.of(context).go('/home');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // PHONE SIGN IN
  Future<void> phoneSignIn(
      String name,
      BuildContext context,
      String phoneNumber,
      ) async {
    TextEditingController codeController = TextEditingController();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );
              await _auth.signInWithCredential(credential);
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              setData(name, userProvider);
              Navigator.of(context).pop();
              GoRouter.of(context).go('/home');// Remove the dialog box
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
  }

  // GOOGLE SignIn
  Future<void> signInWithGoogle(BuildContext context) async {
    String name = '';
    try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential = await _auth.signInWithCredential(credential);

          name = userCredential.user!.displayName ?? '';

          final userProvider = Provider.of<UserProvider>(context, listen: false);
          setData(name, userProvider);
          GoRouter.of(context).go('/home');
        }
      }
    on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }
}