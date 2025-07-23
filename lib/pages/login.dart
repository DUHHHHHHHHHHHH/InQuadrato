import 'package:flutter/material.dart';
import 'inquadrato.dart';

class FakeLoginPage extends StatefulWidget {
  const FakeLoginPage({Key? key}) : super(key: key);

  @override
  State<FakeLoginPage> createState() => _FakeLoginPageState();
}

class _FakeLoginPageState extends State<FakeLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _saveCredentials = false;
  bool _loading = false;

  void _fakeLogin() async {
    setState(() {
      _loading = true;
    });

    // delay FALSO.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const VisualizzatorePage()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double desiredWidth = screenWidth * 0.33;

    final double maxWidth = 400.0;
    final double finalWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: finalWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Accedi',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  enabled: !_loading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  enabled: !_loading,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Salva credenziali'),
                  value: _saveCredentials,
                  onChanged: _loading
                      ? null
                      : (val) {
                          setState(() {
                            _saveCredentials = val ?? false;
                          });
                        },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _fakeLogin,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
