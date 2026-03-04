import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel()..startLoading(context),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );


    _controller.repeat(reverse: true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SplashViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, 0),
            end: Alignment(1, 1),
            colors: [
              Color(0xFFECFCFF),
              Color(0xFF9EEEFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Animated Logo
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final double bounce = 10 * (1 - (_controller.value - 0.5).abs() * 2);
                  final double scale = 0.98 + 0.04 * (_controller.value);

                  return Transform.translate(
                    offset: Offset(0, -bounce),
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                      ),
                    );
                  },
                child: Image.asset(
                  'assets/images/read_quest_logo_splash.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),

              const SizedBox(height: 30),

              // Bottom Loading Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF282828),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: viewModel.progress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDC700),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}