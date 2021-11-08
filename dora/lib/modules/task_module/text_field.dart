import 'package:flutter/material.dart';

Widget textField(
    String? hint,
    TextEditingController controller,
    TextInputType type,
    Widget prefixIcon,
{
   bool? isTextObsecurd = false,
   Widget? sfixIcon,
    Function(String)? onSubmit,
    Function()? onTap,
    String? Function(String?)? validate,
   bool isClickable  = true,
}) => TextFormField(
   keyboardType: type,
   enabled: isClickable,
   controller: controller,
   validator: validate,
   onTap: onTap,
   onFieldSubmitted: onSubmit,
   obscureText: isTextObsecurd!,
   decoration:  InputDecoration(
      border: const OutlineInputBorder(),
      prefixIcon: prefixIcon,
      suffixIcon: sfixIcon,
      hintText: hint,
      ),
   );
