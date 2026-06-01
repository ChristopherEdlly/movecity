import 'package:flutter/material.dart';
import 'package:movecity/app_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _paginaAtual = 0;
  final _emailController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _isLoading = false;


  final Color brandGreen = const Color(0xFF1D9E75);


  Future<void> _proximaEtapa() async {
    
    if (_paginaAtual == 0) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (_emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, informe seu e-mail.')));
        return;
      }
      if (!emailRegex.hasMatch(_emailController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, insira um e-mail válido.')));
        return;
      }
    }


    
    if (_paginaAtual == 2) {
      if (_novaSenhaController.text.trim().isEmpty || _confirmarSenhaController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos.')));
        return;
      }
      if (_novaSenhaController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres.')));
        return;
      }
      if (_novaSenhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas não coincidem.')));
        return;
      }
    }


    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
   
    if (mounted) {
      setState(() {
        _isLoading = false;
        _paginaAtual++;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F2),
      body: SafeArea(
        child: CustomScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _paginaAtual == 0
                          ? TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                '‹ Voltar',
                                style: TextStyle(
                                  color: Color(0xFF1D9E75),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),

                     Text('MOVE CITY', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color(0xFF1D9E75))),
                    _buildConteudo(),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildConteudo() {
    switch (_paginaAtual) {
      case 0:

        return Column(
          
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          const Text('Informe seu e-mail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
          const SizedBox(height: 16),
          _buildTextField(controller: _emailController, hint: 'E-mail'),
          const SizedBox(height: 16),
          _buildBotao('Avançar', _proximaEtapa),
        ]);
      case 1:
        return Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          const Text('Enviamos o link de redefinição de senha para o seu e-mail. Confira sua caixa de entrada.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
          ),
          _buildBotao('Acessar e-mail', () => setState(() => _paginaAtual++)),
        ]);
      case 2:
        return Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          _buildTextField(controller: _novaSenhaController, hint: 'Digite a nova senha', obscure: true),
          const SizedBox(height: 16),
          _buildTextField(controller: _confirmarSenhaController, hint: 'Confirme a nova senha', obscure: true),
          const SizedBox(height: 16),
          _buildBotao('Redefinir senha', _proximaEtapa),
        ]);
      case 3:
      default:
        return Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          const Text('Senha atualizada! Agora é só fazer login com sua nova senha.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
          _buildBotao('Fazer login', () => Navigator.pop(context)),
        ]);
    }
  }
 
  
  Widget _buildTextField({required TextEditingController controller, required String hint, bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 2))]),
      child: TextField(controller: controller, obscureText: obscure, decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontWeight:FontWeight.normal,
       fontSize: 14, color: Color(0xFF80807E),), contentPadding: const EdgeInsets.all(22), border: InputBorder.none)),
    );
  }


  Widget _buildBotao(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: brandGreen, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(texto, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
