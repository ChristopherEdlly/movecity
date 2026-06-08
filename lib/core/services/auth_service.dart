import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;



final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

Future<UserCredential?> loginComGoogle() async {
  try {
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final email = googleUser.email.toLowerCase();


    if (!email.endsWith('@souunit.com.br')) {
      await _googleSignIn.signOut();
      throw 'Somente contas @souunit.com.br podem acessar o sistema.';
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;

    if (user == null) {
      throw 'Erro ao obter usuário.';
    }

    final docRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid);

    final doc = await docRef.get();

   
    if (!doc.exists) {
      await docRef.set({
        'email': user.email,
        'criado_em': Timestamp.now(),
        'criado_por': user.email,
        'provider': 'google',
      });
    }

    return userCredential;
  } catch (e) {
     throw 'Não foi possível realizar o login com Google. Tente novamente.';
  }
}
  Future<void> login(String email, String senha) async {
  try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } catch (e) {
      throw 'Não foi possível realizar o login. Tente novamente.';
    }

    final user = _auth.currentUser;

    if (user == null ||
        !user.email!.toLowerCase().endsWith('@souunit.com.br')) {
      await _auth.signOut();

      throw 'Somente contas @souunit.com.br podem acessar o sistema.';
    }
  }



  Future<void> cadastrar(String email, String senha) async {
    try{
        if (!email.toLowerCase().endsWith('@souunit.com.br')) {
          throw 'Utilize um e-mail institucional @souunit.com.br';
        }

        final userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: senha,
        );

        await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'criado_em': Timestamp.now(),
        'criado_por': userCredential.user!.email,
      });}catch (e) {
          throw 'Não foi possível realizar o cadastro. Tente novamente.';
      }
    }

  
  Future<void> enviarEmailRedefinicao(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      throw  'Não foi possível enviar o e-mail de recuperação. Tente novamente.';
    }
  }
}