import 'package:flutter/material.dart';
import 'package:movecity/app_routes.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});


  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}


class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
 
  bool _isLoading = false;
  bool _cadastroConcluido = false;


  final Color brandGreen = const Color(0xFF1D9E75);


  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }


  Future<void> _realizarCadastro() async {


        
      if (_emailController.text.trim().isEmpty || _senhaController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos.')));
        return;
      }
     

      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas não coincidem.')));
        return;
      }


      
      if (_senhaController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres.')));
        return;
      }


      
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um e-mail válido.')),
      );
      return;
    }
    setState(() => _isLoading = true);


    try {
      
      await Future.delayed(const Duration(seconds: 2));


      
      setState(() {
        _cadastroConcluido = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível se cadastrar. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;


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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.25),
                    Text('MOVE CITY',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: Color(0xFF1D9E75))
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),


                    
                    if (_cadastroConcluido) ...[
                      SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                      const Text(
                        'Cadastro realizado com sucesso!\nBem-vindo ao Move City.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                        style: ElevatedButton.styleFrom(backgroundColor: brandGreen, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Começar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ] else ...[
                      _buildTextField(controller: _emailController, hint: 'E-mail'),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _senhaController, hint: 'Senha', obscure: true),
                      const SizedBox(height: 16),
                      _buildTextField(controller: _confirmarSenhaController, hint: 'Confirme a senha', obscure: true),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _realizarCadastro,
                        style: ElevatedButton.styleFrom(backgroundColor: brandGreen, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Cadastrar-se', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 15)),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('Login', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField({required TextEditingController controller, required String hint, bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)]),
      child: TextField(controller: controller, obscureText: obscure, decoration: InputDecoration(hintText: hint,  hintStyle: const TextStyle(fontWeight:FontWeight.normal,
       fontSize: 14, color: Color(0xFF80807E),), contentPadding: const EdgeInsets.all(22), border: InputBorder.none)),
    );
  }
}


  