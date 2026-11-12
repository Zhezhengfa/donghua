// ============================================================
// pages/song_list_page.dart — 歌单列表页
//
// HTML 原型对照：melostructure.html 里 #page-list
// Flutter 动画 1：交织动画 Interval + Tween<Offset> + FadeTransition + AnimatedBuilder
//
// 对应 Flutter API：
//   AnimationController + Curves.easeOutCubic
//   Interval(begin, end) 错峰每张卡片
//   Tween<Offset>(begin: Offset(0, 24), end: Offset.zero) 滑入
//   FadeTransition + SlideTransition + AnimatedBuilder
// ============================================================

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../state/player_controller.dart';
import '../widgets/song_card.dart';
import 'player_page.dart';
import 'profile_page.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    // ===== 动画 1：交错入场 controller =====
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // 页面首次进入时 forward，展示错峰入场
    Future.microtask(() => _entryController.forward(from: 0));
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = PlayerScope.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      // ===== AppBar =====
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFEF7FF),
        title: const Text(
          'Melo · 歌单',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF1D1B20)),
        ),
        centerTitle: false,
      ),
      // ===== ListView.builder 可滚动组件 =====
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return _buildAnimatedCard(index);
        },
      ),
      // ===== BottomNavigationBar =====
      // HTML 原型对照：.bottom-nav active indicator primaryContainer 圆角块
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.music_note_outlined), selectedIcon: Icon(Icons.music_note), label: '歌单'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }

  // ============================================================
  // 动画 1：交织动画 —— 每张卡片独立 Interval + Tween + AnimatedBuilder
  // ============================================================
  Widget _buildAnimatedCard(int index) {
    final state = PlayerScope.of(context);
    // Interval: 每张卡片占一个 0.06 宽的区间，错开 50ms 入场
    // begin = index * 0.05（每张延迟 5% duration）
    final begin = index * 0.05;
    final end = begin + 0.6;  // 每张自身动画时长占 60%

    // CurvedAnimation 用 Interval 让每张错峰
    final curved = CurvedAnimation(
      parent: _entryController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );

    // SlideTransition：Offset(0, 0.3) → Offset.zero（向下偏移然后滑入）
    final offsetAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(curved);

    // FadeTransition：0 → 1 淡入
    final fadeAnim = curved;

    // ===== AnimatedBuilder：每帧重建，同时用两个 Transition =====
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnim.value.clamp(0.0, 1.0),
          child: SlideTransition(
            position: offsetAnim,
            child: child,
          ),
        );
      },
      // 子 Widget 只构建一次，AnimatedBuilder 每帧只重新构建 Transition 层
      child: SongCard(
        song: songs[index],
        isPlayingHere: state.currentSongIndex == index,
        isFavorite: state.isFavorite(index),
        // 动画 2：点击触发 Hero 飞行（Navigator.push + PageRouteBuilder transitionDuration 300ms）
        onTap: () {
          state.openSong(index);
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) => const PlayerPage(),
            ),
          );
        },
        onFavTap: () => state.toggleFavorite(index),
      ),
    );
  }
}
