import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:belaaraby/Home/homeView.dart';
import 'package:belaaraby/auth/login_screen.dart';
import 'package:belaaraby/myPacks/myVoids.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  BrUser cUser = BrUser();
  late Worker worker;
  @override
  void onInit() {
    print('## onInit AuthController');
  }
  @override
  void dispose() {
    super.dispose();
  }
  // @override
  // void onReady() {
  //   super.onReady();
  //   // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
  //   // Since we have to use that many times I just made a constant file and declared there
  //
  //   fetchUser();
  // }

deleteUserFromAuth(email,pwd) async {
    //auth user to delete
  await auth.signInWithEmailAndPassword(
    email: email,
    password: pwd,
  ).then((value) async {
    print('## account: <${authCurrUser!.email}> deleted');
    //delete user
    authCurrUser!.delete();
    //signIn with admin
    await auth.signInWithEmailAndPassword(
      email: cUser.email!,
      password: cUser.pwd!,
    );
    print('## admin: <${authCurrUser!.email}> reSigned in');

  });




}

  void fetchUser() {
    print('## AuthController fetchUser ...');

    firebaseUser = Rx<User?>(auth.currentUser);

   firebaseUser.bindStream(auth.userChanges());
    worker = ever(firebaseUser, _setInitialScreen);

  }

  _setInitialScreen(User? user,) async {
    worker.dispose();

    if (user == null) {
      print('## no user Found');
      Get.offAll(() => LoginScreen());

      return;


    } else {
      print('## User is currently signed in >> ${user.email!}');
      await getUserInfoVoid(user.email).then((value) {

        if (cUser.verified) {
          print('## <saved_email> verified');
          goToHomePage();
        }
        // if email not verified
        else {
          print('## <saved_email> NOT verified');
          Get.offAll(()=>LoginScreen());
        }
      });
    }

  }

  checkUserVerif(ctx) {
    if (cUser.verified) {
      print('## <entered_email> verified');
      goToHomePage();
    }
    else {
      print('## <entered_email> NOT verified');
      MyVoids().shouldVerify(ctx);

    }
  }


  login(String _email, String _password, ctx, {Function()? onSignIn}) async {
    try {
      //try signIn to auth
      await auth
          .signInWithEmailAndPassword(
        email: _email,
        password: _password,
      )
          .then((value) async {
        //account found
        onSignIn!();
      });

      // signIn error
    } on FirebaseAuthException catch (e) {
      print('## error signIn => ${e.message}');
      if (e.code == 'user-not-found') {
        MyVoids().showTos('User not found'.tr);
        print('## user not found');
      } else if (e.code == 'wrong-password') {
        MyVoids().showTos('Wrong password'.tr);
        print('## wrong password');
      }
    } catch (e) {
      print('## catch err in signIn user_auth: $e');
    }
  }

  signup(String _email, String _password, ctx, {Function()? onSignUp}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      )
          .then((value) {
        onSignUp!();
      });
    } on FirebaseAuthException catch (e) {
      print('## error signUp => ${e.message}');

      if (e.code == 'weak-password') {
        MyVoids().showTos('Weak password'.tr);
        print('## weak password.');
      } else if (e.code == 'email-already-in-use') {
        MyVoids().showTos('Email already in use'.tr);
        print('## email already in use');
      }
    } catch (e) {
      print('catch err in signUp user_auth: $e');
    }
  }

  Future<void> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print('registered as anony');
    } on FirebaseAuthException catch (e) {
      //MyVoids().showTos('Error while signInAnonymously: $e');

      switch (e.code) {
        case "operation-not-allowed":
          print("## Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("##<signInAnonymously> Unknown error.");
      }
    }
  }

  anonyLogin() async {
    await signInAnonymously();
    //MyVoids().showTos('Welcome'.tr);
    goToHomePage();
  }

  void ResetPss(String email, ctx) async {
    try {
      await auth.sendPasswordResetEmail(email: email).then((uid) {
        MyVoids().showTos('la réinitialisation du mot de passe a été envoyée à votre boîte aux lettres');
        Get.back();
      }).catchError((e) {
        print('catchError while ResetPss => $e');
      });
    } on FirebaseAuthException catch (e) {
      MyVoids().showTos('Error' + e.message.toString());
      print('### Error sending reset pass' + e.message.toString());
    }
  }


  void signOut() async {
    await auth.signOut();
    cUser = BrUser();
    print('## user signed out');
  }

  // send verif code screen
  Future<void> checkEmailVerified(timer) async {
    //user = authCurrUser!;
    await authCurrUser!.reload();
    if (authCurrUser!.emailVerified) {

      await usersColl.where('email', isEqualTo: authCurrUser!.email).get().then((event) {
        var userDoc = event.docs.single;
        String userID = userDoc.get('id');

        usersColl.doc(userID).update({
          'verified':true
        });


      });
      print('### account verified');
      timer.cancel();
      MyVoids().showTos('your account has been verified\nplease reconnect'.tr);
      Get.offAll(()=>LoginScreen());
    }
  }

  refreshCuser() async {
    getUserInfoVoid(authCtr.cUser.email);
  }

  Future<void> getUserInfoVoid(userEmail) async {
    await usersColl.where('email', isEqualTo: userEmail).get().then((event) {
      var userDoc = event.docs.single;
      print('## getiing <$userEmail> from cloud ...');
      cUser = BrUserFromMap(userDoc);
      printUser(cUser);

    }).catchError((e) => print("## cant find user in cloud: $e"));


  }
}
