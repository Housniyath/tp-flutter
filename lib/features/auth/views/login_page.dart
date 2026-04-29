import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../routes/app_routes.dart';
import '../../../core/Theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // TODO (Membre Auth) : brancher Firebase ici
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        AppRoutes.goToAndClearStack(context, AppRoutes.habits);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // ── Logo + Titre app ──────────────────────────────
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.track_changes_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Habit Tracker',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Construis de meilleures habitudes',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ── Titre section ─────────────────────────────────
              const Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Bon retour ! Reprenez vos habitudes.',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 36),

              AppTextField(
                label:        'Email',
                hint:         'exemple@mail.com',
                controller:   _emailController,
                prefixIcon:   Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label:       'Mot de passe',
                hint:        '••••••••',
                controller:  _passwordController,
                prefixIcon:  Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 32),

              AppButton(
                label:     'Se connecter',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 12),
              AppButton(
                label:     "Créer un compte",
                variant:   AppButtonVariant.outline,
                onPressed: () => AppRoutes.goTo(context, AppRoutes.register),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}