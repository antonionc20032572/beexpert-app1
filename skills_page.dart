import 'package:flutter/material.dart';
import 'main.dart'; // kTeal, kOrange, AppTabs

// ---------- Hover wrapper (for mouse). On mobile it behaves like normal tap. ----------
class _HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final VoidCallback? onTap;
  final MouseCursor cursor;
  const _HoverScale({
    required this.child,
    this.scale = 1.03,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final w = AnimatedScale(
      scale: _hover ? widget.scale : 1,
      duration: const Duration(milliseconds: 110),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: widget.onTap, child: widget.child),
      ),
    );
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.cursor,
      child: w,
    );
  }
}

// ---------- Data models ----------
enum TabKind { ongoing, upcoming, completed }
enum ModuleStatus { ongoing, upcoming, completed, locked }

class Task {
  final String title;
  int points;        // mutable for demo progress
  final int outOf;
  Task(this.title, this.points, this.outOf);
}

class Subject {
  final String title;
  final bool completed;
  final bool locked;
  final String? unlockHint; // shown when locked
  Subject.completed(this.title)
      : completed = true, locked = false, unlockHint = null;
  Subject.locked(this.title, this.unlockHint)
      : completed = false, locked = true;
}

class Module {
  final String title;
  final int minutes;
  ModuleStatus status;
  final int? prerequisiteIndex; // gating by previous module index
  Module(this.title, this.minutes, this.status, {this.prerequisiteIndex});
}

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  // Header stats (match your Figma)
  final int pts = 10, outOf = 20, week = 2;

  // Segmented control state
  TabKind tab = TabKind.ongoing;

  // Ongoing tasks (match your labels)
  final tasks = <Task>[
    Task('Launch Virtual Machine', 3, 5),
    Task('Set Up A Cloud Storage Services', 2, 5),
    Task('Explore Cloud Security Basics', 0, 5),
  ];

  // Learning modules list (unlock logic demo)
  final List<Module> modules = [
    Module('Intro to Cloud Functions', 25, ModuleStatus.completed),
    Module('Launch Virtual Machine', 35, ModuleStatus.ongoing),
    Module('Set Up Cloud Storage', 40, ModuleStatus.locked, prerequisiteIndex: 1),
    Module('Explore Cloud Security Basics', 30, ModuleStatus.locked, prerequisiteIndex: 2),
  ];

  // Subjects grid (bottom section)
  final subjects = <Subject>[
    Subject.completed('User Experience'),
    Subject.completed('Data Analytics'),
    Subject.locked('Project Management', 'Finish Cloud Computing to unlock'),
    Subject.locked('My SQL', 'Finish Project Management to unlock'),
  ];

  // Complete current ongoing module -> unlock next
  void _completeModule(int index) {
    setState(() {
      modules[index].status = ModuleStatus.completed;

      final nextIndex = index + 1;
      if (nextIndex < modules.length && modules[nextIndex].prerequisiteIndex == index) {
        modules[nextIndex].status = ModuleStatus.upcoming;
      }

      // promote first upcoming to ongoing
      final firstUpcoming = modules.indexWhere((m) => m.status == ModuleStatus.upcoming);
      if (firstUpcoming != -1) {
        modules[firstUpcoming].status = ModuleStatus.ongoing;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Module completed. Next unlocked!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ongoingCount   = modules.where((m) => m.status == ModuleStatus.ongoing).length;
    final completedCount = modules.where((m) => m.status == ModuleStatus.completed).length;
    final upcomingCount  = modules.where((m) => m.status == ModuleStatus.upcoming).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills Roadmap', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => AppTabs.goHome(), // back -> Home tab
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.menu_rounded),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _searchAndFilter(),
          const SizedBox(height: 12),
          _gradientHeader(),
          const SizedBox(height: 12),
          _statusHeader(ongoingCount, upcomingCount, completedCount),
          const SizedBox(height: 12),
          _segmentedTabs(),
          const SizedBox(height: 8),

          // TASKS (filtered by tab)
          ..._taskTiles(),

          const SizedBox(height: 18),
          const Center(
            child: Text('Skill Learning Subjects',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),

          // MODULE CARDS (with locked handling)
          ...modules.asMap().entries.map((e) => _moduleTile(e.key, e.value)).toList(),

          const SizedBox(height: 18),

          // SUBJECT CARDS (completed & locked)
          ..._subjectCards(),
        ],
      ),
    );
  }

  // ---------- UI parts ----------
  Widget _searchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search Skills',
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              filled: true,
              fillColor: const Color(0xFFF5F6F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.black12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 48, width: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.black12),
          ),
          child: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }

  Widget _gradientHeader() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0FA2B0), Color(0xFFF6A737)],
          begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            CircleAvatar(radius: 18, backgroundColor: Colors.white,
              child: Icon(Icons.star, color: kOrange)),
            SizedBox(width: 10),
            Text('Cloud Computing',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          Text('$pts/$outOf pts.',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          Text('Week $week', style: const TextStyle(color: Colors.white)),
          const Spacer(),
          _HoverScale(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Continue Learning… (demo)')),
              );
            },
            child: FilledButton.tonal(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(.25),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: const Text('Continue Learning'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusHeader(int ongoing, int upcoming, int completed) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _statChip('Ongoing', ongoing, kTeal.withOpacity(.15), kTeal),
            const SizedBox(width: 8),
            _statChip('Upcoming', upcoming, const Color(0xFFFFEAD2), kOrange),
            const SizedBox(width: 8),
            _statChip('Completed', completed, const Color(0xFFE7F6EA), Colors.green.shade700),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, int count, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Text('$count', style: TextStyle(color: fg, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Widget _segmentedTabs() {
    Widget seg(String label, TabKind me) {
      final selected = tab == me;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => tab = me),
          child: Container(
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? Colors.white : const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? kTeal : Colors.transparent, width: 2),
            ),
            child: Text(label, style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.black : Colors.black54)),
          ),
        ),
      );
    }

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEEF),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          seg('Ongoing', TabKind.ongoing),
          const SizedBox(width: 6),
          seg('Upcoming', TabKind.upcoming),
          const SizedBox(width: 6),
          seg('Completed', TabKind.completed),
        ],
      ),
    );
  }

  List<Widget> _taskTiles() {
    // Filter tasks by tab (simple heuristic for demo)
    Iterable<Task> source = tasks;
    if (tab == TabKind.completed) {
      source = tasks.where((t) => t.points >= t.outOf);
    } else if (tab == TabKind.upcoming) {
      source = tasks.where((t) => t.points == 0);
    } // ongoing -> default/all

    return source.map((t) {
      final progress = t.points / t.outOf;
      final isDone = t.points >= t.outOf;
      final cta = isDone ? 'View' : (t.points == 0 ? 'Start' : 'Continue');

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(
              children: [
                _pill('${t.points} pts', kTeal, const Color(0xFFE6F5F7)),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 14,
                      color: kTeal,
                      backgroundColor: const Color(0xFFE6E7E8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${t.points}/${t.outOf} pts', style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 10),
                _HoverScale(
                  onTap: () {
                    setState(() {
                      if (!isDone) t.points += 1; // demo: increment points
                    });
                  },
                  child: FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        if (!isDone) t.points += 1;
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(cta),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _moduleTile(int index, Module m) {
    final isLocked = m.status == ModuleStatus.locked;
    final isOngoing = m.status == ModuleStatus.ongoing;
    final isCompleted = m.status == ModuleStatus.completed;
    final isUpcoming = m.status == ModuleStatus.upcoming;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _statusIcon(m.status),
        title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${m.minutes} mins'),
        trailing: isLocked
            ? _pill('Locked', Colors.black54, const Color(0xFFE7E7E7))
            : isCompleted
                ? _pill('Completed', Colors.green.shade700, const Color(0xFFE7F6EA))
                : isOngoing
                    ? _HoverScale(
                        onTap: () => _completeModule(index),
                        child: FilledButton(
                          onPressed: () => _completeModule(index),
                          style: FilledButton.styleFrom(backgroundColor: kTeal, foregroundColor: Colors.white),
                          child: const Text('Mark Done'),
                        ),
                      )
                    : _HoverScale(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Starting… (demo)')),
                          );
                        },
                        child: _pill('Start', kOrange, const Color(0xFFFFEAD2)),
                      ),
        onTap: isLocked
            ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete subject requirements to unlock this.')),
                )
            : () {},
      ),
    );
  }

  List<Widget> _subjectCards() {
    return subjects.map((s) {
      final bg = s.locked ? const Color(0xFFE6E6E6) : Colors.white;
      final border = s.completed ? kOrange : Colors.black12;
      final shadow = s.completed ? const Color(0x26F6A737) : Colors.black12;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
          boxShadow: [BoxShadow(color: shadow, blurRadius: 6, offset: const Offset(0, 4))],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(
              s.locked ? Icons.lock : Icons.check_rounded,
              color: s.locked ? Colors.black87 : kOrange,
            ),
          ),
          title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: s.completed
              ? const Text('Completed', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600))
              : s.locked
                  ? Text(s.unlockHint ?? '',
                      style: const TextStyle(color: Colors.black54), textAlign: TextAlign.right)
                  : null,
          onTap: s.locked
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.unlockHint ?? 'Locked')),
                  )
              : () {},
        ),
      );
    }).toList();
  }

  Widget _pill(String text, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w800)),
    );
  }

  Icon _statusIcon(ModuleStatus status) {
    switch (status) {
      case ModuleStatus.ongoing:
        return const Icon(Icons.play_circle_fill, color: kTeal);
      case ModuleStatus.upcoming:
        return Icon(Icons.schedule, color: kOrange);
      case ModuleStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case ModuleStatus.locked:
        return const Icon(Icons.lock, color: Colors.black54);
    }
  }
}
