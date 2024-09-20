import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
    const SignupPage({super.key});

    @override
    ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    @override
    void dispose() {
        nameController.dispose();
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final isLoading = ref.watch(authViewModelProvider.select((val) => val?.isLoading == true));

        ref.listen(
            authViewModelProvider,
            (_, next) {
                next?.when(
                    data: (data) {
                        showSnackBar(
                            context,
                            'Account created successfully! Please  login.',
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                            ),
                        );
                    },
                    error: (error, st) {
                        showSnackBar(context, error.toString());
                    },
                    loading: () {},
                );
            },
        );

        return Scaffold(
            appBar: AppBar(),
            body: isLoading
                ? const Loader()
                : Padding(
                        padding: const EdgeInsets.all(20.0),
                        // K_24919 child 单数，一个成员
                        child: Form(
                            key: formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // K_24920 `主轴对齐` 垂直方向居中
                                // K_24919 children 复数，多个成员
                                children: [
                                    const Text(
                                        '注册',
                                        style: TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    const SizedBox(height: 30),
                                    CustomField(
                                        hintText: '姓名',
                                        controller: nameController,
                                    ),
                                    const SizedBox(height: 15),
                                    CustomField(
                                        hintText: '邮箱',
                                        controller: emailController,
                                    ),
                                    const SizedBox(height: 15),
                                    CustomField(
                                        hintText: '密码',
                                        controller: passwordController,
                                        isObscureText: true,
                                    ),
                                    const SizedBox(height: 20),
                                    AuthGradientButton(
                                        buttonText: '注册',
                                        onTap: () async {
                                            if (formKey.currentState!.validate()) {
                                                await ref.read(authViewModelProvider.notifier).signUpUser(
                                                        name: nameController.text,
                                                        email: emailController.text,
                                                        password: passwordController.text,
                                                    );
                                            } else {
                                                showSnackBar(context, 'Missing fields!');
                                            }
                                        },
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const LoginPage(),
                                                ),
                                            );
                                        },
                                        child: RichText(
                                            text: TextSpan(
                                                // text: 'Already have an account? ',
                                                text: '已经有账号了?  ',
                                                style: Theme.of(context).textTheme.titleMedium,
                                                children: const [
                                                    TextSpan(
                                                        text: '登录',
                                                        style: TextStyle(
                                                            color: Pallete.gradient2,
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    )
                                ],
                            ),
                        ),
                    ),
        );
    }
}
