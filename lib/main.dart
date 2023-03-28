import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/form_data_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Column(
          children: const [
            Logo(),
            SignInForm(),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width * 0.6;
    final imageHeight = MediaQuery.of(context).size.height * 0.2;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
          width: imageWidth,
          height: imageHeight,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/logo-placeholder.jpg')))),
    );
  }
}

final providerOfEmailText = StateProvider<String?>((ref) => '');
final providerOfPasswordText = StateProvider<String?>((ref) => '');
final providerOfPasswordVisibility = StateProvider<bool>((ref) => false);

class SignInForm extends ConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  const EmailField(),
                  const PasswordField(),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    return ElevatedButton(
                        onPressed: () {
                          if (!Form.of(context).validate()) {
                            return;
                          }
                          Form.of(context).save();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const FormDataPage()));
                        },
                        child: const Text('Sign In'));
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailField extends ConsumerWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.blue),
        suffixIcon: Icon(Icons.email_outlined),
        suffixIconColor: Colors.blue,
      ),
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: Colors.blueGrey),
      initialValue: '',
      onSaved: (String? val) =>
          ref.read(providerOfEmailText.notifier).state = val,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your email.';
        }
        if (val.length > 25) {
          return '25 characters max.';
        }
        if (!val.contains('@')) {
          return 'Invalid email.';
        }
        return null;
      },
    );
  }
}

class PasswordField extends ConsumerWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passVisibility = ref.watch(providerOfPasswordVisibility);

    return TextFormField(
      obscureText: !passVisibility,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.blue),
        suffixIcon: GestureDetector(
            onTap: () => ref.read(providerOfPasswordVisibility.notifier).state =
                !passVisibility,
            child: Icon(passVisibility
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined)),
        suffixIconColor: Colors.blue,
      ),
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.blueGrey),
      initialValue: '',
      onSaved: (String? val) =>
          ref.read(providerOfPasswordText.notifier).state = val,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your password.';
        }
        return null;
      },
    );
  }
}
