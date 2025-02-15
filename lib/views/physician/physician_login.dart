import 'package:flutter/material.dart';
import 'package:pallinet/constants.dart';
import 'package:pallinet/utils.dart';

import 'package:pallinet/firestore/auth.dart';

class PhysicianLogin extends StatelessWidget {
  const PhysicianLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Center(
            child: SingleChildScrollView(
      child: Column(
        children: const [
          _Logo(),
          _FormContent(),
        ],
      ),
    )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  Widget gap() => const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Physician Login",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.black),
          ),
        ),
        gap(),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<_FormContent> {
  bool isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) => emailValidation(value),
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              onSaved: (newValue) => email = newValue,
            ),
            gap(),
            TextFormField(
              validator: (value) => requiredValue(value),
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )),
              onSaved: (newValue) => password = newValue,
            ),
            gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState?.validate() ?? false) {
                    _attemptLogin({
                      "email": email,
                      "password": password,
                      "userType": UserType.practitioner,
                    }, context);
                  }
                },
              ),
            ),
            gap(),
            SizedBox(
              // DEBUGGING LOGIN
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'DEBUGGING LOGIN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  _debugLogin(context);
                },
              ),
            ),
            InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child:
                      Text('Forgot Password?', style: TextStyle(fontSize: 14)),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/forgotpassword");
                })
          ],
        ),
      ),
    );
  }

  Widget gap() => const SizedBox(height: 16);
}

_attemptLogin(payload, context) {
  signIn(payload).then((status) => {
        if (status == AuthStatus.success)
          {Navigator.pushNamed(context, "/physician/home")}
        else
          {_showSnackbar(context, status)}
      });
}

_debugLogin(context) {
  debugPhysician()
      .then((val) => {Navigator.pushNamed(context, "/physician/home")});
}

_showSnackbar(BuildContext context, AuthStatus status) {
  final snackBar = status == AuthStatus.success
      ? SnackBar(
          content: Text(status.value),
        )
      : SnackBar(
          content: Text(status.value),
          backgroundColor: Colors.red,
        );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
