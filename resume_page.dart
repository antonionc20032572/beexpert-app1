import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'main.dart'; // kTeal, kOrange, AppTabs

// ---------- Small hover wrapper (desktop/web). On mobile acts as normal tap. ----------
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

// ---------- Simple resume data model ----------
class ResumeData {
  String name;
  String title;
  String email;
  String phone;
  String summary;
  List<String> skills;
  List<Experience> experience;

  ResumeData({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.summary,
    required this.skills,
    required this.experience,
  });

  factory ResumeData.sample() => ResumeData(
        name: 'Laura Anderson',
        title: 'Web Design & Developer',
        email: 'laura.anderson@example.com',
        phone: '+61 400 123 456',
        summary:
            'Passionate designer & developer focused on accessible, performant UIs. Experienced across Flutter and web stacks.',
        skills: ['Flutter', 'Figma', 'Dart', 'UI/UX', 'REST APIs', 'Git'],
        experience: [
          Experience(
            role: 'Frontend Developer',
            company: 'TechWave',
            period: '2023 – Present',
            bullets: [
              'Built Flutter apps for edu-tech with 98% crash-free sessions.',
              'Collaborated with design for pixel-perfect UI across iOS/Android.',
            ],
          ),
          Experience(
            role: 'UI/UX Designer',
            company: 'BlueSky Studio',
            period: '2021 – 2023',
            bullets: [
              'Produced high fidelity prototypes and design systems in Figma.',
              'Led usability tests improving task success by 22%.',
            ],
          ),
        ],
      );
}

