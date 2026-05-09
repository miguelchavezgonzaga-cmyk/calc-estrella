import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      title: 'Calc Científica CETIS 131',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020C07),
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
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const CalculatorScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ));
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020C07),
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo con halo verde esmeralda
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E676).withOpacity(0.45),
                        blurRadius: 50,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00E676), width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo_cetis.jpg',
                        width: 154,
                        height: 154,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // Estilo terminal
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00E676), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '> CETIS_131',
                    style: TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Calculadora Científica',
                  style: TextStyle(
                    color: Color(0xFF80CBC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 40, height: 1, color: const Color(0xFF00E676).withOpacity(0.4)),
                    const SizedBox(width: 12),
                    const Text('★', style: TextStyle(color: Color(0xFF00E676), fontSize: 14)),
                    const SizedBox(width: 12),
                    Container(width: 40, height: 1, color: const Color(0xFF00E676).withOpacity(0.4)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Estrella Lizeth Escamilla Vargas',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 160,
                  child: LinearProgressIndicator(
                    backgroundColor: const Color(0xFF0A2010),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                    borderRadius: BorderRadius.circular(2),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
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
  double _secondOperand = 0;
  String _operator = '';
  bool _waitingForOperand = false;
  bool _isDeg = true;
  bool _isSecond = false;
  String _memory = '0';
  bool _hasResult = false;

  // Paleta verde esmeralda / terminal
  static const Color kBg      = Color(0xFF020C07);
  static const Color kCard    = Color(0xFF041209);
  static const Color kNum     = Color(0xFF071A0E);
  static const Color kFn      = Color(0xFF0A2015);
  static const Color kSci     = Color(0xFF051510);
  static const Color kAccent  = Color(0xFF00E676);
  static const Color kAccent2 = Color(0xFF69F0AE);
  static const Color kMuted   = Color(0xFF1B4332);

  double get _currentValue => double.tryParse(_display) ?? 0;
  double _toRad(double v) => _isDeg ? v * math.pi / 180 : v;
  double _toDeg(double v) => _isDeg ? v : v * 180 / math.pi;

  String _formatResult(double v) {
    if (v.isNaN) return 'Error';
    if (v.isInfinite) return v > 0 ? '∞' : '-∞';
    if (v == v.truncateToDouble() && v.abs() < 1e15) return v.toInt().toString();
    String s = v.toStringAsPrecision(10);
    if (s.contains('.') && !s.contains('e')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  void _onDigit(String d) {
    setState(() {
      if (_hasResult) { _display = d == '.' ? '0.' : d; _expression = ''; _hasResult = false; }
      else if (_waitingForOperand) { _display = d == '.' ? '0.' : d; _waitingForOperand = false; }
      else {
        if (d == '.' && _display.contains('.')) return;
        _display = _display == '0' && d != '.' ? d : _display + d;
      }
    });
  }

  void _onAC() => setState(() {
    _display = '0'; _expression = ''; _firstOperand = 0;
    _operator = ''; _waitingForOperand = false; _hasResult = false;
  });

  void _onPlusMinus() => setState(() => _display = _formatResult(_currentValue * -1));

  void _onPercent() {
    double v = _operator.isNotEmpty ? _firstOperand * _currentValue / 100 : _currentValue / 100;
    setState(() => _display = _formatResult(v));
  }

  void _onOperator(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_waitingForOperand) _calculate();
      _firstOperand = _currentValue;
      _operator = op; _waitingForOperand = true; _hasResult = false;
      _expression = '${_formatResult(_firstOperand)} $op';
    });
  }

  void _calculate() {
    if (_operator.isEmpty) return;
    _secondOperand = _currentValue;
    double result;
    switch (_operator) {
      case '+': result = _firstOperand + _secondOperand; break;
      case '−': result = _firstOperand - _secondOperand; break;
      case '×': result = _firstOperand * _secondOperand; break;
      case '÷': result = _secondOperand == 0 ? double.nan : _firstOperand / _secondOperand; break;
      case 'yˣ': result = math.pow(_firstOperand, _secondOperand).toDouble(); break;
      case 'ˣ√y': result = math.pow(_secondOperand, 1 / _firstOperand).toDouble(); break;
      case 'EE': result = _firstOperand * math.pow(10, _secondOperand).toDouble(); break;
      default: result = _secondOperand;
    }
    setState(() {
      _expression = '${_formatResult(_firstOperand)} $_operator ${_formatResult(_secondOperand)} =';
      _display = _formatResult(result);
      _operator = ''; _firstOperand = result;
      _waitingForOperand = true; _hasResult = true;
    });
  }

  void _onScientific(String fn) {
    double v = _currentValue;
    double result;
    switch (fn) {
      case 'sin': result = math.sin(_toRad(v)); break;
      case 'cos': result = math.cos(_toRad(v)); break;
      case 'tan': result = math.tan(_toRad(v)); break;
      case 'asin': result = _toDeg(math.asin(v)); break;
      case 'acos': result = _toDeg(math.acos(v)); break;
      case 'atan': result = _toDeg(math.atan(v)); break;
      case 'sinh': result = (math.exp(v) - math.exp(-v)) / 2; break;
      case 'cosh': result = (math.exp(v) + math.exp(-v)) / 2; break;
      case 'tanh': final e2x = math.exp(2 * v); result = (e2x - 1) / (e2x + 1); break;
      case 'log': result = v <= 0 ? double.nan : math.log(v) / math.ln10; break;
      case 'ln': result = v <= 0 ? double.nan : math.log(v); break;
      case 'log2': result = v <= 0 ? double.nan : math.log(v) / math.log(2); break;
      case '10ˣ': result = math.pow(10, v).toDouble(); break;
      case 'eˣ': result = math.exp(v); break;
      case '2ˣ': result = math.pow(2, v).toDouble(); break;
      case 'x²': result = v * v; break;
      case 'x³': result = v * v * v; break;
      case '√': result = v < 0 ? double.nan : math.sqrt(v); break;
      case '∛': result = math.pow(v.abs(), 1/3).toDouble() * (v < 0 ? -1 : 1); break;
      case '1/x': result = v == 0 ? double.nan : 1 / v; break;
      case 'x!': result = _factorial(v.toInt()).toDouble(); break;
      case 'π': result = math.pi; break;
      case 'e': result = math.e; break;
      case 'Rand': result = math.Random().nextDouble(); break;
      case 'abs': result = v.abs(); break;
      default: result = v;
    }
    setState(() { _display = _formatResult(result); _hasResult = true; _waitingForOperand = true; });
  }

  int _factorial(int n) {
    if (n < 0 || n > 20) return -1;
    int r = 1; for (int i = 2; i <= n; i++) r *= i; return r;
  }

  void _onMemory(String cmd) {
    setState(() {
      switch (cmd) {
        case 'MC': _memory = '0'; break;
        case 'MR': _display = _memory; _waitingForOperand = false; break;
        case 'M+': _memory = _formatResult((double.tryParse(_memory) ?? 0) + _currentValue); break;
        case 'M-': _memory = _formatResult((double.tryParse(_memory) ?? 0) - _currentValue); break;
        case 'MS': _memory = _display; break;
      }
    });
  }

  void _onBack() => setState(() {
    _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(child: isLandscape ? _buildLandscape() : _buildPortrait()),
    );
  }

  Widget _buildPortrait() => Column(children: [
    _buildHeader(), _buildDisplayPanel(),
    Container(height: 1, color: kMuted.withOpacity(0.3)),
    Expanded(child: _buildKeypad()),
  ]);

  Widget _buildLandscape() => Row(children: [
    Expanded(flex: 2, child: Column(children: [
      _buildHeader(compact: true), _buildDisplayPanel(compact: true),
      Expanded(child: _buildSciPad()),
    ])),
    Container(width: 1, color: kMuted.withOpacity(0.3)),
    Expanded(flex: 3, child: _buildKeypad(showSci: false)),
  ]);

  Widget _buildHeader({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: compact ? 5 : 9),
      color: kCard,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAccent, width: 1.5),
          ),
          child: ClipOval(
            child: Image.asset('assets/images/logo_cetis.jpg',
                width: compact ? 26 : 34, height: compact ? 26 : 34, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('> CETIS_131', style: TextStyle(
            color: kAccent, fontSize: compact ? 9 : 11,
            fontWeight: FontWeight.w700, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text('Estrella Lizeth Escamilla Vargas', style: TextStyle(
            color: const Color(0xFF556B55), fontSize: compact ? 7 : 8.5, letterSpacing: 0.3)),
        ]),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() => _isDeg = !_isDeg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isDeg ? kAccent.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _isDeg ? kAccent : kMuted, width: 1),
            ),
            child: Text(_isDeg ? 'DEG' : 'RAD', style: TextStyle(
              color: _isDeg ? kAccent : const Color(0xFF556B55),
              fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
          ),
        ),
      ]),
    );
  }

  Widget _buildDisplayPanel({bool compact = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: compact ? 10 : 18),
      color: kCard,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(_expression,
            style: const TextStyle(color: Color(0xFF2D5A2D), fontSize: 13, fontFamily: 'monospace'),
            textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(_display, style: TextStyle(
            color: kAccent2,
            fontSize: compact ? 42 : 60,
            fontWeight: FontWeight.w300,
            letterSpacing: -1,
            fontFamily: 'monospace',
          )),
        ),
        if (_memory != '0')
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kAccent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: kAccent.withOpacity(0.3), width: 0.5),
              ),
              child: Text('MEM: $_memory',
                  style: const TextStyle(color: Color(0xFF00E676), fontSize: 9, fontFamily: 'monospace')),
            ),
          ),
      ]),
    );
  }

  Widget _buildKeypad({bool showSci = true}) {
    return Column(children: [
      if (showSci) ...[
        _sciRow1(), _sciRow2(), _sciRow3(), _sciRow4(), _memRow(),
      ],
      Expanded(child: Column(children: [
        _row([
          _btn('AC', _onAC, t: T.fn),
          _btn(_display == '0' ? 'AC' : '⌫', () { if (_display != '0') _onBack(); else _onAC(); }, t: T.fn),
          _btn('%', _onPercent, t: T.fn),
          _btn('÷', () => _onOperator('÷'), t: T.op),
        ]),
        _row([
          _btn('7', () => _onDigit('7')), _btn('8', () => _onDigit('8')),
          _btn('9', () => _onDigit('9')), _btn('×', () => _onOperator('×'), t: T.op),
        ]),
        _row([
          _btn('4', () => _onDigit('4')), _btn('5', () => _onDigit('5')),
          _btn('6', () => _onDigit('6')), _btn('−', () => _onOperator('−'), t: T.op),
        ]),
        _row([
          _btn('1', () => _onDigit('1')), _btn('2', () => _onDigit('2')),
          _btn('3', () => _onDigit('3')), _btn('+', () => _onOperator('+'), t: T.op),
        ]),
        _row([
          _btn('+/−', _onPlusMinus), _btn('0', () => _onDigit('0')),
          _btn('.', () => _onDigit('.')), _btn('=', _calculate, t: T.eq),
        ]),
      ])),
    ]);
  }

  Widget _sciRow1() => _row([
    _btn(_isSecond ? 'sin⁻¹':'sin', () => _onScientific(_isSecond ? 'asin':'sin'), t: T.sci),
    _btn(_isSecond ? 'cos⁻¹':'cos', () => _onScientific(_isSecond ? 'acos':'cos'), t: T.sci),
    _btn(_isSecond ? 'tan⁻¹':'tan', () => _onScientific(_isSecond ? 'atan':'tan'), t: T.sci),
    _btn('sinh', () => _onScientific('sinh'), t: T.sci),
    _btn('cosh', () => _onScientific('cosh'), t: T.sci),
  ]);
  Widget _sciRow2() => _row([
    _btn(_isSecond ? '10ˣ':'log', () => _onScientific(_isSecond ? '10ˣ':'log'), t: T.sci),
    _btn(_isSecond ? 'eˣ':'ln', () => _onScientific(_isSecond ? 'eˣ':'ln'), t: T.sci),
    _btn(_isSecond ? '2ˣ':'log₂', () => _onScientific(_isSecond ? '2ˣ':'log2'), t: T.sci),
    _btn('π', () => _onScientific('π'), t: T.sci),
    _btn('e', () => _onScientific('e'), t: T.sci),
  ]);
  Widget _sciRow3() => _row([
    _btn(_isSecond ? 'x³':'x²', () => _onScientific(_isSecond ? 'x³':'x²'), t: T.sci),
    _btn(_isSecond ? '∛':'√', () => _onScientific(_isSecond ? '∛':'√'), t: T.sci),
    _btn('yˣ', () => _onOperator('yˣ'), t: T.sci),
    _btn('ˣ√y', () => _onOperator('ˣ√y'), t: T.sci),
    _btn('1/x', () => _onScientific('1/x'), t: T.sci),
  ]);
  Widget _sciRow4() => _row([
    _btn('2nd', () => setState(() => _isSecond = !_isSecond), t: _isSecond ? T.op : T.sci),
    _btn('x!', () => _onScientific('x!'), t: T.sci),
    _btn('abs', () => _onScientific('abs'), t: T.sci),
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
  Widget _buildSciPad() => Column(children: [_sciRow1(), _sciRow2(), _sciRow3(), _sciRow4(), _memRow()]);

  Widget _row(List<Widget> btns) =>
      Expanded(child: Row(children: btns.map((b) => Expanded(child: b)).toList()));

  Widget _btn(String label, VoidCallback onTap, {T t = T.num}) {
    Color bg; Color fg; Color? border;
    switch (t) {
      case T.fn:  bg = kFn;   fg = kAccent2;  border = kMuted.withOpacity(0.4); break;
      case T.op:  bg = kAccent.withOpacity(0.15); fg = kAccent; border = kAccent.withOpacity(0.5); break;
      case T.eq:  bg = kAccent; fg = Colors.black; border = null; break;
      case T.sci: bg = kSci;  fg = const Color(0xFF4CAF50); border = kMuted.withOpacity(0.25); break;
      case T.num: bg = kNum;  fg = Colors.white; border = null; break;
    }
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: border != null ? Border.all(color: border, width: 0.5) : null,
          boxShadow: t == T.eq ? [BoxShadow(color: kAccent.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 3))] : null,
        ),
        child: Center(
          child: Text(label, style: TextStyle(
            color: fg,
            fontSize: label.length > 5 ? 10 : label.length > 3 ? 12 : 15,
            fontWeight: t == T.eq ? FontWeight.w800 : FontWeight.w500,
            fontFamily: t == T.sci || t == T.fn ? 'monospace' : null,
          )),
        ),
      ),
    );
  }
}

enum T { num, fn, op, eq, sci }
