import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x000f0f0f),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 120),
              Center(
                child: SvgPicture.asset(AppAssets.KCollegeX),
              ),

              const SizedBox(height: 80),
              AuthField(
                controller: _emailController,
                hintText: 'Email',
              ),
              const SizedBox(height: 30),
              AuthField(
                controller: _passwordController,
                hintText: 'Password',
              ),
              const SizedBox(height: 15,),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(color: Colors.blue,
                  onPressed: () {},
                  text: 'Forget Password?',
                ),
              ),
              const SizedBox(height: 15),
              ShakeWidget(
                key: _shakeKey,
                shakeOffset: 10.0,
                shakeDuration: const Duration(milliseconds: 500),
                child: PrimaryButton(
                  onTap: () {
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                    } else {
                      _shakeKey.currentState?.shake();
                    }
                  },
                  text: 'Login',color: Colors.white,
                  height: 50,
                  borderRadius: 20,
                  width: 305,
                ),
              ),
              const SizedBox(height: 20),
              const DividerWithText(),
              const SizedBox(height: 20),
              CustomSocialButtonBlack(color: Colors.lightBlue[400],
                onTap: () {},
                icon: AppAssets.kFaceBook,
                text: 'Sign in with Facebook',
                margin: 0,
                icons: const FaIcon(FontAwesomeIcons.facebook,color: Colors.blue,),
              ),
              const SizedBox(height: 20),
              CustomSocialButtonBlack(color: Colors.grey[900],
                onTap: () {},
                icon: AppAssets.kGoogle,
                text: 'Sign in with Google',
                margin: 0,
              ),
              const SizedBox(height: 20),
              CustomSocialButton(
                onTap: () {},
                icon: AppAssets.KApple,
                text: 'Sign in with Apple',
                margin: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppAssets {
  static String kFaceBook = "assets/icons/facebook.svg";
  static String kGoogle = "assets/icons/google.svg";
  static String KCollegeX = "assets/icons/collegex.svg";
  static String KApple = "assets/icons/Group.svg";
}

class CustomSocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String icon;
  final FaIcon? icons;
  final double? margin;
  final Color? color;
  const CustomSocialButton({
    required this.onTap,
    required this.text,
    required this.icon,
    this.margin,
    this.icons,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: PrimaryContainer(width: 305,color:color ,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const Spacer(),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CustomSocialButtonBlack extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String icon;
  final FaIcon? icons;
  final double? margin;
  final Color? color;
  const CustomSocialButtonBlack({
    required this.onTap,
    required this.text,
    required this.icon,
    this.margin,
    this.icons,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: PrimaryContainer(width: 305,color:color ,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const Spacer(),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const AnimatedButton({required this.child, required this.onTap, super.key});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.white,),
          ),
          SizedBox(width: 15),
          Text(
            'or',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Divider(color: Colors.white,),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? color;
  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.fontSize,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          height: widget.height ?? 60,
          alignment: Alignment.center,
          width: widget.width ?? double.maxFinite,
          decoration: BoxDecoration(
            color: widget.color ?? const Color(0xFF329494),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF329494).withOpacity(0.2),
                blurRadius: 7,
                offset: const Offset(0, 5),
              )
            ],
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? 10,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.color == null ? Colors.white : Colors.black,
              fontSize: widget.fontSize ?? 20,
            ),
          ),
        ),
      ),
    );
  }
}

abstract class ShakeAnimation<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  ShakeAnimation(this.animationDuration);
  final Duration animationDuration;
  late final animationController =
  AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    required this.child,
    required this.shakeOffset,
    Key? key,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  // ignore: no_logic_in_create_state
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends ShakeAnimation<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue =
        sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.color,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(decoration: TextDecoration.underline,
            color: color ?? const Color(0xFF329494),
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  final Color? color;
  const AuthField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      height: 50,
      width: 305,
      child: TextFormField(textAlign: TextAlign.center,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          hintStyle: const TextStyle(color: Colors.grey,),
          filled: true,
          fillColor: Colors.black,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid,color: Colors.white60),borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid,color: Colors.cyanAccent),borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          border:  const OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid,color: Colors.cyanAccent),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;

  const PrimaryContainer({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF329494).withOpacity(0.2),
            blurRadius: 7,
            offset: const Offset(0, 5),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}