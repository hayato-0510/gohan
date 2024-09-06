import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestoreModel {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUserToFirestore(User user) async {
    final userDoc = _usersCollection.doc(user.uid);
    final userDocData = await userDoc.get();

    if (!userDocData.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final userDoc = await _usersCollection.doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> deleteUser(String uid) async {
    final userRef = _usersCollection.doc(uid);
    await userRef.delete();
  }

  Future<void> updateUser({
    required String uid,
    String? name,
    String? email,
    String? photoURL,
  }) async {
    final userRef = _usersCollection.doc(uid);
    await userRef.update({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (photoURL != null) 'photoURL': photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(data);
    } catch (e) {
      print('Firestoreユーザープロフィール更新エラー: $e');
      rethrow;
    }
  }
}
