import 'package:flutter/material.dart';
import 'package:movecity/app_routes.dart';
import 'package:movecity/core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _mostrarSenha = false;
  bool _loadingGoogle = false;

  final Color brandGreen = const Color(0xFF1D9E75);


  @override
  void dispose() { 
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }


  Future<void> _fazerLogin() async { 
    
    if (_emailController.text.trim().isEmpty || _senhaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }


   
    final emailRegex = RegExp(r'^[\w.-]+@souunit\.com\.br$'); 
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Somente contas @souunit.com.br podem acessar o sistema.')),
      );
      return;
    }


    setState(() => _isLoading = true);


    try {
      await AuthService().login(
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
        } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString())),
      
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
                    Text(
                      'MOVE CITY',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold, color: brandGreen),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    _buildTextField(controller: _emailController, hint: 'E-mail'),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _senhaController,
                        hint: 'Senha',
                        obscure: !_mostrarSenha,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _fazerLogin,
                      style: ElevatedButton.styleFrom(backgroundColor: brandGreen, elevation: 10, shadowColor: Colors.black.withOpacity(0.07), padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 15)),
                    ),

                    const SizedBox(height: 16),

                 OutlinedButton(
                  onPressed: _loadingGoogle ? null : () async {
                        setState(() {
                          _loadingGoogle = true;
                        });

                        try {
                          final user = await AuthService().loginComGoogle();

                          if (user != null && mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.home);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _loadingGoogle = false;
                            });
                          }
                        }
                      },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: brandGreen,
                      width: 2,
                    ),
                  ),
                  child: _loadingGoogle
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Login com Google',
                            style: TextStyle(
                              color: brandGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                ),
                    const SizedBox(height: 16),
                    GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.forgotPassword,
                        ),

                     

                          child: Text(
                            'Esqueceu a senha?',
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                               fontSize: 16,
                            ),
                          ),
                        ),
                      
                    SizedBox(height: screenHeight * 0.20),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.registration),
                      child: const Padding(padding: EdgeInsets.only(bottom: 24.0), child: Text('Cadastrar-se', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 16,))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField({required TextEditingController controller, required String hint, bool obscure = false, Widget? suffixIcon,}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)]),
      child: TextField(controller: controller, obscureText: obscure, decoration: InputDecoration(hintText: hint,    hintStyle: const TextStyle(fontWeight:FontWeight.normal,
       fontSize: 14, color: Color(0xFF80807E),),                 
      contentPadding: const EdgeInsets.all(22), border: InputBorder.none, suffixIcon: suffixIcon)),
    );
  }
}
