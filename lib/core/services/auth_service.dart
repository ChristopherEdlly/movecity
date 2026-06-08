import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<void> login(String email, String senha) async {
  try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } catch (e) {
      throw Exception(
        'Não foi possível realizar o login. Tente novamente.',
      );
    }

    final user = _auth.currentUser;

    if (user == null ||
        !user.email!.toLowerCase().endsWith('@souunit.com.br')) {
      await _auth.signOut();

      throw Exception(
        'Somente contas @souunit.com.br podem acessar o sistema.',
      );
    }
  }



  Future<void> cadastrar(String email, String senha) async {
    try{
        if (!email.toLowerCase().endsWith('@souunit.com.br')) {
          throw Exception(
            'Utilize um e-mail institucional @souunit.com.br',
          );
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
        throw Exception('Não foi possível realizar o cadastro. Tente novamente.');
      }
    }

  
  Future<void> enviarEmailRedefinicao(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      throw Exception(
        'Não foi possível enviar o e-mail de recuperação. Tente novamente.',
      );
    }
  }
}