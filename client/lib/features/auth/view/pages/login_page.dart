import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authViewModelProvider.select((val) => val?.isLoading)) ==
            true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          print("Data");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (_) => false);
        },
        error: (error, stackTrace) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomField(
                      controller: emailController,
                      hintText: "Email",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomField(
                      controller: passwordController,
                      isPassword: true,
                      hintText: "Password",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      label: "Sign In",
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          ref.read(authViewModelProvider.notifier).loginUser(
                              email: emailController.text,
                              password: passwordController.text);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ));
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: const [
                            TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                    color: Pallete.gradient2,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
