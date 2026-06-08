import 'package:flutter/material.dart';
import 'package:movecity/core/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _paginaAtual = 0;
  final _emailController = TextEditingController();
 
  bool _isLoading = false;


  final Color brandGreen = const Color(0xFF1D9E75);


  Future<void> _proximaEtapa() async {
    
    if (_paginaAtual == 0) {
      final emailRegex = RegExp(r'^[\w.-]+@souunit\.com\.br$'); 
      if (_emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, informe seu e-mail.')));
        return;
      }
      if (!emailRegex.hasMatch(_emailController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Somente contas @souunit.com.br podem acessar o sistema.')));
        return;
      }
    }


    
   


    setState(() => _isLoading = true);
        try {
          
          await AuthService().enviarEmailRedefinicao(
            _emailController.text.trim(),
          );

          if (mounted) {
            setState(() {
              _paginaAtual++;
            });
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceFirst('Exception: ', ''),
              ),
            ),
          );

        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      }

      Future<void> _abrirEmail() async {
            final Uri emailUri = Uri(
              scheme: 'mailto',
            );

            if (await canLaunchUrl(emailUri)) {
              await launchUrl(emailUri);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Não foi possível abrir o aplicativo de e-mail.'),
                ),
              );
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
                              child:  Text(
                                '‹ Voltar',
                                style: TextStyle(
                                  color: brandGreen,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),

                     Text('MOVE CITY', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: brandGreen)),
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
          _buildBotao('Acessar e-mail', _abrirEmail),
        ]);
         default:
            return const SizedBox();
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
