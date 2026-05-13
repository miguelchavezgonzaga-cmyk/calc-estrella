import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Paleta azul marino + dorado — aspecto profesional y refinado.
abstract final class AppColors {
  static const Color navyDeep = Color(0xFF050A14);
  static const Color navy = Color(0xFF0C1829);
  static const Color navyCard = Color(0xFF142338);
  static const Color navyElevated = Color(0xFF1C2F4A);
  static const Color navySoft = Color(0xFF243B5C);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldBright = Color(0xFFE8C547);
  static const Color goldDeep = Color(0xFFB8941E);
  static const Color cream = Color(0xFFF8F0DC);
  static const Color blush = Color(0xFFF5E6E8);
  static const Color textMuted = Color(0xFF8FA3BF);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const CalcApp());
}

class CalcApp extends StatelessWidget {
  const CalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora CETIS 131',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.navyDeep,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          surface: AppColors.navy,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  SPLASH
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _intro;
  late AnimationController _pulse;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _ringGlow;

  static const _authorName = 'Valentina Carrizales Flores';

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _intro, curve: Curves.easeOutBack),
    );
    _ringGlow = Tween<double>(begin: 0.85, end: 1.08).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );

    _intro.forward();

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const CalculatorScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ));
    });
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.35, -0.55),
            radius: 1.35,
            colors: [
              Color(0xFF1A3052),
              AppColors.navyDeep,
              Color(0xFF03060C),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([_intro, _pulse]),
          builder: (context, _) {
            return FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: _ringGlow.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withValues(alpha: 0.35),
                                  blurRadius: 36,
                                  spreadRadius: 4,
                                ),
                                BoxShadow(
                                  color: AppColors.goldBright.withValues(alpha: 0.12),
                                  blurRadius: 60,
                                  spreadRadius: 12,
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.goldBright,
                                    AppColors.gold,
                                    AppColors.goldDeep,
                                  ],
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.navyDeep,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/logo_cetis.jpg',
                                    width: 148,
                                    height: 148,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                            color: AppColors.navyCard.withValues(alpha: 0.65),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'CETIS 131',
                                style: TextStyle(
                                  color: AppColors.goldBright,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 6,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Calculadora científica',
                                style: TextStyle(
                                  color: AppColors.cream.withValues(alpha: 0.85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.gold.withValues(alpha: 0.5),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: AppColors.gold.withValues(alpha: 0.8),
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.gold.withValues(alpha: 0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          _authorName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blush.withValues(alpha: 0.92),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 44),
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              backgroundColor:
                                  AppColors.navyElevated.withValues(alpha: 0.9),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.gold),
                              minHeight: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CALCULADORA
// ─────────────────────────────────────────────
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _waitingForOperand = false;
  bool _isDeg = true;
  bool _isSecond = false;
  String _memory = '0';
  bool _hasResult = false;

  static const Color kBg = AppColors.navyDeep;
  static const Color kCard = AppColors.navyCard;
  static const Color kNum = AppColors.navyElevated;
  static const Color kFn = Color(0xFF162A45);
  static const Color kSci = Color(0xFF132038);
  static const Color kAccent = AppColors.gold;
  static const Color kAccent2 = AppColors.cream;
  static const Color kMuted = AppColors.navySoft;

  double get _currentValue => double.tryParse(_display) ?? 0;

  double _toRad(double v) => _isDeg ? v * math.pi / 180 : v;

  double _toDeg(double v) => _isDeg ? v : v * 180 / math.pi;

  /// Evalúa operaciones binarias sin tocar el estado (evita setState anidado).
  double _evalBinary(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '−':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? double.nan : a / b;
      case 'yˣ':
        return math.pow(a, b).toDouble();
      case 'ˣ√y':
        if (a == 0) return double.nan;
        return math.pow(b, 1 / a).toDouble();
      case 'EE':
        return a * math.pow(10, b).toDouble();
      case 'mod':
        return b == 0 ? double.nan : a % b;
      default:
        return b;
    }
  }

  String _formatResult(double v) {
    if (v.isNaN) return 'Error';
    if (v.isInfinite) return v > 0 ? '∞' : '-∞';
    final av = v.abs();
    if (v != 0 && (av >= 1e12 || av < 1e-9)) {
      String s = v.toStringAsExponential(8);
      s = s.replaceAll(RegExp(r'0+e'), 'e').replaceAll(RegExp(r'\.e'), 'e');
      return s;
    }
    if (v == v.truncateToDouble() && v.abs() < 1e15) return v.toInt().toString();
    String s = v.toStringAsPrecision(12);
    if (s.contains('.') && !s.contains('e')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  bool get _displayIsSpecial =>
      _display == 'Error' || _display == '∞' || _display == '-∞';

  void _onDigit(String d) {
    setState(() {
      if (_displayIsSpecial) {
        _display = d == '.' ? '0.' : d;
        _expression = '';
        _hasResult = false;
        _waitingForOperand = false;
        return;
      }
      if (_hasResult) {
        _display = d == '.' ? '0.' : d;
        _expression = '';
        _hasResult = false;
      } else if (_waitingForOperand) {
        _display = d == '.' ? '0.' : d;
        _waitingForOperand = false;
      } else {
        if (d == '.' && _display.contains('.')) return;
        _display = _display == '0' && d != '.' ? d : _display + d;
      }
    });
  }

  void _onAC() => setState(() {
        _display = '0';
        _expression = '';
        _firstOperand = 0;
        _operator = '';
        _waitingForOperand = false;
        _hasResult = false;
      });

  void _onCE() => setState(() {
        _display = '0';
        _hasResult = false;
      });

  void _onPlusMinus() {
    if (_displayIsSpecial) return;
    setState(() => _display = _formatResult(_currentValue * -1));
  }

  void _onPercent() {
    if (_displayIsSpecial) return;
    final v = _operator.isNotEmpty
        ? _firstOperand * _currentValue / 100
        : _currentValue / 100;
    setState(() => _display = _formatResult(v));
  }

  void _onOperator(String op) {
    if (_displayIsSpecial) return;
    setState(() {
      double nextLeft = _currentValue;
      if (_operator.isNotEmpty && !_waitingForOperand) {
        final res = _evalBinary(_firstOperand, _currentValue, _operator);
        nextLeft = res;
        _display = _formatResult(res);
      }
      _firstOperand = nextLeft;
      _operator = op;
      _waitingForOperand = true;
      _hasResult = false;
      _expression = '${_formatResult(_firstOperand)} $op';
    });
  }

  void _calculate() {
    if (_operator.isEmpty || _displayIsSpecial) return;
    final second = _currentValue;
    final res = _evalBinary(_firstOperand, second, _operator);
    setState(() {
      _expression =
          '${_formatResult(_firstOperand)} $_operator ${_formatResult(second)} =';
      _display = _formatResult(res);
      _operator = '';
      _firstOperand = res;
      _waitingForOperand = true;
      _hasResult = true;
    });
  }

  void _onScientific(String fn) {
    if (_displayIsSpecial &&
        fn != 'π' &&
        fn != 'e' &&
        fn != 'Rand') {
      return;
    }
    final v = _currentValue;
    double result;
    switch (fn) {
      case 'sin':
        result = math.sin(_toRad(v));
        break;
      case 'cos':
        result = math.cos(_toRad(v));
        break;
      case 'tan':
        result = math.tan(_toRad(v));
        break;
      case 'asin':
        result = _toDeg(math.asin(v));
        break;
      case 'acos':
        result = _toDeg(math.acos(v));
        break;
      case 'atan':
        result = _toDeg(math.atan(v));
        break;
      case 'sinh':
        result = (math.exp(v) - math.exp(-v)) / 2;
        break;
      case 'cosh':
        result = (math.exp(v) + math.exp(-v)) / 2;
        break;
      case 'tanh':
        final e2x = math.exp(2 * v);
        result = (e2x - 1) / (e2x + 1);
        break;
      case 'asinh':
        result = math.log(v + math.sqrt(v * v + 1));
        break;
      case 'acosh':
        result = v < 1 ? double.nan : math.log(v + math.sqrt(v * v - 1));
        break;
      case 'atanh':
        result =
            v.abs() >= 1 ? double.nan : 0.5 * math.log((1 + v) / (1 - v));
        break;
      case 'log':
        result = v <= 0 ? double.nan : math.log(v) / math.ln10;
        break;
      case 'ln':
        result = v <= 0 ? double.nan : math.log(v);
        break;
      case 'log2':
        result = v <= 0 ? double.nan : math.log(v) / math.log(2);
        break;
      case '10ˣ':
        result = math.pow(10, v).toDouble();
        break;
      case 'eˣ':
        result = math.exp(v);
        break;
      case '2ˣ':
        result = math.pow(2, v).toDouble();
        break;
      case 'x²':
        result = v * v;
        break;
      case 'x³':
        result = v * v * v;
        break;
      case '√':
        result = v < 0 ? double.nan : math.sqrt(v);
        break;
      case '∛':
        result =
            math.pow(v.abs(), 1 / 3).toDouble() * (v < 0 ? -1 : 1);
        break;
      case '1/x':
        result = v == 0 ? double.nan : 1 / v;
        break;
      case 'x!':
        if (v < 0 || v > 170 || v != v.truncateToDouble()) {
          result = double.nan;
        } else {
          final n = v.toInt();
          result = 1;
          for (var i = 2; i <= n; i++) {
            result *= i;
          }
        }
        break;
      case 'π':
        result = math.pi;
        break;
      case 'e':
        result = math.e;
        break;
      case 'Rand':
        result = math.Random().nextDouble();
        break;
      case 'abs':
        result = v.abs();
        break;
      default:
        result = v;
    }
    setState(() {
      _display = _formatResult(result);
      _hasResult = true;
      _waitingForOperand = true;
    });
  }

  void _onMemory(String cmd) {
    setState(() {
      switch (cmd) {
        case 'MC':
          _memory = '0';
          break;
        case 'MR':
          final m = double.tryParse(_memory);
          if (m != null) {
            _display = _formatResult(m);
            _waitingForOperand = false;
            _hasResult = false;
          }
          break;
        case 'M+':
          if (!_displayIsSpecial) {
            final base = double.tryParse(_memory) ?? 0;
            _memory = _formatResult(base + _currentValue);
          }
          break;
        case 'M-':
          if (!_displayIsSpecial) {
            final base = double.tryParse(_memory) ?? 0;
            _memory = _formatResult(base - _currentValue);
          }
          break;
        case 'MS':
          if (!_displayIsSpecial) {
            _memory = _display;
          }
          break;
      }
    });
  }

  void _onBack() => setState(() {
        if (_displayIsSpecial) {
          _display = '0';
          return;
        }
        _display =
            _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
      });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
          child: isLandscape ? _buildLandscape() : _buildPortrait()),
    );
  }

  Widget _buildPortrait() => Column(children: [
        _buildHeader(),
        _buildDisplayPanel(),
        Container(height: 1, color: kMuted.withValues(alpha: 0.35)),
        Expanded(child: _buildKeypad()),
      ]);

  Widget _buildLandscape() => Row(children: [
        Expanded(
            flex: 2,
            child: Column(children: [
              _buildHeader(compact: true),
              _buildDisplayPanel(compact: true),
              Expanded(child: _buildSciPad()),
            ])),
        Container(width: 1, color: kMuted.withValues(alpha: 0.35)),
        Expanded(flex: 3, child: _buildKeypad(showSci: false)),
      ]);

  Widget _buildHeader({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: compact ? 6 : 10),
      decoration: BoxDecoration(
        color: kCard,
        border: Border(
          bottom: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAccent, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.15),
                blurRadius: compact ? 6 : 10,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo_cetis.jpg',
              width: compact ? 28 : 36,
              height: compact ? 28 : 36,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CETIS 131',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kAccent,
                  fontSize: compact ? 11 : 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Valentina Carrizales Flores',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: compact ? 8 : 10,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: _onAC,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kMuted.withValues(alpha: 0.8)),
              color: kFn.withValues(alpha: 0.6),
            ),
            child: Text(
              'AC',
              style: TextStyle(
                color: kAccent2.withValues(alpha: 0.95),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _isDeg = !_isDeg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _isDeg
                  ? AppColors.gold.withValues(alpha: 0.14)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isDeg ? kAccent : kMuted,
                width: 1,
              ),
            ),
            child: Text(
              _isDeg ? 'DEG' : 'RAD',
              style: TextStyle(
                color:
                    _isDeg ? kAccent : AppColors.textMuted.withValues(alpha: 0.85),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildDisplayPanel({bool compact = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: compact ? 12 : 20),
      color: kCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _expression,
            style: TextStyle(
              color: AppColors.textMuted.withValues(alpha: 0.65),
              fontSize: 13,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(
                color: kAccent2,
                fontSize: compact ? 44 : 58,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.5,
                fontFamily: 'monospace',
              ),
            ),
          ),
          if (_memory != '0')
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.28),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'MEM: $_memory',
                  style: const TextStyle(
                    color: AppColors.goldBright,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeypad({bool showSci = true}) {
    return Column(children: [
      if (showSci) ...[
        _sciRow1(),
        _sciRow2(),
        _sciRow3(),
        _sciRow4(),
        _memRow(),
      ],
      Expanded(
          child: Column(children: [
        _row([
          _btn('CE', _onCE, t: T.fn),
          _btn('⌫', _onBack, t: T.fn),
          _btn('%', _onPercent, t: T.fn),
          _btn('÷', () => _onOperator('÷'), t: T.op),
        ]),
        _row([
          _btn('7', () => _onDigit('7')),
          _btn('8', () => _onDigit('8')),
          _btn('9', () => _onDigit('9')),
          _btn('×', () => _onOperator('×'), t: T.op),
        ]),
        _row([
          _btn('4', () => _onDigit('4')),
          _btn('5', () => _onDigit('5')),
          _btn('6', () => _onDigit('6')),
          _btn('−', () => _onOperator('−'), t: T.op),
        ]),
        _row([
          _btn('1', () => _onDigit('1')),
          _btn('2', () => _onDigit('2')),
          _btn('3', () => _onDigit('3')),
          _btn('+', () => _onOperator('+'), t: T.op),
        ]),
        _row([
          _btn('+/−', _onPlusMinus),
          _btn('0', () => _onDigit('0')),
          _btn('.', () => _onDigit('.')),
          _btn('=', _calculate, t: T.eq),
        ]),
      ])),
    ]);
  }

  Widget _sciRow1() => _row([
        _btn(_isSecond ? 'sin⁻¹' : 'sin',
            () => _onScientific(_isSecond ? 'asin' : 'sin'),
            t: T.sci),
        _btn(_isSecond ? 'cos⁻¹' : 'cos',
            () => _onScientific(_isSecond ? 'acos' : 'cos'),
            t: T.sci),
        _btn(_isSecond ? 'tan⁻¹' : 'tan',
            () => _onScientific(_isSecond ? 'atan' : 'tan'),
            t: T.sci),
        _btn(_isSecond ? 'sinh⁻¹' : 'sinh',
            () => _onScientific(_isSecond ? 'asinh' : 'sinh'),
            t: T.sci),
        _btn(_isSecond ? 'cosh⁻¹' : 'cosh',
            () => _onScientific(_isSecond ? 'acosh' : 'cosh'),
            t: T.sci),
        _btn(_isSecond ? 'tanh⁻¹' : 'tanh',
            () => _onScientific(_isSecond ? 'atanh' : 'tanh'),
            t: T.sci),
      ]);

  Widget _sciRow2() => _row([
        _btn(_isSecond ? '10ˣ' : 'log',
            () => _onScientific(_isSecond ? '10ˣ' : 'log'),
            t: T.sci),
        _btn(_isSecond ? 'eˣ' : 'ln',
            () => _onScientific(_isSecond ? 'eˣ' : 'ln'),
            t: T.sci),
        _btn(_isSecond ? '2ˣ' : 'log₂',
            () => _onScientific(_isSecond ? '2ˣ' : 'log2'),
            t: T.sci),
        _btn('π', () => _onScientific('π'), t: T.sci),
        _btn('e', () => _onScientific('e'), t: T.sci),
      ]);

  Widget _sciRow3() => _row([
        _btn(_isSecond ? 'x³' : 'x²',
            () => _onScientific(_isSecond ? 'x³' : 'x²'),
            t: T.sci),
        _btn(_isSecond ? '∛' : '√',
            () => _onScientific(_isSecond ? '∛' : '√'),
            t: T.sci),
        _btn('abs', () => _onScientific('abs'), t: T.sci),
        _btn('yˣ', () => _onOperator('yˣ'), t: T.sci),
        _btn('ˣ√y', () => _onOperator('ˣ√y'), t: T.sci),
        _btn('1/x', () => _onScientific('1/x'), t: T.sci),
      ]);

  Widget _sciRow4() => _row([
        _btn(
          '2nd',
          () => setState(() => _isSecond = !_isSecond),
          t: _isSecond ? T.op : T.sci,
        ),
        _btn('x!', () => _onScientific('x!'), t: T.sci),
        _btn('mod', () => _onOperator('mod'), t: T.sci),
        _btn('EE', () => _onOperator('EE'), t: T.sci),
        _btn('Rand', () => _onScientific('Rand'), t: T.sci),
      ]);

  Widget _memRow() => _row([
        _btn('MC', () => _onMemory('MC'), t: T.sci),
        _btn('MR', () => _onMemory('MR'), t: T.sci),
        _btn('M+', () => _onMemory('M+'), t: T.sci),
        _btn('M-', () => _onMemory('M-'), t: T.sci),
        _btn('MS', () => _onMemory('MS'), t: T.sci),
      ]);

  Widget _buildSciPad() =>
      Column(children: [_sciRow1(), _sciRow2(), _sciRow3(), _sciRow4(), _memRow()]);

  Widget _row(List<Widget> btns) =>
      Expanded(child: Row(children: btns.map((b) => Expanded(child: b)).toList()));

  Widget _btn(String label, VoidCallback onTap, {T t = T.num}) {
    Color bg;
    Color fg;
    Color? border;
    switch (t) {
      case T.fn:
        bg = kFn;
        fg = kAccent2;
        border = kMuted.withValues(alpha: 0.45);
        break;
      case T.op:
        bg = AppColors.gold.withValues(alpha: 0.12);
        fg = kAccent;
        border = AppColors.gold.withValues(alpha: 0.35);
        break;
      case T.eq:
        bg = kAccent;
        fg = AppColors.navyDeep;
        border = null;
        break;
      case T.sci:
        bg = kSci;
        fg = AppColors.goldBright.withValues(alpha: 0.88);
        border = kMuted.withValues(alpha: 0.3);
        break;
      case T.num:
        bg = kNum;
        fg = Colors.white;
        border = null;
        break;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: border != null ? Border.all(color: border, width: 0.5) : null,
            boxShadow: t == T.eq
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: label.length > 5 ? 9.5 : label.length > 3 ? 11.5 : 15,
                fontWeight: t == T.eq ? FontWeight.w800 : FontWeight.w600,
                fontFamily: t == T.sci || t == T.fn ? 'monospace' : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum T { num, fn, op, eq, sci }
