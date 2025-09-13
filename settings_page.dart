import 'package:flutter/material.dart';
import 'main.dart'; // kTeal, kOrange, AppTabs

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: const [
          _SearchField(),
          SizedBox(height: 14),

          _HoverableTile(icon: Icons.person_outline_rounded, label: 'Account'),
          _Divider(),
          _HoverableTile(icon: Icons.shield_outlined, label: 'Privacy & Security'),
          _Divider(),
          _HoverableTile(icon: Icons.notifications_none_rounded, label: 'Notifications'),
          _Divider(),
          _HoverableTile(icon: Icons.build_circle_outlined, label: 'Appearance & Accessibility'),
          _Divider(),
          _HoverableTile(icon: Icons.help_outline_rounded, label: 'Help & Support'),
          _Divider(),
          _HoverableTile(icon: Icons.bookmark_border_rounded, label: 'Legal'),
          _Divider(),
          _HoverableTile(icon: Icons.logout_rounded, label: 'Logout', destructive: false),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
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
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search_rounded),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        filled: true,
        fillColor: const Color(0xFFF5F6F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: Color(0xFFE6E6E6));
}

/// ListTile whose label changes color on mouse hover (desktop/web)
/// and while pressed (mobile).
class _HoverableTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool destructive;
  final VoidCallback? onTap;

  const _HoverableTile({
    required this.icon,
    required this.label,
    this.destructive = false,
    this.onTap,
    super.key,
  });

  @override
  State<_HoverableTile> createState() => _HoverableTileState();
}

class _HoverableTileState extends State<_HoverableTile> {
  bool _hover = false;
  bool _pressed = false;

  Color get _baseColor =>
      widget.destructive ? Colors.red.shade700 : Colors.black87;

  Color get _hoverColor =>
      widget.destructive ? Colors.red.shade800 : kOrange; // highlight color

  @override
  Widget build(BuildContext context) {
    final titleColor = (_hover || _pressed) ? _hoverColor : _baseColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap ??
            () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.label} (demo)')),
                ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          leading: Icon(widget.icon, color: kOrange, size: 26),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            style: TextStyle(
              fontSize: 16,
              color: titleColor,
              fontWeight: FontWeight.w500,
            ),
            child: Text(widget.label),
          ),
          trailing:
              const Icon(Icons.chevron_right_rounded, color: Colors.black45),
        ),
      ),
    );
  }
}
