import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_manager.dart';

/// What the player chose on the pause screen.
enum PauseResult { resume, quit }

class PauseScreen extends StatefulWidget {
  const PauseScreen({super.key});

  @override
  State<PauseScreen> createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen> {
  static const Color _orange = Color(0xFFf64900);

  BannerAd? _ad;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _ad = AdManager.createMediumRectangleAd(
      onLoaded: () {
        if (mounted) setState(() => _adLoaded = true);
      },
      onFailed: () {
        _ad?.dispose();
        _ad = null;
        if (mounted) setState(() => _adLoaded = false);
      },
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Future<void> _confirmQuit() async {
    final leave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.only(top: 50, left: 40, right: 40),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Leaving?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Your progress will be lost.\nAre you sure?',
          style: TextStyle(color: Colors.white70, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
            child: Row(
              children: [
                // No (left)
                Expanded(
                  child: AnimatedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    color: Colors.white24,
                    height: 40,
                    borderRadius: 8,
                    shadowDegree: ShadowDegree.light,
                    child: const Text(
                      'NO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Yes (right)
                Expanded(
                  child: AnimatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    color: _orange,
                    height: 40,
                    borderRadius: 8,
                    shadowDegree: ShadowDegree.dark,
                    child: const Text(
                      'YES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (leave == true && mounted) {
      Navigator.pop(context, PauseResult.quit);
    }
  }

  void _resume() => Navigator.pop(context, PauseResult.resume);

  Widget _adFrame() {
    final ad = _ad;
    return Container(
      width: 300 + 8,
      height: 250 + 8,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _orange, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: (ad != null && _adLoaded)
            ? AdWidget(ad: ad)
            : Center(
          child: ad == null
              ? const Text(
            'Ad unavailable',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          )
              : const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white38,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = (MediaQuery.of(context).size.width - 12 - 12 - 8) / 2;

    return PopScope(
      canPop: false, // system back button = resume
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _resume();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Container(
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Text(
                  'Paused',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ── Middle: poker table background + framed ad ──
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/poker-table-background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                    Center(child: _adFrame()),
                  ],
                ),
              ),

              // ── Bottom bar: Quit (left), Resume (right) ──
              Container(
                color: Colors.black,
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Row(
                  children: [
                    AnimatedButton(
                      onPressed: _confirmQuit,
                      color: Colors.white24,
                      width: buttonWidth,
                      shadowDegree: ShadowDegree.light,
                      child: const Text(
                        'QUIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedButton(
                      onPressed: _resume,
                      color: _orange,
                      width: buttonWidth,
                      child: const Text(
                        'RESUME',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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