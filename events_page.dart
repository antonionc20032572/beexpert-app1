import 'package:flutter/material.dart';
import 'main.dart'; // kTeal, kOrange, AppTabs

class _HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final VoidCallback? onTap;
  final MouseCursor cursor;
  const _HoverScale({required this.child, this.scale = 1.03, this.onTap, this.cursor = SystemMouseCursors.click});
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
      child: Material(color: Colors.transparent, child: InkWell(onTap: widget.onTap, child: widget.child)),
    );
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.cursor,
      child: w,
    );
  }
}

class EventItem {
  final String title, speaker, dateTime, location, description, imageAsset;
  EventItem({required this.title, required this.speaker, required this.dateTime, required this.location, required this.description, required this.imageAsset});
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final events = <EventItem>[
    EventItem(
      title: 'Career in Systems Analysis',
      speaker: 'Dr. Melissa Grant – Senior Systems Analyst at TechSphere Solutions',
      dateTime: '28 Aug 2025, 6:00 PM – 7:30 PM',
      location: 'Hilton Sydney, Level 3 Conference Room',
      description:
          'This webinar covers the evolving role of systems analysts, core skills in demand, and tips for breaking into the field. Includes a Q&A session with real-world career advice.',
      imageAsset: 'assets/images/event1.jpg',
    ),
    EventItem(
      title: 'Tech Networking Night',
      speaker: 'James Holloway – Founder of InnovateIT',
      dateTime: '15 Sep 2025, 6:30 PM – 9:00 PM',
      location: 'Sydney Startup Hub, CBD',
      description:
          'An exclusive networking event for IT professionals, recruiters, and career changers. Opportunity to connect, share projects, and explore job leads in the tech sector.',
      imageAsset: 'assets/images/event2.jpg',
    ),
    EventItem(
      title: 'Resume Building Workshop – Online',
      speaker: 'Catherine Li – Career Coach & HR Specialist, formerly at LinkedIn Talent Solutions.',
      dateTime: '20 Sep 2025, 5 PM',
      location: 'Zoom (link sent after registration)',
      description:
          'Hands-on workshop to craft an ATS-friendly resume tailored for IT roles. Includes live feedback and a downloadable resume template.',
      imageAsset: 'assets/images/event3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
        children: [
          _searchRow(),
          const SizedBox(height: 14),
          ...events.map((e) => _eventCard(e)).expand((w) => [w, const SizedBox(height: 16)]),
          const SizedBox(height: 4),
          Center(
            child: IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Load more (demo)'))),
              icon: const Icon(Icons.expand_more_rounded, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Events',
          style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline, decorationColor: Colors.black87, decorationThickness: 2,
          )),
      centerTitle: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => AppTabs.goHome()),
      actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.menu_rounded))],
    );
  }

  Widget _searchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Search Events',
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              filled: true,
              fillColor: const Color(0xFFF5F6F7),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.black12)),
            ),
            onSubmitted: (q) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Searching "$q" (demo)'))),
          ),
        ),
        const SizedBox(width: 12),
        _HoverScale(
          onTap: _openFilters,
          child: Container(
            height: 48, width: 56,
            decoration: BoxDecoration(color: const Color(0xFFF5F6F7), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.black12)),
            child: const Icon(Icons.tune_rounded),
          ),
        ),
      ],
    );
  }

  Widget _eventCard(EventItem e) {
    final card = Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(e.imageAsset, width: 130, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.title, style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(e.speaker, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.event, size: 16, color: Colors.black54), const SizedBox(width: 6),
                    Text(e.dateTime, style: const TextStyle(color: Colors.black87)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.place_outlined, size: 16, color: Colors.black54), const SizedBox(width: 6),
                    Expanded(child: Text(e.location, style: const TextStyle(color: Colors.black87))),
                  ]),
                  const SizedBox(height: 8),
                  Text(e.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _HoverScale(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered for "${e.title}" (demo)'))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFFFFEAD2), borderRadius: BorderRadius.circular(30)),
                        child: const Text('Register', style: TextStyle(color: kOrange, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return _HoverScale(onTap: () {}, child: card);
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) {
        bool onlyOnline = false;
        bool onlySydney = false;
        return StatefulBuilder(builder: (ctx, setLocal) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Filters', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 10),
                SwitchListTile(value: onlyOnline, onChanged: (v) => setLocal(() => onlyOnline = v), title: const Text('Show online events only')),
                SwitchListTile(value: onlySydney, onChanged: (v) => setLocal(() => onlySydney = v), title: const Text('Show Sydney events only')),
                const SizedBox(height: 8),
                FilledButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filters applied (demo)'))); }, child: const Text('Apply')),
              ],
            ),
          );
        });
      },
    );
  }
}
