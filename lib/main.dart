import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const RuneDayApp());
}

class Rune {
  final String id;
  final String name;
  final String symbol; // Rune unicode symbol (e.g. ᚠ, ᚢ, ᚦ)
  final String title;
  final String description;
  final String advice;
  final String element;
  final String imagePath;
  final Color elementColor;

  const Rune({
    required this.id,
    required this.name,
    required this.symbol,
    required this.title,
    required this.description,
    required this.advice,
    required this.element,
    required this.imagePath,
    required this.elementColor,
  });
}

final List<Rune> allRunes = [
  const Rune(
    id: 'fehu', name: 'Феху', symbol: 'ᚠ',
    title: 'Богатство и достаток',
    description: 'Сегодня день изобилия. То, во что ты вложила силы, начинает приносить плоды.',
    advice: 'Проверь свои финансы: есть ли "утечки"? Закрой их и направь ресурсы на рост.',
    element: 'Земля',
    imagePath: 'assets/runes/01_fehu.png',
    elementColor: Color(0xFFE8D5B7),
  ),
  const Rune(
    id: 'uruz', name: 'Уруз', symbol: 'ᚢ',
    title: 'Сила и здоровье',
    description: 'День силы. Ты способна преодолеть то, что казалось невозможным.',
    advice: 'Сделай то, что откладывала. Начни с самого сложного — силы хватит.',
    element: 'Огонь',
    imagePath: 'assets/runes/02_uruz.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'thurisaz', name: 'Турисаз', symbol: 'ᚦ',
    title: 'Защита и границы',
    description: 'Сегодня нужна твердость. Кто-то может перейти границы — не позволяй.',
    advice: 'Скажи "нет" там, где обычно соглашаешься.',
    element: 'Огонь',
    imagePath: 'assets/runes/03_thurisaz.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'ansuz', name: 'Ансуз', symbol: 'ᚨ',
    title: 'Слово и связь',
    description: 'День общения. Слова сегодня имеют особую силу.',
    advice: 'Напиши или позвони человеку, о котором думаешь.',
    element: 'Воздух',
    imagePath: 'assets/runes/04_ansuz.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'raido', name: 'Райдо', symbol: 'ᚱ',
    title: 'Путь и движение',
    description: 'Сегодня дорога открыта. Двигайся — путь покажет, куда идти.',
    advice: 'Сделай шаг в неизвестность.',
    element: 'Воздух',
    imagePath: 'assets/runes/05_raido.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'kenaz', name: 'Кеназ', symbol: 'ᚲ',
    title: 'Знание и прозрение',
    description: 'Сегодня придет понимание. То, что было в тумане, обретет форму.',
    advice: 'Задай вопрос, на который боишься ответить.',
    element: 'Огонь',
    imagePath: 'assets/runes/06_kenaz.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'gebo', name: 'Гебо', symbol: 'ᚷ',
    title: 'Дар и обмен',
    description: 'Сегодня день равновесия. Получай и отдавай.',
    advice: 'Сделай кому-то подарок без повода.',
    element: 'Воздух',
    imagePath: 'assets/runes/07_gebo.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'wunjo', name: 'Вуньо', symbol: 'ᚹ',
    title: 'Радость и удача',
    description: 'Сегодня удача на твоей стороне. Смейся, радуйся мелочам.',
    advice: 'Сделай что-то ради удовольствия, а не пользы.',
    element: 'Огонь',
    imagePath: 'assets/runes/08_wunjo.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'hagalaz', name: 'Хагалаз', symbol: 'ᚺ',
    title: 'Перемены и разрушение',
    description: 'Сегодня что-то ломается. Не сопротивляйся — это освобождение.',
    advice: 'Отпусти то, что держишь из страха.',
    element: 'Вода',
    imagePath: 'assets/runes/09_hagalaz.png',
    elementColor: Color(0xFFC2E4F4),
  ),
  const Rune(
    id: 'nauthiz', name: 'Наутиз', symbol: 'ᚾ',
    title: 'Трудность и терпение',
    description: 'Сегодня тяжело. Это не наказание, а закалка.',
    advice: 'Не принимай важных решений сегодня. Подожди.',
    element: 'Огонь',
    imagePath: 'assets/runes/10_nauthiz.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'isa', name: 'Иса', symbol: 'ᛁ',
    title: 'Стоп и замерзание',
    description: 'Сегодня все стоит. Это время для наблюдения.',
    advice: 'Не делай резких движений. Жди.',
    element: 'Вода',
    imagePath: 'assets/runes/11_isa.png',
    elementColor: Color(0xFFC2E4F4),
  ),
  const Rune(
    id: 'jera', name: 'Йера', symbol: 'ᛃ',
    title: 'Урожай и цикл',
    description: 'Сегодня пожинаешь то, что сеяла. Цикл завершен.',
    advice: 'Оцени результат последнего месяца.',
    element: 'Земля',
    imagePath: 'assets/runes/12_jera.png',
    elementColor: Color(0xFFE8D5B7),
  ),
  const Rune(
    id: 'eihwaz', name: 'Эйваз', symbol: 'ᛇ',
    title: 'Защита и связь миров',
    description: 'Сегодня ты на грани. Грань — это место силы.',
    advice: 'Слушай интуицию.',
    element: 'Воздух',
    imagePath: 'assets/runes/13_eihwaz.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'perthro', name: 'Перт', symbol: 'ᛈ',
    title: 'Тайна и судьба',
    description: 'Сегодня играет случай. Позволь удаче войти.',
    advice: 'Сделай что-то спонтанное.',
    element: 'Вода',
    imagePath: 'assets/runes/14_perthro.png',
    elementColor: Color(0xFFC2E4F4),
  ),
  const Rune(
    id: 'algiz', name: 'Альгиз', symbol: 'ᛉ',
    title: 'Защита и высшие силы',
    description: 'Сегодня ты под защитой. Не бойся идти вперед.',
    advice: 'Сделай шаг, который боишься.',
    element: 'Воздух',
    imagePath: 'assets/runes/15_algiz.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'sowilo', name: 'Соулу', symbol: 'ᛋ',
    title: 'Солнце и победа',
    description: 'Сегодня светит солнце. Победа уже близка.',
    advice: 'Закончи начатое.',
    element: 'Огонь',
    imagePath: 'assets/runes/16_sowilo.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'tiwaz', name: 'Тейваз', symbol: 'ᛏ',
    title: 'Справедливость и жертва',
    description: 'Сегодня нужна честность. Прежде всего — с собой.',
    advice: 'Ответь: "Честно ли я поступаю?"',
    element: 'Огонь',
    imagePath: 'assets/runes/17_tiwaz.png',
    elementColor: Color(0xFFF4C2C2),
  ),
  const Rune(
    id: 'berkana', name: 'Беркана', symbol: 'ᛒ',
    title: 'Рождение и рост',
    description: 'Сегодня зарождается что-то новое.',
    advice: 'Начни маленькое дело, которое откладывала.',
    element: 'Земля',
    imagePath: 'assets/runes/18_berkana.png',
    elementColor: Color(0xFFE8D5B7),
  ),
  const Rune(
    id: 'ehwaz', name: 'Эваз', symbol: 'ᛖ',
    title: 'Движение и перемещение',
    description: 'Сегодня лошадь готова. Двигайся.',
    advice: 'Смени локацию или точку зрения.',
    element: 'Воздух',
    imagePath: 'assets/runes/19_ehwaz.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'mannaz', name: 'Манназ', symbol: 'ᛗ',
    title: 'Человек и сообщество',
    description: 'Сегодня день людей. Ты не одна.',
    advice: 'Попроси совета — не стыдно.',
    element: 'Воздух',
    imagePath: 'assets/runes/20_mannaz.png',
    elementColor: Color(0xFFC2D4F4),
  ),
  const Rune(
    id: 'laguz', name: 'Лагуз', symbol: 'ᛚ',
    title: 'Вода и поток',
    description: 'Сегодня теки. Доверься потоку.',
    advice: 'Плачь, если хочется. Дай эмоциям выйти.',
    element: 'Вода',
    imagePath: 'assets/runes/21_laguz.png',
    elementColor: Color(0xFFC2E4F4),
  ),
  const Rune(
    id: 'inguz', name: 'Ингуз', symbol: 'ᛝ',
    title: 'Потенциал и завершение',
    description: 'Сегодня посев завершен. Доверься.',
    advice: 'Поставь точку. Переходи к следующему.',
    element: 'Земля',
    imagePath: 'assets/runes/22_inguz.png',
    elementColor: Color(0xFFE8D5B7),
  ),
  const Rune(
    id: 'othala', name: 'Отал', symbol: 'ᛟ',
    title: 'Наследие и род',
    description: 'Сегодня день корней. Связь с родом — сила.',
    advice: 'Позвони родителям.',
    element: 'Земля',
    imagePath: 'assets/runes/23_othala.png',
    elementColor: Color(0xFFE8D5B7),
  ),
  const Rune(
    id: 'dagaz', name: 'Дагаз', symbol: 'ᛞ',
    title: 'Рассвет и просветление',
    description: 'Сегодня рассвет. Тьма уходит.',
    advice: 'Встань раньше обычного.',
    element: 'Огонь',
    imagePath: 'assets/runes/24_dagaz.png',
    elementColor: Color(0xFFF4C2C2),
  ),
];

