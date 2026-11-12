// ============================================================
// main.dart — App 入口
// HTML 原型对照：melostructure.html 里 body → phone-frame
// Material 3 主题 + PlayerScope 状态提供者 + 初始路由
// ============================================================

import 'package:flutter/material.dart';
import 'state/player_controller.dart';
import 'pages/song_list_page.dart';

void main() {
  runApp(const MeloApp());
}

class MeloApp extends StatelessWidget {
  const MeloApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== Material 3 主题，默认 light =====
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4285F4),  // m3-primary 种子色
        brightness: Brightness.light,
      ),
    );

    return PlayerScope(
      child: MaterialApp(
        title: 'Melo',
        theme: theme,
        home: const SongListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
