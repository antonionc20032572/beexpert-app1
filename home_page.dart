import 'package:flutter/material.dart';
import 'main.dart'; // uses kTeal, kOrange and AppTabs

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _topBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(height: 8),
            _ProfileBanner(),
            SizedBox(height: 14),
            _WeeklyFocusCard(),
            SizedBox(height: 14),
            _QuickNavRow(),
            SizedBox(height: 14),
            _NewsCarousel(),
            SizedBox(height: 14),
            _ContinueCta(),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _topBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Be', style: TextStyle(color: kTeal, fontWeight: FontWeight.w800)),
              TextSpan(text: 'Expert', style: TextStyle(color: kOrange, fontWeight: FontWeight.w800)),
            ]),
            style: const TextStyle(fontSize: 26, letterSpacing: .2),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.menu_rounded, size: 28),
        )
      ],
    );
  }
}

class _ProfileBanner extends StatelessWidget {
  const _ProfileBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0FA2B0), Color(0xFFF6A737)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        border: Border.all(color: const Color(0xFF2EB0C1), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage('assets/images/laura.jpg'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Laura Anderson', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                SizedBox(height: 4),
                Text('System Analyst Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: AppTabs.goSkills, // continue learning → skills
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Continue Learning'),
          ),
        ],
      ),
    );
  }
}

class _WeeklyFocusCard extends StatelessWidget {
  const _WeeklyFocusCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Row(
          children: [
            // left: tasks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Focus this week: Cloud Computing', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 10),
                  _taskRow(context, Icons.check_circle, 'Introduction to Cloud Functions', _chip('Review', const Color(0xFFFFEAD2), kOrange)),
                  const SizedBox(height: 6),
                  _taskRow(context, Icons.play_circle_fill, 'Launch Virtual Machine', _chip('Start', const Color(0xFFE6F5F7), kTeal)),
                  const SizedBox(height: 6),
                  _taskRow(context, Icons.lock, 'Set Up a Cloud Storage Service', _chip('Locked', const Color(0xFFE7E7E7), Colors.black54)),
                  const SizedBox(height: 6),
                  _taskRow(context, Icons.lock, 'Explore Cloud Security Basics', _chip('Locked', const Color(0xFFE7E7E7), Colors.black54)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // right: donut progress
            SizedBox(
              height: 96,
              width: 96,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 96,
                    width: 96,
                    child: CircularProgressIndicator(
                      value: 0.5, // 10/20
                      strokeWidth: 10,
                      backgroundColor: const Color(0xFFF1F1F1),
                      valueColor: const AlwaysStoppedAnimation(kOrange),
                    ),
                  ),
                  const Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('10/20', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text('pts.', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  static Widget _taskRow(BuildContext context, IconData icon, String title, Widget chip) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
        chip,
      ],
    );
  }
}

class _QuickNavRow extends StatelessWidget {
  const _QuickNavRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _QuickCard(
            title: 'Career',
            imagePath: 'assets/images/career.jpg',
            buttonText: 'Start',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickCard(
            title: 'Skills',
            imagePath: 'assets/images/skills.jpg',
            buttonText: 'Start',
            onPressed: AppTabs.goSkills, // ← navigate to Skills tab
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickCard(
            title: 'Events',
            imagePath: 'assets/images/events.jpg',
            buttonText: 'Start',
            onPressed: AppTabs.goEvents, // ← navigate to Events tab
          ),
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String buttonText;
  final VoidCallback? onPressed; // added
  const _QuickCard({
    required this.title,
    required this.imagePath,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 10),
            Container(
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(imagePath, width: 64, height: 64, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(onPressed: onPressed ?? () {}, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}

/// News feed image carousel (3 items) using your local assets.
class _NewsCarousel extends StatefulWidget {
  const _NewsCarousel();

  @override
  State<_NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<_NewsCarousel> {
  final _ctrl = PageController(viewportFraction: 0.96);
  int _index = 0;

  final _items = const [
    _NewsItem('Active Learning Strategies', 'assets/images/news1.jpg'),
    _NewsItem('Importance of Teamwork', 'assets/images/news2.jpg'),
    _NewsItem('Train your brain to be more creative', 'assets/images/news3.jpg'),
  ];

  void _go(int delta) {
    final next = (_index + delta).clamp(0, _items.length - 1);
    if (next != _index) {
      _ctrl.animateToPage(next, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: _items.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => _newsCard(_items[i]),
          ),
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: _NavBtn(icon: Icons.chevron_left_rounded, onTap: () => _go(-1)),
          ),
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: _NavBtn(icon: Icons.chevron_right_rounded, onTap: () => _go(1)),
          ),
        ],
      ),
    );
  }

  Widget _newsCard(_NewsItem item) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              child: Image.asset(item.image, fit: BoxFit.cover, height: double.infinity),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    'Curated insights, journals, and trends to boost your skills. Tap to explore the full article.',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.black12),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Read More'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsItem {
  final String title;
  final String image;
  const _NewsItem(this.title, this.image);
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: SizedBox(width: 32, height: 32, child: Icon(icon, color: Colors.black54)),
        ),
      ),
    );
  }
}

class _ContinueCta extends StatelessWidget {
  const _ContinueCta();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          const Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Continue Learning: ', style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: 'Launch Virtual Machine', style: TextStyle(color: kTeal, fontWeight: FontWeight.w700)),
              ]),
              style: TextStyle(fontSize: 16),
            ),
          ),
          InkWell(
            onTap: AppTabs.goSkills,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, color: kTeal),
            ),
          )
        ],
      ),
    );
  }
}
