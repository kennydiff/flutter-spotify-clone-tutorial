import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
    final String hintText;
    final TextEditingController? controller;
    final bool isObscureText;
    final bool readOnly;
    final VoidCallback? onTap;
    const CustomField({
        super.key,
        // K_24920 required 关键字表示这些参数是必需的，调用构造函数时必须提供它们的值
        required this.hintText,
        required this.controller,
        this.isObscureText = false,
        this.readOnly = false,
        this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return TextFormField(
            onTap: onTap,
            readOnly: readOnly,
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
            ),
            validator: (val) {
                if (val!.trim().isEmpty) {
                    return "$hintText is missing!";
                }
                return null;
            },
            obscureText: isObscureText,
        );
    }
}