class RuneDayApp extends StatelessWidget {
  const RuneDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Руна Дня',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const RuneScreen(),
    );
  }
}

class RuneScreen extends StatefulWidget {
  const RuneScreen({super.key});

  @override
  State<RuneScreen> createState() => _RuneScreenState();
}

class _RuneScreenState extends State<RuneScreen>
    with TickerProviderStateMixin {
  Rune? _todayRune;
  bool _isShuffling = false;
  bool _showCollection = false;
  bool _showUpsell = false;
  DateTime? _lastDrawDate;
  int _extraDrawsUsed = 0;
  final Set<String> _collected = {};
  int _currentPage = 0;
  late int _rareRuneIndex; // One random rune per user session as "rare"

  late PageController _pageController;
  late AnimationController _revealController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _rareRuneIndex = Random().nextInt(allRunes.length);
    _pageController = PageController(viewportFraction: 0.55);
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.elasticOut),
    );
  }

  bool get _canDrawToday {
    if (_lastDrawDate == null) return true;
    final now = DateTime.now();
    return _lastDrawDate!.year != now.year ||
        _lastDrawDate!.month != now.month ||
        _lastDrawDate!.day != now.day;
  }

  Rune _weightedRandomRune() {
    final random = Random();
    // 0.04% chance (4/10000) for the rare rune
    // 99.96% distributed among all 24 runes equally
    // But first draw: always truly random
    if (_collected.isEmpty) {
      return allRunes[random.nextInt(allRunes.length)];
    }
    final roll = random.nextInt(10000); // 0-9999
    if (roll < 4) { // 0.04%
      return allRunes[_rareRuneIndex];
    }
    return allRunes[random.nextInt(allRunes.length)];
  }

  void _startShuffle() {
    if (!_canDrawToday && _extraDrawsUsed >= 1) {
      _showLimitDialog();
      return;
    }

    if (!_canDrawToday && _extraDrawsUsed == 0) {
      setState(() => _showUpsell = true);
      return;
    }

    setState(() {
      _isShuffling = true;
      _todayRune = null;
      _showUpsell = false;
    });

    _shuffleSequence();
  }

  void _shuffleSequence() async {
    final random = Random();
    final totalSteps = 30 + random.nextInt(20); // 30-50 steps
    final baseDelay = 50;

    for (int i = 0; i < totalSteps; i++) {
      final delay = baseDelay + (i * 20); // gradually slow down
      await Future.delayed(Duration(milliseconds: delay));
      if (!mounted) return;
      setState(() => _currentPage = random.nextInt(allRunes.length));
    }

    // Final selection
    final rune = _weightedRandomRune();
    final finalIndex = allRunes.indexOf(rune);
    setState(() {
      _todayRune = rune;
      _collected.add(rune.id);
      _lastDrawDate = DateTime.now();
      _isShuffling = false;
      _currentPage = finalIndex;
    });

    _revealController.reset();
    _revealController.forward();
  }

  void _buyExtraDraw() {
    setState(() {
      _extraDrawsUsed++;
      _showUpsell = false;
    });
    _startShuffle();
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Руна уже вытянута', textAlign: TextAlign.center),
        content: const Text(
          'Сегодня ты уже получила свой знак.\nНовая руна будет доступна завтра.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Понятно', style: TextStyle(color: Color(0xFFE8B4D9))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'РУНА ДНЯ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                          color: Color(0x4D000000),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_collected.length} / ${allRunes.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      _showCollection ? Icons.auto_awesome : Icons.grid_view,
                      color: const Color(0xFFE8B4D9),
                    ),
                    onPressed: () => setState(() => _showCollection = !_showCollection),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _showCollection
                  ? _buildCollection()
                  : _isShuffling
                      ? _buildShuffleAnimation()
                      : (_todayRune == null ? _buildEmptyState() : _buildRuneReveal()),
            ),
            if (!_showCollection && !_isShuffling)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final canDraw = _canDrawToday;
    final hasDrawn = _todayRune != null;
    final extraAvailable = _extraDrawsUsed == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasDrawn)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startShuffle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8B4D9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'ПОЛУЧИТЬ РУНУ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
          else if (canDraw)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startShuffle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8B4D9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'ЕЩЁ РУНА',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
          else if (extraAvailable)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8B4D9).withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_clock, size: 16, color: Color(0xFFE8B4D9)),
                          SizedBox(width: 8),
                          Text(
                            '1 руна в день — бесплатно',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A6A72),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Полный расклад: 3 руны о прошлом, настоящем и будущем',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _buyExtraDraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD54F),
                      foregroundColor: const Color(0xFF3E2723),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'ПОЛУЧИТЬ РАСКЛАД',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.nights_stay, size: 20, color: Color(0xFFE8B4D9)),
                  SizedBox(width: 8),
                  Text(
                    'Новая руна завтра',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A6A72),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShuffleAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: Color(0xFFE8B4D9),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Вселенная выбирает руну...',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF8A7A82),
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8B4D9).withOpacity(0.15),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 48,
              color: Color(0xFFE8B4D9),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Нажми на кнопку ниже',
            style: TextStyle(fontSize: 16, color: Colors.black38),
          ),
          const SizedBox(height: 8),
          const Text(
            'и получи свой знак дня',
            style: TextStyle(fontSize: 14, color: Colors.black26),
          ),
        ],
      ),
    );
  }

  Widget _buildRuneReveal() {
    final rune = _todayRune!;
    final isRare = allRunes.indexOf(rune) == _rareRuneIndex;
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // RARE badge
              if (isRare)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'РЕДКАЯ РУНА',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // Rune image with symbol overlay
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.32,
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: rune.elementColor.withOpacity(0.15),
                    boxShadow: [
                      BoxShadow(
                        color: rune.elementColor.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          rune.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // Rune symbol overlay
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.3),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              rune.symbol,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700),
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFFFA500),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Element badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: rune.elementColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  rune.element.toUpperCase(),
                  style: TextStyle(
                    color: rune.elementColor.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Rune symbol
              Text(
                rune.symbol,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3B42),
                ),
              ),
              const SizedBox(height: 8),

              // Name & title
              Text(
                rune.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3B42),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rune.title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),

              // Description card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      rune.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5A4A52),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F0F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            size: 18,
                            color: Color(0xFFE8B4D9),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Совет дня',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE8B4D9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rune.advice,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7A6A72),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
              const SizedBox(height: 10),

              // Scroll indicator (subtle)
              if (rune.advice.length > 50)
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0x33000000),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollection() {
    if (_collected.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.collections_bookmark_outlined, size: 64, color: Colors.black.withOpacity(0.15)),
            const SizedBox(height: 16),
            const Text(
              'Коллекция пуста',
              style: TextStyle(fontSize: 18, color: Colors.black38, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Тяни руны каждый день',
              style: TextStyle(fontSize: 14, color: Colors.black26),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: allRunes.length,
      itemBuilder: (context, index) {
        final rune = allRunes[index];
        final isCollected = _collected.contains(rune.id);
        final isRare = index == _rareRuneIndex;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isCollected ? null : Colors.white.withOpacity(0.5),
            border: Border.all(
              color: isCollected ? Colors.transparent : Colors.black.withOpacity(0.05),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: isCollected
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        rune.imagePath,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      if (isRare)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 10, color: Colors.white),
                                SizedBox(width: 2),
                                Text(
                                  'РЕДКАЯ',
                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rune.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rune.title,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Icon(
                      Icons.help_outline,
                      size: 32,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
