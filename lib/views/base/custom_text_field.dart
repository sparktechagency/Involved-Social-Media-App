import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacter;
  final Color? fillColor;
  final Color? borderColor;
  final int? maxLines;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final VoidCallback? onTap;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscureCharacter = '*',
    this.fillColor,
    this.onChanged,
    this.borderColor,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onTap,
    this.labelText,
    this.hintText,
    this.isPassword = false,
    this.readOnly = false,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.isEmail,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: widget.contentPaddingHorizontal ?? 12.w,
        vertical: widget.contentPaddingVertical ?? 16.w,
      ),
      filled: true,
      fillColor: widget.fillColor ?? AppColors.fillColor,
      prefixIcon: widget.prefixIcon != null
          ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: widget.prefixIcon,
      )
          : null,
      suffixIcon: widget.isPassword
          ? GestureDetector(
        onTap: _toggleObscureText,
        child: _buildSuffixIcon(
            _obscureText ? AppIcons.eyeOffIcon : AppIcons.eyeIcon),
      )
          : widget.suffixIcon != null
          ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: widget.suffixIcon,
      )
          : null,
      labelText: widget.labelText,
      labelStyle: TextStyle(color: AppColors.textColor, fontFamily: 'Satoshi'),
      hintText: widget.hintText,
      hintStyle: TextStyle(color: AppColors.hintColor, fontFamily: 'Satoshi'),
      errorStyle: const TextStyle(color: Colors.red),
      border: _buildBorder(),
      errorBorder: _buildBorder(),
      focusedBorder: _buildBorder(),
      enabledBorder: _buildBorder(),
      disabledBorder: _buildBorder(),
    );
  }

  OutlineInputBorder _buildBorder([Color? borderColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        width: 1.w,
        color: borderColor ?? widget.borderColor ?? AppColors.primaryColor,
      ),
    );
  }

  Widget _buildSuffixIcon(String icon) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: SvgPicture.asset(
        icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      obscuringCharacter: widget.obscureCharacter!,
      validator: widget.validator,
      cursorColor: AppColors.primaryColor,
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(),
    );
  }
}

