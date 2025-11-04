import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stoplight_app/features/report/reports_history_page.dart';
import 'package:stoplight_app/core/services/supabase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _busy = false;

  User? get _user => Supa.client.auth.currentUser;

  Future<void> _signIn(OAuthProvider provider) async {
    setState(() => _busy = true);
    try {
      // Must match what you set in Supabase Dashboard → Auth → URL config
      const redirectUri = 'io.stoplight.app://auth-callback';

      await Supa.client.auth.signInWithOAuth(
        provider,
        redirectTo: redirectUri,
        authScreenLaunchMode: LaunchMode.externalApplication,
        // optional:
        queryParams: {
          if (provider == OAuthProvider.google) 'prompt': 'select_account',
        },
      );
      // Supabase will complete the session after redirect.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign-in error: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    try {
      await Supa.client.auth.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign-out error: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = _user;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                      const Color(0xFF0D47A1).withValues(alpha: .1),
                      backgroundImage:
                      (u?.userMetadata?['avatar_url'] as String?) != null
                          ? NetworkImage(
                          u!.userMetadata!['avatar_url'] as String)
                          : null,
                      child: (u?.userMetadata?['avatar_url'] as String?) == null
                          ? const Icon(Icons.person,
                          size: 28, color: Color(0xFF0D47A1))
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u != null
                                ? (u.userMetadata?['full_name'] as String? ??
                                u.email ??
                                'User')
                                : 'Guest',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            u?.email ?? 'Not signed in',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (u == null) ...[
              _OauthButton(
                icon: Icons.g_mobiledata_rounded, // placeholder
                label: 'Continue with Google',
                onTap: () => _signIn(OAuthProvider.google),
              ),
              const SizedBox(height: 12),
              _OauthButton(
                icon: Icons.facebook_outlined,
                label: 'Continue with Facebook',
                onTap: () => _signIn(OAuthProvider.facebook),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign in to sync your reports across devices.',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('My Reports'),
                subtitle: const Text('View your saved AI reports'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ReportsHistoryPage()),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: _signOut,
              ),
            ],
          ],
        ),

        if (_busy)
          Container(
            color: Colors.black.withValues(alpha: 0.25),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
      ],
    );
  }
}

class _OauthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OauthButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D47A1),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE3E8F1))),
        ),
        onPressed: onTap,
      ),
    );
  }
}
