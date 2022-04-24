import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isAlreadyAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signOutGoogleUser() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    final _googleUser = await _googleSignIn.signIn();
    final _googleAuth = await _googleUser!.authentication;

    print("user:${_googleUser.email}");
    print("user:${_googleUser.displayName}");
    print("user:${_googleUser.photoUrl}");

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );

    //firebase sign in
    final authResult = await _auth.signInWithCredential(credential);

    //extract token
    User user = authResult.user!;
    final firebaseToken = await user.getIdToken();
    print("user fcm token:${firebaseToken}");

    await _createUserCollectionFirebase(_auth.currentUser!.uid);
  }

  Future<void> _createUserCollectionFirebase(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'uid': uid, 'user-favourites': []});
    } else {
      print('user already exists');
      return;
    }
  }
}