class Experience {
  String role;
  String company;
  String period;
  List<String> bullets;
  Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.bullets,
  });
}

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  int _templateIndex = 0; // 0 = Classic, 1 = Modern
  ResumeData data = ResumeData.sample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => AppTabs.goHome(), // back -> Home tab
        ),
        actions: [ 
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.menu_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _previewCard(),
          const SizedBox(height: 16),
          _topActions(),
          const SizedBox(height: 10),
          _bottomActions(),
        ],
      ),
    );
  }

  // ---------- PREVIEW ----------
  Widget _previewCard() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AspectRatio(
          aspectRatio: 8.5 / 11.0, // A4-ish
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: _templateIndex == 0 ? _previewClassic() : _previewModern(),
          ),
        ),
      ),
    );
  }

  // A Flutter layout preview (Classic)
  Widget _previewClassic() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(data.title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email_outlined, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(data.email),
              const SizedBox(width: 16),
              Icon(Icons.phone_outlined, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(data.phone),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text('Summary', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(data.summary, maxLines: 5, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          const Text('Skills', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: data.skills.map((s) => Chip(label: Text(s))).toList(),
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          const Text('Experience', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: data.experience.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                final e = data.experience[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${e.role} • ${e.company}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(e.period, style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 4),
                      ...e.bullets.map((b) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('•  '),
                              Expanded(child: Text(b)),
                            ],
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // A second Flutter layout preview (Modern)
  Widget _previewModern() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // left bar
          Container(
            width: 110,
            color: kTeal.withOpacity(.08),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                const SizedBox(height: 10),
                const Text('Contact', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(data.email, style: const TextStyle(fontSize: 12)),
                Text(data.phone, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Skills', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ...data.skills.take(6).map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $s', style: const TextStyle(fontSize: 12)),
                    )),
              ],
            ),
          ),
          // main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  Text(data.title, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  Text(data.summary, maxLines: 4, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  const Text('Experience', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.experience.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        final e = data.experience[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${e.role} • ${e.company}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(e.period, style: const TextStyle(color: Colors.black54)),
                              const SizedBox(height: 4),
                              ...e.bullets.map((b) => Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('•  '),
                                      Expanded(child: Text(b)),
                                    ],
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- ACTIONS ----------
  Widget _topActions() {
    return Row(
      children: [
        Expanded(child: _actionButton(icon: Icons.add_box_rounded, label: 'New', border: kOrange, onTap: _newResume)),
        const SizedBox(width: 10),
        Expanded(child: _actionButton(icon: Icons.edit_note_rounded, label: 'Edit', border: kOrange, onTap: _openEditor)),
        const SizedBox(width: 10),
        Expanded(child: _actionButton(icon: Icons.library_books_rounded, label: 'Templates', border: kOrange, onTap: _openTemplates)),
      ],
    );
  }

  Widget _bottomActions() {
    return Row(
      children: [
        Expanded(child: _actionButton(icon: Icons.ios_share_rounded, label: 'Share', border: kTeal, onTap: _sharePdf)),
        const SizedBox(width: 10),
        Expanded(child: _actionButton(icon: Icons.print_rounded, label: 'Print', border: kTeal, onTap: _printPdf)),
        const SizedBox(width: 10),
        Expanded(child: _actionButton(icon: Icons.auto_awesome_rounded, label: 'Generate', border: kTeal, onTap: _previewPdf)),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color border,
    required VoidCallback onTap,
  }) {
    final content = Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: border),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade900)),
        ],
      ),
    );
    return _HoverScale(onTap: onTap, child: content);
  }

  // ---------- EDITOR ----------
  void _openEditor() {
    final nameC = TextEditingController(text: data.name);
    final titleC = TextEditingController(text: data.title);
    final emailC = TextEditingController(text: data.email);
    final phoneC = TextEditingController(text: data.phone);
    final summaryC = TextEditingController(text: data.summary);
    final skillsC = TextEditingController(text: data.skills.join(', '));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Edit Resume', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 12),
                _tf('Full name', nameC),
                _tf('Title', titleC),
                _tf('Email', emailC, keyboard: TextInputType.emailAddress),
                _tf('Phone', phoneC, keyboard: TextInputType.phone),
                _ta('Summary', summaryC, maxLines: 4),
                _tf('Skills (comma separated)', skillsC),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            data = ResumeData(
                              name: nameC.text.trim(),
                              title: titleC.text.trim(),
                              email: emailC.text.trim(),
                              phone: phoneC.text.trim(),
                              summary: summaryC.text.trim(),
                              skills: skillsC.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                              experience: data.experience, // keep existing for demo
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resume updated')));
                        },
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tf(String label, TextEditingController c, {TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF5F6F7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _ta(String label, TextEditingController c, {int maxLines = 3}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF5F6F7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        ),
      ),
    );
  }

  void _newResume() {
    setState(() => data = ResumeData.sample());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New resume started (sample data)')));
  }

  void _openTemplates() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Row(
            children: [
              Expanded(child: _templateThumb(label: 'Classic', selected: _templateIndex == 0, onTap: () => _selectTemplate(0))),
              const SizedBox(width: 10),
              Expanded(child: _templateThumb(label: 'Modern', selected: _templateIndex == 1, onTap: () => _selectTemplate(1))),
            ],
          ),
        );
      },
    );
  }

  Widget _templateThumb({required String label, required bool selected, required VoidCallback onTap}) {
    final card = Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: selected ? kTeal : Colors.black12, width: selected ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF7F8F9), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.description_outlined, size: 36, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 6),
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
    return _HoverScale(onTap: onTap, child: card);
  }

  void _selectTemplate(int i) {
    setState(() => _templateIndex = i);
    Navigator.pop(context);
  }

  // ---------- PDF / SHARE / PRINT ----------
  Future<Uint8List> _buildPdfBytes() async {
    final doc = pw.Document();
    final baseStyle = pw.TextStyle(fontSize: 11);
    final h1 = pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold);
    final h2 = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);

    pw.Widget header() => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(data.name, style: h1),
        pw.Text(data.title, style: baseStyle.copyWith(color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Row(children: [
          pw.Text(data.email, style: baseStyle),
          pw.SizedBox(width: 12),
          pw.Text(data.phone, style: baseStyle),
        ]),
      ],
    );

    if (_templateIndex == 0) {
      // Classic
      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 36),
            theme: pw.ThemeData.withFont(base: await PdfGoogleFonts.robotoRegular(), bold: await PdfGoogleFonts.robotoBold()),
          ),
          build: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              header(),
              pw.SizedBox(height: 12),
              pw.Divider(),
              pw.Text('Summary', style: h2),
              pw.SizedBox(height: 4),
              pw.Text(data.summary, style: baseStyle),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.Text('Skills', style: h2),
              pw.SizedBox(height: 4),
              pw.Wrap(spacing: 8, runSpacing: 6, children: data.skills.map((s) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Text(s, style: baseStyle),
              )).toList()),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.Text('Experience', style: h2),
              pw.SizedBox(height: 6),
              ...data.experience.map((e) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${e.role} • ${e.company}', style: baseStyle.copyWith(fontWeight: pw.FontWeight.bold)),
                    pw.Text(e.period, style: baseStyle.copyWith(color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    ...e.bullets.map((b) => pw.Bullet(text: b, style: baseStyle)),
                  ],
                ),
              )),
            ],
          ),
        ),
      );
    } else {
      // Modern
      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            margin: const pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
            theme: pw.ThemeData.withFont(base: await PdfGoogleFonts.robotoRegular(), bold: await PdfGoogleFonts.robotoBold()),
          ),
          build: (_) => pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 140,
                // 0.08 * 255 ≈ 20 (0x14) alpha
                color: PdfColor.fromInt((0x14 << 24) | (kTeal.value & 0x00FFFFFF)),
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Contact', style: h2),
                    pw.SizedBox(height: 6),
                    pw.Text(data.email, style: baseStyle),
                    pw.Text(data.phone, style: baseStyle),
                    pw.SizedBox(height: 10),
                    pw.Text('Skills', style: h2),
                    pw.SizedBox(height: 6),
                    ...data.skills.take(8).map((s) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 4),
                          child: pw.Text('• $s', style: baseStyle),
                        )),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(24, 18, 24, 18),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      header(),
                      pw.SizedBox(height: 12),
                      pw.Text(data.summary, style: baseStyle),
                      pw.SizedBox(height: 12),
                      pw.Text('Experience', style: h2),
                      pw.SizedBox(height: 6),
                      ...data.experience.map((e) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('${e.role} • ${e.company}', style: baseStyle.copyWith(fontWeight: pw.FontWeight.bold)),
                            pw.Text(e.period, style: baseStyle.copyWith(color: PdfColors.grey700)),
                            pw.SizedBox(height: 4),
                            ...e.bullets.map((b) => pw.Bullet(text: b, style: baseStyle)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return doc.save();
  }

  Future<void> _previewPdf() async {
    final bytes = await _buildPdfBytes();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> _printPdf() async {
    final bytes = await _buildPdfBytes();
    await Printing.layoutPdf(onLayout: (_) async => bytes); // iOS AirPrint dialog
  }

  Future<void> _sharePdf() async {
    final bytes = await _buildPdfBytes();
    await Printing.sharePdf(bytes: bytes, filename: 'BeExpert_Resume.pdf');
  }
}
