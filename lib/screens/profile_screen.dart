import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/AppBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? avatarUrl;
  bool loadingAvatar = false;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        user = userCredential.user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка входа: $e")),
      );
    }
  }

  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null || user == null) return;

    setState(() => loadingAvatar = true);

    final file = File(picked.path);
    final ref = FirebaseStorage.instance.ref().child('avatars/${user!.uid}.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    setState(() {
      avatarUrl = url;
      loadingAvatar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(title: "Профиль", showBackButton: false),
        body: Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Войти через Google'),
            onPressed: signInWithGoogle,
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE14E31), fixedSize: const Size(350, 50), shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
           ),
          ),
        ),
      );
    }

    return Scaffold(

      appBar: CustomAppBar(title: "Профиль", showBackButton: false),
      body: Center(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickAndUploadAvatar,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : (user!.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null),
                    child: avatarUrl == null && user!.photoURL == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  if (loadingAvatar)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user!.displayName ?? "Имя не указано",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              user!.email ?? "",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  user = null;
                  avatarUrl = null;
                });
              },
              icon: const Icon(Icons.logout, color: Colors.white,),
              label: const Text(
                  "Выйти",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE14E31), fixedSize: const Size(280, 50), shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                    ),
            )
          ],
        ),
      ),
      ),
    );
  }
}
