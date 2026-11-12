// ============================================================
// pages/profile_page.dart — 个人中心页
// HTML 原型对照：melostructure.html 里 #page-profile
// ============================================================

import 'package:flutter/material.dart';
import '../state/player_controller.dart';
import 'song_list_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PlayerScope.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFEF7FF),
        title: const Text(
          '我的',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF1D1B20)),
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          // ===== 头像 + 昵称 =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A237E),  // m3-primary-container
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'M',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Melo 音乐爱好者',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF1D1B20)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '在歌声中遇见更好的自己',
                        style: TextStyle(fontSize: 14, color: Color(0xFF49454F)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFCAC4D0), height: 1),

          // ===== 我的收藏（显示数量）=====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '♡ 我的收藏',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1D1B20)),
                  ),
                  Text(
                    '${state.favoriteCount} 首 ›',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF79747E)),
                  ),
                ],
              ),
            ),
          ),
          _buildListTile('播放设置'),
          _buildListTile('主题外观'),
          _buildListTile('音质选择'),
          _buildListTile('关于 Melo', trailing: 'v1.0.0'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) {
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SongListPage()),
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

  Widget _buildListTile(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F2FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF1D1B20))),
            Text(
              trailing ?? '›',
              style: const TextStyle(fontSize: 12, color: Color(0xFF79747E)),
            ),
          ],
        ),
      ),
    );
  }
}
