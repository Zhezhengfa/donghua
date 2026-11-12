// ============================================================
// models/song.dart — 歌曲数据模型 + mock 数据
// HTML 原型对照：melostructure.html 里 const SONGS + const LYRICS
// 本文件只声明 final 字段 + 8 首固定 mock，不引入任何外部依赖
// ============================================================

/// 单条歌词：时间戳（秒）+ 文本
class LyricLine {
  final double time;
  final String text;
  LyricLine({required this.time, required this.text});
}

/// 歌曲模型
/// 对应 Flutter 课程范围内基础类，无序列化、无网络依赖
class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;

  /// 封面渐变色，每个 List 两个颜色：[开始, 结束]
  /// 对应 HTML 原型里 .cov-0 ~ .cov-7 的 LinearGradient 135°
  final List<int> coverGradient;

  /// 歌词列表（每首 4~8 行 mock 数据）
  final List<LyricLine> lyrics;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.coverGradient,
    required this.lyrics,
  });
}

// ============================================================
// 8 首固定 mock 歌曲数据
// 时长、歌词、封面渐变色与 HTML 原型完全一致，确保两端视觉同步
// ============================================================
final List<Song> songs = [
  Song(
    id: 0,
    title: '夜空中最亮的星',
    artist: '逃跑计划',
    album: '世界',
    duration: const Duration(seconds: 248),
    coverGradient: [0xFF667EEA, 0xFF764BA2],
    lyrics: [
      LyricLine(time: 0,  text: '夜空中最亮的星，能否听清'),
      LyricLine(time: 4,  text: '那仰望的人，心底的孤独和叹息'),
      LyricLine(time: 8,  text: '夜空中最亮的星，能否记起'),
      LyricLine(time: 12, text: '曾与我同行，消失在风里的身影'),
      LyricLine(time: 17, text: '我祈祷拥有一颗透明的心灵'),
      LyricLine(time: 22, text: '和会流泪的眼睛'),
      LyricLine(time: 26, text: '给我再去相信的勇气'),
      LyricLine(time: 30, text: '越过谎言去拥抱你'),
    ],
  ),
  Song(
    id: 1,
    title: '晴天',
    artist: '周杰伦',
    album: '叶惠美',
    duration: const Duration(seconds: 269),
    coverGradient: [0xFFF093FB, 0xFFF5576C],
    lyrics: [
      LyricLine(time: 0,  text: '故事的小黄花'),
      LyricLine(time: 3,  text: '从出生那年就飘着'),
      LyricLine(time: 6,  text: '童年的荡秋千'),
      LyricLine(time: 9,  text: '随记忆一直晃到现在'),
      LyricLine(time: 13, text: 'Re So So Si Do Si La'),
      LyricLine(time: 17, text: 'So La Si Si Si Si La Si La So'),
    ],
  ),
  Song(
    id: 2,
    title: '蓝莲花',
    artist: '许巍',
    album: '时光·漫步',
    duration: const Duration(seconds: 275),
    coverGradient: [0xFF4FACFE, 0xFF00F2FE],
    lyrics: [
      LyricLine(time: 0,  text: '没有什么能够阻挡'),
      LyricLine(time: 4,  text: '你对自由的向往'),
      LyricLine(time: 7,  text: '天马行空的生涯'),
      LyricLine(time: 10, text: '你的心了无牵挂'),
      LyricLine(time: 14, text: '穿过幽暗的岁月'),
      LyricLine(time: 18, text: '也曾感到彷徨'),
    ],
  ),
  Song(
    id: 3,
    title: '成都',
    artist: '赵雷',
    album: '无法长大',
    duration: const Duration(seconds: 328),
    coverGradient: [0xFF43E97B, 0xFF38F9D7],
    lyrics: [
      LyricLine(time: 0,  text: '让我掉下眼泪的，不止昨夜的酒'),
      LyricLine(time: 6,  text: '让我依依不舍的，不止你的温柔'),
      LyricLine(time: 12, text: '余路还要走多久，你攥着我的手'),
      LyricLine(time: 18, text: '让我感到为难的，是挣扎的自由'),
    ],
  ),
  Song(
    id: 4,
    title: '安河桥',
    artist: '宋冬野',
    album: '安和桥北',
    duration: const Duration(seconds: 338),
    coverGradient: [0xFFFA709A, 0xFFFEE140],
    lyrics: [
      LyricLine(time: 0,  text: '让我再看你一遍，从南到北'),
      LyricLine(time: 5,  text: '像是被五环路蒙住的双眼'),
      LyricLine(time: 10, text: '请你再讲一遍，关于那天'),
      LyricLine(time: 15, text: '抱着盒子的姑娘'),
      LyricLine(time: 18, text: '和擦干的男人'),
    ],
  ),
  Song(
    id: 5,
    title: '理想三旬',
    artist: '陈鸿宇',
    album: '浓烟下的诗歌电台',
    duration: const Duration(seconds: 211),
    coverGradient: [0xFF30CFD0, 0xFF330867],
    lyrics: [
      LyricLine(time: 0,  text: '雨后的公交车站'),
      LyricLine(time: 3,  text: '有个人在等你'),
      LyricLine(time: 6,  text: '路过的人都戴着面具'),
      LyricLine(time: 10, text: '笑着说你好'),
    ],
  ),
  Song(
    id: 6,
    title: '春风十里',
    artist: '鹿先森乐队',
    album: '所有的酒都不如你',
    duration: const Duration(seconds: 375),
    coverGradient: [0xFFA8EDEA, 0xFFFED6E3],
    lyrics: [
      LyricLine(time: 0,  text: '我在二环路的里边，想着你'),
      LyricLine(time: 6,  text: '你在远方的山上，春风十里'),
      LyricLine(time: 12, text: '今天的风吹向你，下了雨'),
      LyricLine(time: 18, text: '我说所有的酒，都不如你'),
    ],
  ),
  Song(
    id: 7,
    title: '往后余生',
    artist: '马良',
    album: '往后余生',
    duration: const Duration(seconds: 271),
    coverGradient: [0xFFFF9A9E, 0xFFFECFEF],
    lyrics: [
      LyricLine(time: 0,  text: '往后余生，风雪是你'),
      LyricLine(time: 4,  text: '平淡是你，清贫也是你'),
      LyricLine(time: 8,  text: '荣华是你，心底温柔是你'),
      LyricLine(time: 12, text: '目光所至，也是你'),
    ],
  ),
];

/// 把秒数格式化为 m:ss
String fmtDuration(Duration d) {
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return '$m:${s.toString().padLeft(2, '0')}';
}
