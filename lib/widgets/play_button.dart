// ============================================================
// widgets/play_button.dart — 播放/暂停按钮（动画 5 + 6）
//
// HTML 原型对照：.play-btn .icon-play/.icon-pause 叠放 + opacity/scale 过渡
// Flutter 动画 5：AnimatedSwitcher(duration: 220ms, transitionBuilder: ScaleTransition)
// Flutter 动画 6：AnimatedContainer(duration: 220ms)
// ============================================================

import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  const PlayButton({super.key, required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ===== 动画 6：AnimatedContainer 隐式过渡 =====
    // 底色 outline(灰) ↔ primary(蓝)，阴影 elevation 2 ↔ 4
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.ease,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          // 暂停：灰色 outline 背景；播放：primary 主色背景
          color: isPlaying
              ? const Color(0xFF4285F4)
              : const Color(0xFF79747E),  // m3-outline
          shape: BoxShape.circle,
          boxShadow: [
            // playing elevation 4 shadow，paused elevation 2 shadow
            BoxShadow(
              color: isPlaying
                  ? const Color(0x4D000000)
                  : const Color(0x4D000000),
              blurRadius: isPlaying ? 10 : 6,
              offset: const Offset(0, 2),
              spreadRadius: isPlaying ? 4 : 2,
            ),
          ],
        ),
        // ===== 动画 5：AnimatedSwitcher 显式切换 =====
        // 关键：两个 Icon 必须用不同的 ValueKey，否则 AnimatedSwitcher 不触发切换动画
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) {
            // ===== ScaleTransition 放大缩小切换 =====
            return ScaleTransition(scale: anim, child: child);
          },
          // 额外加个 FadeTransition，让切换更柔和（CSS 原型有 opacity 变化）
          child: isPlaying
              ? const Icon(Icons.pause, key: ValueKey<bool>(true), color: Colors.white, size: 28)
              : const Icon(Icons.play_arrow, key: ValueKey<bool>(false), color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
