import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_test/supabase_provider.dart';


class AppLoader extends StatefulWidget {
  final Widget? child;

  const AppLoader({
    super.key,
    this.child,
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with TickerProviderStateMixin {
  late SupaBaseProvider _supaBaseProvider;
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool showLoading = false;


  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic));
    _supaBaseProvider = Provider.of<SupaBaseProvider>(context, listen: false);
    _supaBaseProvider.addListener(() => onLoadingStateChanged(_supaBaseProvider.isLoading));
    super.initState();
  }

  void onLoadingStateChanged(bool value) {
    if (mounted) {
      if (value && !_animationController.isAnimating) {
        setState(() {
          showLoading = true;
        });
        _animationController.forward();
      } else {
        _animationController.reverse().then((value) => setState(() => showLoading = false));
      }
    }
  }

 

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child ?? const SizedBox()),
        if (showLoading)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: _animation.value * 2, sigmaY: _animation.value * 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha((_animation.value * 40).toInt()),
                      ),
                      child: Center(
                        child: FadeTransition(
                          opacity: _animation,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
      ],
    );
  }
}