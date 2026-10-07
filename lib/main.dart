import 'dart:math';
import 'package:activation_codes/activation_codes.dart' as ac;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RuneDayApp());
}

// ─────────────────────────────────────────────────────────────
// Task 089: Premium-статус и активация кодов.
// ─────────────────────────────────────────────────────────────

class PremiumService {
  PremiumService._();
  static final PremiumService instance = PremiumService._();

  static const _kPremium = 'rune_premium_v1';
  static const _kPremiumExpiry = 'rune_premium_expiry_v1';

  final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    final premium = p.getBool(_kPremium) ?? false;
    final expiryMs = p.getInt(_kPremiumExpiry);
    if (premium && expiryMs != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch(expiryMs);
      if (DateTime.now().isAfter(expiry)) {
        await _clearPremium();
        return;
      }
    }
    isPremium.value = premium;
  }

  Future<void> activatePremium(DateTime? expiresAt) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kPremium, true);
    if (expiresAt != null) {
      await p.setInt(_kPremiumExpiry, expiresAt.millisecondsSinceEpoch);
    }
    isPremium.value = true;
  }

  Future<void> _clearPremium() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kPremium);
    await p.remove(_kPremiumExpiry);
    isPremium.value = false;
  }
}

/// Активация кодов для Руны (appId: RUNA).
class RuneCodeService {
  RuneCodeService._();
  static final RuneCodeService instance = RuneCodeService._();

  static const _appId = 'RUNA';
  static const _appCode = 3;
  static const _key = String.fromEnvironment('CODE_KEY', defaultValue: '');
  static const _serverUrl = String.fromEnvironment('BILLING_API_URL', defaultValue: '');

  static const Map<String, int> _types = {
    'PREMIUM_MONTH': 1,
    'PREMIUM_YEAR': 2,
  };

  late final ac.CodeBackend _backend;

  Future<void> init() async {
    if (_key.isEmpty) return;
    final local = ac.LocalCodeBackend(
      appId: _appId,
      appCode: _appCode,
      types: _types,
      key: _key,
    );
    if (_serverUrl.isNotEmpty) {
      final server = ac.ServerCodeBackend(baseUrl: _serverUrl, appId: _appId);
      _backend = ac.SmartCodeBackend(local: local, server: server, appId: _appId);
    } else {
      _backend = local;
    }
  }

  bool get isReady => _key.isNotEmpty;

  Future<ac.CodeResult> redeem(String code) => _backend.redeem(code);

  Future<void> applyCodeResult(ac.CodeResult result) async {
    if (!result.ok) return;
    final typeKey = result.typeKey;
    if (typeKey == null) return;
    // PREMIUM_MONTH / PREMIUM_YEAR → premium
    if (typeKey == 'PREMIUM_MONTH' || typeKey == 'PREMIUM_YEAR') {
      await PremiumService.instance.activatePremium(result.expiresAt);
    }
  }
}

class Rune {
  final String id;
  final String name;
  final String symbol;
  final String title;
  final String description;
  final String advice;
  final String element;
  final Gradient gradient;
  final IconData icon;

  const Rune({
    required this.id,
    required this.name,
    required this.symbol,
    required this.title,
    required this.description,
    required this.advice,
    required this.element,
    required this.gradient,
    required this.icon,
  });
}

