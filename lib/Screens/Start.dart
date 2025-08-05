import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakti/Screens/AboutUs.dart';
import 'package:shakti/Screens/Login.dart';
import 'package:shakti/Utils/constants/colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  Timer? _periodicTimer;
  OverlayEntry? _popupEntry;
  AnimationController? _animationController;
  bool _isPopupShowing = false;
  final GlobalKey _learnMoreKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        if (mounted) {
          _showAnimatedPopup();
        }
      },
    );
  }

  void _cleanupPopupAndTimer() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _popupEntry?.remove();
    _popupEntry = null;
    _animationController?.dispose();
    _animationController = null;
    _isPopupShowing = false;
  }

  void _showAnimatedPopup() async {
    if (_isPopupShowing) return;
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final overlay = Overlay.of(context);
      if (overlay == null) return;
      final RenderBox? buttonBox =
          _learnMoreKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? overlayBox =
          overlay.context.findRenderObject() as RenderBox?;
      double popupBottom = 120.0; // fallback
      if (buttonBox != null && overlayBox != null) {
        final buttonOffset =
            buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox);
        popupBottom = overlayBox.size.height - buttonOffset.dy + 8.0;
      }
      _isPopupShowing = true;
      _popupEntry?.remove();
      _animationController?.dispose();
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      final animation = CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOutBack,
      );
      _popupEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: MediaQuery.of(context).size.width / 2 - 160,
          bottom: popupBottom,
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orangeAccent, Scolor.secondry],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "🎉 Visit Learn More to get dummy credentials to test and explore features.\n Signup is a long process!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      overlay.insert(_popupEntry!);
      _animationController!.forward();

      // Remove after 1 second with fade-out
      Future.delayed(const Duration(seconds: 2), () async {
        if (!mounted) return;
        await _animationController?.reverse();
        _popupEntry?.remove();
        _popupEntry = null;
        _isPopupShowing = false;
      });
    });
  }

  @override
  void dispose() {
    _cleanupPopupAndTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Scolor.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double contentMaxWidth;
          double sw = constraints.maxWidth;
          if (sw < 600) {
            contentMaxWidth = 400;
          } else if (sw < 1000) {
            contentMaxWidth = 600;
          } else {
            contentMaxWidth = 900;
          }
          return Center(
            child: Container(
              width: contentMaxWidth,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w.clamp(16, 40),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 120.h.clamp(60, 160)),
                    CircleAvatar(
                      radius: 70.r.clamp(48, 90),
                      backgroundColor: Colors.transparent,
                      backgroundImage: const AssetImage('assets/logo.png'),
                    ),
                    SizedBox(height: 20.h.clamp(8, 40)),
                    Text(
                      "Shakti-Nxt",
                      style: TextStyle(
                        color: Scolor.light,
                        fontSize: 28.sp.clamp(20, 32),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h.clamp(4, 16)),
                    Text(
                      "Your AI-Powered Business Guide",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Scolor.secondry.withOpacity(0.8),
                        fontSize: 16.sp.clamp(12, 20),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h.clamp(18, 64)),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h.clamp(45, 55),
                      child: ElevatedButton(
                        onPressed: () {
                          _cleanupPopupAndTimer();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Scolor.secondry,
                          foregroundColor: Scolor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.r.clamp(8, 20)),
                          ),
                        ),
                        child: Text(
                          "Start Your Journey",
                          style: TextStyle(
                            fontSize: 16.sp.clamp(14, 20),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h.clamp(8, 24)),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h.clamp(45, 55),
                      child: OutlinedButton(
                        key: _learnMoreKey,
                        onPressed: () {
                          _cleanupPopupAndTimer();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Scolor.secondry,
                          side: BorderSide(color: Scolor.secondry),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.r.clamp(8, 20)),
                          ),
                        ),
                        child: Text(
                          "Learn More",
                          style: TextStyle(
                              fontSize: 16.sp.clamp(14, 20),
                              fontWeight: FontWeight.bold,
                              color: Scolor.secondry),
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h.clamp(24, 120)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
