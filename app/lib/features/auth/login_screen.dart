import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/aura_scaffold.dart';
import '../../components/glass_surface.dart';
import '../../components/pressable_scale.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/network/api_exception.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: _email.text, password: _password.text);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException
            ? (error.isUnauthorized
                  ? context.l10n.invalidCredentials
                  : error.userMessage)
            : context.l10n.connectionError;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return AuraScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AuraSpace.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AuraSpace.xxl),
                  Center(child: _Logo(colors: colors)),
                  const SizedBox(height: AuraSpace.xl),
                  Text(
                    context.l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: AuraType.largeTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AuraSpace.xs),
                  Text(
                    context.l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: AuraType.callout.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AuraSpace.xxl),
                  GlassSurface(
                    borderRadius: BorderRadius.circular(AuraRadius.xl),
                    padding: const EdgeInsets.all(AuraSpace.md),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: context.l10n.email,
                              prefixIcon: const Icon(Icons.mail_outline_rounded),
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (!email.contains('@') || email.length < 5) {
                                return context.l10n.email;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AuraSpace.sm),
                          TextFormField(
                            controller: _password,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: context.l10n.password,
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 8) {
                                return context.l10n.password;
                              }
                              return null;
                            },
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: AuraSpace.sm),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 17,
                                  color: colors.danger,
                                ),
                                const SizedBox(width: AuraSpace.xs),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: AuraType.footnote.copyWith(
                                      color: colors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: AuraSpace.md),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _busy ? null : _submit,
                              child: _busy
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _busy
                                          ? context.l10n.signingIn
                                          : context.l10n.signIn,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AuraSpace.xl),
                  PressableScale(
                    onTap: () {},
                    child: Text(
                      'Aura · offline-first',
                      textAlign: TextAlign.center,
                      style: AuraType.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.colors});

  final AuraColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.accent, const Color(0xFF9B7CFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.4),
            blurRadius: 36,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        Icons.graphic_eq_rounded,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