final List<Rune> allRunes = [
  const Rune(
    id: 'fehu', name: 'Феху', symbol: 'F',
    title: 'Богатство и достаток',
    description: 'Сегодня день изобилия. То, во что ты вложила силы, начинает приносить плоды. Не бойся тратить на развитие — энергия возвращается умноженной.',
    advice: 'Проверь свои финансы: есть ли "утечки"? Закрой их и направь ресурсы на рост.',
    element: 'Земля',
    gradient: LinearGradient(colors: [Color(0xFFE8D5B7), Color(0xFFD4B896)]),
    icon: Icons.payments_outlined,
  ),
  const Rune(
    id: 'uruz', name: 'Уруз', symbol: 'U',
    title: 'Сила и здоровье',
    description: 'День силы. Ты способна преодолеть то, что казалось невозможным. Тело и дух едины — дай им движение.',
    advice: 'Сделай то, что откладывала. Начни с самого сложного — силы хватит.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.favorite_outline,
  ),
  const Rune(
    id: 'thurisaz', name: 'Турисаз', symbol: 'Th',
    title: 'Защита и границы',
    description: 'Сегодня нужна твердость. Кто-то может перейти границы — не позволяй. Защита своего пространства — не эгоизм, а необходимость.',
    advice: 'Скажи "нет" там, где обычно соглашаешься. Почувствуй, как вырастет твоя сила.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.shield_outlined,
  ),
  const Rune(
    id: 'ansuz', name: 'Ансуз', symbol: 'A',
    title: 'Слово и связь',
    description: 'День общения. Слова сегодня имеют особую силу — произнеси то, что давно замирало на языке.',
    advice: 'Напиши или позвони человеку, о котором думаешь. Простое "как дела?" — уже магия.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.chat_bubble_outline,
  ),
  const Rune(
    id: 'raido', name: 'Райдо', symbol: 'R',
    title: 'Путь и движение',
    description: 'Сегодня дорога открыта. Даже если цель не ясна — двигайся. Сам путь покажет, куда идти.',
    advice: 'Сделай шаг в неизвестность. Сходи туда, куда не ходила.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.directions_walk,
  ),
  const Rune(
    id: 'kenaz', name: 'Кеназ', symbol: 'K',
    title: 'Знание и прозрение',
    description: 'Сегодня придет понимание. То, что было в тумане, вдруг обретет форму.',
    advice: 'Задай вопрос, на который боишься ответить. Ответ придет сам.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.lightbulb_outline,
  ),
  const Rune(
    id: 'gebo', name: 'Гебо', symbol: 'G',
    title: 'Дар и обмен',
    description: 'Сегодня день равновесия. Получай и отдавай. Дар не должен быть однобоким.',
    advice: 'Сделай кому-то подарок без повода. И прими подарок, если его предложат.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.card_giftcard,
  ),
  const Rune(
    id: 'wunjo', name: 'Вуньо', symbol: 'W',
    title: 'Радость и удача',
    description: 'Сегодня удача на твоей стороне. Смейся, радуйся мелочам.',
    advice: 'Сделай что-то ради удовольствия, а не пользы.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.sentiment_very_satisfied,
  ),
  const Rune(
    id: 'hagalaz', name: 'Хагалаз', symbol: 'H',
    title: 'Перемены и разрушение',
    description: 'Сегодня что-то ломается. Не сопротивляйся — это освобождение от старого.',
    advice: 'Отпусти то, что держишь из страха.',
    element: 'Вода',
    gradient: LinearGradient(colors: [Color(0xFFC2E4F4), Color(0xFFA8D4E8)]),
    icon: Icons.water_drop_outlined,
  ),
  const Rune(
    id: 'nauthiz', name: 'Наутиз', symbol: 'N',
    title: 'Трудность и терпение',
    description: 'Сегодня тяжело. Это не наказание, а закалка.',
    advice: 'Не принимай важных решений сегодня. Подожди.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.hourglass_empty,
  ),
  const Rune(
    id: 'isa', name: 'Иса', symbol: 'I',
    title: 'Стоп и замерзание',
    description: 'Сегодня все стоит. Это время для наблюдения, не для действия.',
    advice: 'Не делай резких движений. Жди.',
    element: 'Вода',
    gradient: LinearGradient(colors: [Color(0xFFC2E4F4), Color(0xFFA8D4E8)]),
    icon: Icons.ac_unit,
  ),
  const Rune(
    id: 'jera', name: 'Йера', symbol: 'J',
    title: 'Урожай и цикл',
    description: 'Сегодня пожинаешь то, что сеяла. Цикл завершен.',
    advice: 'Оцени результат последнего месяца. Корректируй курс.',
    element: 'Земля',
    gradient: LinearGradient(colors: [Color(0xFFE8D5B7), Color(0xFFD4B896)]),
    icon: Icons.eco_outlined,
  ),
  const Rune(
    id: 'eihwaz', name: 'Эйваз', symbol: 'Ei',
    title: 'Защита и связь миров',
    description: 'Сегодня ты на грани. Грань — это место силы.',
    advice: 'Слушай интуицию.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.auto_fix_high,
  ),
  const Rune(
    id: 'perthro', name: 'Перт', symbol: 'P',
    title: 'Тайна и судьба',
    description: 'Сегодня играет случай. Позволь удаче войти.',
    advice: 'Сделай что-то спонтанное.',
    element: 'Вода',
    gradient: LinearGradient(colors: [Color(0xFFC2E4F4), Color(0xFFA8D4E8)]),
    icon: Icons.casino_outlined,
  ),
  const Rune(
    id: 'algiz', name: 'Альгиз', symbol: 'Z',
    title: 'Защита и связь с высшими силами',
    description: 'Сегодня ты под защитой. Не бойся идти вперед.',
    advice: 'Сделай шаг, который боишься.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.favorite,
  ),
  const Rune(
    id: 'sowilo', name: 'Соулу', symbol: 'S',
    title: 'Солнце и победа',
    description: 'Сегодня светит солнце. Победа уже близка.',
    advice: 'Закончи начатое.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.wb_sunny_outlined,
  ),
  const Rune(
    id: 'tiwaz', name: 'Тейваз', symbol: 'T',
    title: 'Справедливость и жертва',
    description: 'Сегодня нужна честность. Прежде всего — с собой.',
    advice: 'Ответь: "Честно ли я поступаю?"',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.balance,
  ),
  const Rune(
    id: 'berkana', name: 'Беркана', symbol: 'B',
    title: 'Рождение и рост',
    description: 'Сегодня зарождается что-то новое.',
    advice: 'Начни маленькое дело, которое откладывала.',
    element: 'Земля',
    gradient: LinearGradient(colors: [Color(0xFFE8D5B7), Color(0xFFD4B896)]),
    icon: Icons.spa_outlined,
  ),
  const Rune(
    id: 'ehwaz', name: 'Эваз', symbol: 'E',
    title: 'Движение и перемещение',
    description: 'Сегодня лошадь готова. Двигайся.',
    advice: 'Смени локацию или точку зрения.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.directions_run,
  ),
  const Rune(
    id: 'mannaz', name: 'Манназ', symbol: 'M',
    title: 'Человек и сообщество',
    description: 'Сегодня день людей. Ты не одна.',
    advice: 'Попроси совета — не стыдно.',
    element: 'Воздух',
    gradient: LinearGradient(colors: [Color(0xFFC2D4F4), Color(0xFFA8C4E8)]),
    icon: Icons.people_outline,
  ),
  const Rune(
    id: 'laguz', name: 'Лагуз', symbol: 'L',
    title: 'Вода и поток',
    description: 'Сегодня теки. Доверься потоку.',
    advice: 'Плачь, если хочется. Дай эмоциям выйти.',
    element: 'Вода',
    gradient: LinearGradient(colors: [Color(0xFFC2E4F4), Color(0xFFA8D4E8)]),
    icon: Icons.waves,
  ),
  const Rune(
    id: 'inguz', name: 'Ингуз', symbol: 'Ing',
    title: 'Потенциал и завершение',
    description: 'Сегодня посев завершен. Доверься.',
    advice: 'Поставь точку. Переходи к следующему.',
    element: 'Земля',
    gradient: LinearGradient(colors: [Color(0xFFE8D5B7), Color(0xFFD4B896)]),
    icon: Icons.grain,
  ),
  const Rune(
    id: 'dagaz', name: 'Дагаз', symbol: 'D',
    title: 'Рассвет и просветление',
    description: 'Сегодня рассвет. Тьма уходит.',
    advice: 'Встань раньше обычного.',
    element: 'Огонь',
    gradient: LinearGradient(colors: [Color(0xFFF4C2C2), Color(0xFFE8A0A0)]),
    icon: Icons.wb_twilight,
  ),
  const Rune(
    id: 'othala', name: 'Отал', symbol: 'O',
    title: 'Наследие и род',
    description: 'Сегодня день корней. Связь с родом — сила.',
    advice: 'Позвони родителям.',
    element: 'Земля',
    gradient: LinearGradient(colors: [Color(0xFFE8D5B7), Color(0xFFD4B896)]),
    icon: Icons.home_outlined,
  ),
  const Rune(
    id: 'wyrd', name: 'Вирд', symbol: 'X',
    title: 'Судьба и неизвестность',
    description: 'Сегодня пустая руна. Судьба не написана — ты пишешь ее сама.',
    advice: 'Сделай выбор, который боишься.',
    element: 'Вода',
    gradient: LinearGradient(colors: [Color(0xFFC2E4F4), Color(0xFFA8D4E8)]),
    icon: Icons.help_outline,
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
    with SingleTickerProviderStateMixin {
  Rune? _todayRune;
  bool _isDrawing = false;
  bool _showCollection = false;
  DateTime? _lastDrawDate;
  final Set<String> _collected = {};
  int _drawCountToday = 0;
  static const _maxDrawsPerDay = 1;
  static const _maxDrawsPremium = 3;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _loadState();
    _initServices();
  }

  Future<void> _initServices() async {
    await PremiumService.instance.init();
    await RuneCodeService.instance.init();
  }

  Future<void> _loadState() async {
    final p = await SharedPreferences.getInstance();
    final lastMs = p.getInt('rune_last_draw_ms');
    if (lastMs != null) {
      _lastDrawDate = DateTime.fromMillisecondsSinceEpoch(lastMs);
      final now = DateTime.now();
      if (_lastDrawDate!.year == now.year &&
          _lastDrawDate!.month == now.month &&
          _lastDrawDate!.day == now.day) {
        _drawCountToday = p.getInt('rune_draw_count') ?? 0;
      }
    }
    final collected = p.getStringList('rune_collected') ?? [];
    setState(() => _collected.addAll(collected));
  }

  Future<void> _saveState() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('rune_last_draw_ms', DateTime.now().millisecondsSinceEpoch);
    await p.setInt('rune_draw_count', _drawCountToday);
    await p.setStringList('rune_collected', _collected.toList());
  }

  int get _maxDraws => PremiumService.instance.isPremium.value
      ? _maxDrawsPremium
      : _maxDrawsPerDay;

  bool get _canDrawToday {
    final now = DateTime.now();
    if (_lastDrawDate == null) return true;
    if (_lastDrawDate!.year != now.year ||
        _lastDrawDate!.month != now.month ||
        _lastDrawDate!.day != now.day) return true;
    return _drawCountToday < _maxDraws;
  }

  void _drawRune() {
    if (!_canDrawToday) {
      _showLimitDialog();
      return;
    }
    setState(() => _isDrawing = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random(DateTime.now().millisecondsSinceEpoch);
      final rune = allRunes[random.nextInt(allRunes.length)];
      setState(() {
        _todayRune = rune;
        _collected.add(rune.id);
        _lastDrawDate = DateTime.now();
        _drawCountToday++;
        _isDrawing = false;
      });
      _animController.reset();
      _animController.forward();
      _saveState();
    });
  }

  void _showLimitDialog() {
    final isPremium = PremiumService.instance.isPremium.value;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Лимит вытягиваний', textAlign: TextAlign.center),
        content: Text(
          isPremium
              ? 'Сегодня ты вытянула $_maxDrawsPremium руны.\nНовые — завтра.'
              : 'Сегодня ты уже вытянула руну.\nPremium — до $_maxDrawsPremium вытягиваний в день.\n\nАктивируйте код для Premium.',
          textAlign: TextAlign.center,
        ),
        actions: [
          if (!isPremium)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showCodeDialog();
              },
              child: const Text('Ввести код', style: TextStyle(color: Color(0xFFE8B4D9))),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Понятно', style: TextStyle(color: Color(0xFFE8B4D9))),
          ),
        ],
      ),
    );
  }

  void _showCodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Активация Premium', textAlign: TextAlign.center),
        content: SizedBox(
          width: double.maxFinite,
          child: ac.ActivationCodeField(
            onRedeem: (code) async {
              final r = await RuneCodeService.instance.redeem(code);
              if (r.ok) {
                await RuneCodeService.instance.applyCodeResult(r);
              }
              return r;
            },
            accentColor: const Color(0xFFE8B4D9),
            hintText: 'RUNA-PREMIUM-...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрыть', style: TextStyle(color: Color(0xFFE8B4D9))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
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
                  Row(
                    children: [
                      // Task 089: индикатор Premium + активация кода
                      ValueListenableBuilder<bool>(
                        valueListenable: PremiumService.instance.isPremium,
                        builder: (context, isPremium, _) {
                          return IconButton(
                            icon: Icon(
                              isPremium ? Icons.workspace_premium : Icons.lock_outline,
                              color: isPremium
                                  ? const Color(0xFFE8B4D9)
                                  : Colors.black26,
                            ),
                            onPressed: () => _showCodeDialog(),
                          );
                        },
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _showCollection
                  ? _buildCollection()
                  : (_todayRune == null ? _buildEmptyState() : _buildRuneCard()),
            ),
            if (!_showCollection)
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isDrawing ? null : _drawRune,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8B4D9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isDrawing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _todayRune == null ? 'ПОЛУЧИТЬ РУНУ' : 'НОВАЯ РУНА',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
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

  Widget _buildRuneCard() {
    final rune = _todayRune!;
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: rune.element == 'Огонь'
                      ? const Color(0xFFF4C2C2).withOpacity(0.4)
                      : rune.element == 'Вода'
                          ? const Color(0xFFC2E4F4).withOpacity(0.4)
                          : rune.element == 'Воздух'
                              ? const Color(0xFFC2D4F4).withOpacity(0.4)
                              : const Color(0xFFE8D5B7).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  rune.element.toUpperCase(),
                  style: TextStyle(
                    color: rune.element == 'Огонь'
                        ? const Color(0xFFE8A0A0)
                        : rune.element == 'Вода'
                            ? const Color(0xFFA8D4E8)
                            : rune.element == 'Воздух'
                                ? const Color(0xFFA8C4E8)
                                : const Color(0xFFD4B896),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: rune.gradient,
                  boxShadow: [
                    BoxShadow(
                      color: rune.element == 'Огонь'
                          ? const Color(0xFFF4C2C2).withOpacity(0.5)
                          : rune.element == 'Вода'
                              ? const Color(0xFFC2E4F4).withOpacity(0.5)
                              : rune.element == 'Воздух'
                                  ? const Color(0xFFC2D4F4).withOpacity(0.5)
                                  : const Color(0xFFE8D5B7).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    rune.icon,
                    size: 56,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                rune.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3B42),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rune.title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black45,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
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
                        fontSize: 15,
                        color: Color(0xFF5A4A52),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
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
                          const SizedBox(height: 8),
                          const Text(
                            'Совет дня',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE8B4D9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rune.advice,
                            style: const TextStyle(
                              fontSize: 14,
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
              const SizedBox(height: 32),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: allRunes.length,
      itemBuilder: (context, index) {
        final rune = allRunes[index];
        final isCollected = _collected.contains(rune.id);

        return Container(
          decoration: BoxDecoration(
            gradient: isCollected ? rune.gradient : null,
            color: isCollected ? null : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCollected
                  ? Colors.white.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                rune.icon,
                size: 28,
                color: isCollected ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.15),
              ),
              const SizedBox(height: 6),
              Text(
                rune.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isCollected ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
