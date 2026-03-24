import 'dart:math' as math;
import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════
//  SET GOALS PAGE
//  Deep emerald + gold — focus, ambition, momentum
// ══════════════════════════════════════════════════════════

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const SetGoalsPage(),
  );
}

// ─── Palette ──────────────────────────────────────────────
const _bg = Color(0xFF060F0A);
const _surface = Color(0xFF0E1F14);
const _card = Color(0xFF122018);
const _emerald = Color(0xFF2ECC71);
const _gold = Color(0xFFE8C87A);
const _teal = Color(0xFF00BFA5);
const _textPri = Color(0xFFE8F5E9);
const _textSec = Color(0xFF6B8F71);

// ─── Models ───────────────────────────────────────────────
class _Goal {
  String title;
  String category;
  double progress; // 0.0 – 1.0
  String deadline;
  Color color;
  String icon;
  _Goal({
    required this.title,
    required this.category,
    required this.progress,
    required this.deadline,
    required this.color,
    required this.icon,
  });
}

// ─── Page ─────────────────────────────────────────────────
class SetGoalsPage extends StatefulWidget {
  const SetGoalsPage({super.key});
  @override
  State<SetGoalsPage> createState() => _SetGoalsPageState();
}

class _SetGoalsPageState extends State<SetGoalsPage>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _ringCtrl;
  late AnimationController _pulseCtrl;

  final List<_Goal> _goals = [
    _Goal(title: 'Run 100km this month', category: 'Fitness', progress: 0.62, deadline: 'Jun 30', color: _emerald, icon: '🏃'),
    _Goal(title: 'Read 12 books', category: 'Learning', progress: 0.41, deadline: 'Dec 31', color: _gold, icon: '📖'),
    _Goal(title: 'Save \$5,000', category: 'Finance', progress: 0.75, deadline: 'Sep 01', color: _teal, icon: '💰'),
    _Goal(title: 'Ship side project', category: 'Career', progress: 0.28, deadline: 'Jul 15', color: const Color(0xFFAB87FF), icon: '🚀'),
  ];

  bool _showAddSheet = false;
  final _titleCtrl = TextEditingController();
  String _newCategory = 'Fitness';

  double get _overallProgress =>
      _goals.fold(0.0, (s, g) => s + g.progress) / _goals.length;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _ringCtrl.dispose();
    _pulseCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Ambient glow
          Positioned(top: -60, right: -60,
              child: Container(width: 280, height: 280,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [_emerald.withOpacity(0.08), Colors.transparent])))),
          Positioned(bottom: 100, left: -80,
              child: Container(width: 240, height: 240,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [_teal.withOpacity(0.07), Colors.transparent])))),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App Bar ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _textSec.withOpacity(0.2)),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, color: _textPri, size: 16),
                          ),
                        ),
                        const Spacer(),
                        const Text('My Goals', style: TextStyle(color: _textPri, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _showAddSheet = true),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _emerald.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _emerald.withOpacity(0.4)),
                            ),
                            child: const Icon(Icons.add, color: _emerald, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Overall Ring ──
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.0, 0.5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: _OverallRing(
                          progress: _overallProgress,
                          ringCtrl: _ringCtrl,
                          pulseCtrl: _pulseCtrl,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Section Title ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Row(
                      children: [
                        Container(width: 3, height: 18, decoration: BoxDecoration(color: _emerald, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 10),
                        const Text('Active Goals', style: TextStyle(color: _textPri, fontSize: 16, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('${_goals.length} goals', style: TextStyle(color: _textSec, fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                // ── Goal Cards ──
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                        final delay = 0.3 + i * 0.12;
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _entryCtrl,
                            curve: Interval(delay.clamp(0.0, 1.0), (delay + 0.35).clamp(0.0, 1.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _GoalCard(
                              goal: _goals[i],
                              onProgressChanged: (v) => setState(() => _goals[i].progress = v),
                            ),
                          ),
                        );
                      },
                      childCount: _goals.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // Add Goal Sheet
          if (_showAddSheet)
            _AddGoalSheet(
              titleCtrl: _titleCtrl,
              category: _newCategory,
              onCategoryChanged: (c) => setState(() => _newCategory = c),
              onClose: () => setState(() => _showAddSheet = false),
              onAdd: () {
                if (_titleCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _goals.add(_Goal(
                      title: _titleCtrl.text.trim(),
                      category: _newCategory,
                      progress: 0.0,
                      deadline: 'TBD',
                      color: [_emerald, _gold, _teal, const Color(0xFFAB87FF)][_goals.length % 4],
                      icon: ['🎯', '💡', '⚡', '🌟'][_goals.length % 4],
                    ));
                    _titleCtrl.clear();
                    _showAddSheet = false;
                  });
                }
              },
            ),
        ],
      ),
    );
  }
}

// ─── Overall Ring Widget ──────────────────────────────────
class _OverallRing extends StatelessWidget {
  final double progress;
  final AnimationController ringCtrl;
  final AnimationController pulseCtrl;
  const _OverallRing({required this.progress, required this.ringCtrl, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ringCtrl, pulseCtrl]),
      builder: (_, __) {
        final animProg = Tween(begin: 0.0, end: progress)
            .animate(CurvedAnimation(parent: ringCtrl, curve: Curves.easeOutCubic))
            .value;
        return SizedBox(
          width: 190,
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow pulse
              Transform.scale(
                scale: 1.0 + 0.04 * pulseCtrl.value,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: _emerald.withOpacity(0.1 + 0.05 * pulseCtrl.value), blurRadius: 40, spreadRadius: 10)],
                  ),
                ),
              ),
              // Ring
              CustomPaint(
                size: const Size(190, 190),
                painter: _RingPainter(animProg),
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${(animProg * 100).round()}%',
                      style: const TextStyle(color: _textPri, fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1)),
                  const SizedBox(height: 4),
                  const Text('Overall Progress', style: TextStyle(color: _textSec, fontSize: 12, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeW = 14.0;

    // Track
    canvas.drawCircle(center, radius, Paint()
      ..color = _surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW);

    // Arc
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [_emerald, _teal, _gold],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );

    // Dot at tip
    if (progress > 0.02) {
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final dotPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(dotPos, 7, Paint()..color = _gold);
      canvas.drawCircle(dotPos, 4, Paint()..color = _bg);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ─── Goal Card ────────────────────────────────────────────
class _GoalCard extends StatefulWidget {
  final _Goal goal;
  final ValueChanged<double> onProgressChanged;
  const _GoalCard({required this.goal, required this.onProgressChanged});

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard> with SingleTickerProviderStateMixin {
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = Tween(begin: 0.0, end: widget.goal.progress)
        .animate(CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 400), () => _barCtrl.forward());
  }

  @override
  void dispose() { _barCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.goal.color.withOpacity(_expanded ? 0.5 : 0.15), width: 1),
          boxShadow: [BoxShadow(color: widget.goal.color.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.goal.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.goal.title,
                          style: const TextStyle(color: _textPri, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.goal.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(widget.goal.category,
                              style: TextStyle(color: widget.goal.color, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Text('📅 ${widget.goal.deadline}', style: const TextStyle(color: _textSec, fontSize: 10)),
                      ]),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${(widget.goal.progress * 100).round()}%',
                        style: TextStyle(color: widget.goal.color, fontSize: 16, fontWeight: FontWeight.w800)),
                    Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _textSec, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Progress bar
            AnimatedBuilder(
              animation: _barAnim,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    Container(height: 6, color: _surface),
                    FractionallySizedBox(
                      widthFactor: _barAnim.value,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(colors: [widget.goal.color.withOpacity(0.7), widget.goal.color]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Slider on expand
            if (_expanded) ...[
              const SizedBox(height: 14),
              Row(children: [
                const Text('Update progress:', style: TextStyle(color: _textSec, fontSize: 12)),
                const Spacer(),
                Text('${(widget.goal.progress * 100).round()}%', style: TextStyle(color: widget.goal.color, fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: widget.goal.color,
                  inactiveTrackColor: _surface,
                  thumbColor: widget.goal.color,
                  overlayColor: widget.goal.color.withOpacity(0.1),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: widget.goal.progress,
                  onChanged: widget.onProgressChanged,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Add Goal Sheet ───────────────────────────────────────
class _AddGoalSheet extends StatelessWidget {
  final TextEditingController titleCtrl;
  final String category;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onClose;
  final VoidCallback onAdd;

  const _AddGoalSheet({
    required this.titleCtrl, required this.category,
    required this.onCategoryChanged, required this.onClose, required this.onAdd,
  });

  static const _cats = ['Fitness', 'Learning', 'Finance', 'Career', 'Health', 'Personal'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black54,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('New Goal', style: TextStyle(color: _textPri, fontSize: 20, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    GestureDetector(onTap: onClose,
                        child: const Icon(Icons.close, color: _textSec)),
                  ]),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: _textPri),
                    cursorColor: _emerald,
                    decoration: InputDecoration(
                      hintText: 'What do you want to achieve?',
                      hintStyle: TextStyle(color: _textSec.withOpacity(0.6)),
                      filled: true, fillColor: _card,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _emerald, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _cats.map((c) => GestureDetector(
                      onTap: () => onCategoryChanged(c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: category == c ? _emerald.withOpacity(0.18) : _card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: category == c ? _emerald : _textSec.withOpacity(0.2)),
                        ),
                        child: Text(c, style: TextStyle(color: category == c ? _emerald : _textSec, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(colors: [_emerald, _teal]),
                        boxShadow: [BoxShadow(color: _emerald.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: const Center(child: Text('Add Goal', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800))),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
