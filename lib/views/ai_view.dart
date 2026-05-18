import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ai_viewmodel.dart';
import '../theme/app_theme.dart';

class AiView extends StatelessWidget {
  const AiView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AiViewModel(),
      child: const _AiViewContent(),
    );
  }
}

class _AiViewContent extends StatefulWidget {
  const _AiViewContent();

  @override
  State<_AiViewContent> createState() => _AiViewContentState();
}

class _AiViewContentState extends State<_AiViewContent>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _apiKeyController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AiViewModel>(
      builder: (context, vm, _) {
        if (vm.messages.isNotEmpty) _scrollToBottom();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context, vm),
          body: !vm.isConfigured
              ? _buildSetupScreen(context, vm)
              : Column(
                  children: [
                    Expanded(child: _buildMessageList(context, vm)),
                    if (vm.isLoading) _buildTypingIndicator(context),
                    _buildInputBar(context, vm),
                  ],
                ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, AiViewModel vm) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF065F46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: AppTheme.secondary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'Ustadz AI',
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        if (vm.isConfigured)
          IconButton(
            onPressed: () => _showClearDialog(context, vm),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Bersihkan chat',
          ),
        if (vm.isConfigured)
          IconButton(
            onPressed: () => _showApiKeyDialog(context, vm),
            icon: const Icon(Icons.key_rounded),
            tooltip: 'Ubah API Key',
          ),
      ],
    );
  }

  // ─── SETUP SCREEN ──────────────────────────────────────────────────────────
  Widget _buildSetupScreen(BuildContext context, AiViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Animated Icon
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF065F46)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: AppTheme.secondary, size: 48),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ustadz AI',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Asisten islami berbasis Gemini AI\nsiap menjawab pertanyaan Anda',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: isDark ? Colors.white60 : Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Feature chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _featureChip('📖 Al-Quran'),
              _featureChip('🕌 Fiqh'),
              _featureChip('📿 Doa & Dzikir'),
              _featureChip('🌟 Motivasi'),
              _featureChip('⏰ Ibadah'),
              _featureChip('📚 Hadits'),
            ],
          ),
          const SizedBox(height: 32),
          // API Key Input
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.key_rounded,
                          color: AppTheme.secondary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Gemini API Key',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'AIza... (dari aistudio.google.com)',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.primary.withOpacity(0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      // Open URL (simple launcher)
                    },
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Dapatkan API Key gratis di aistudio.google.com',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Start Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                vm.configure(_apiKeyController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AppTheme.secondary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Mulai Chat',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _featureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.15),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  // ─── MESSAGE LIST ───────────────────────────────────────────────────────────
  Widget _buildMessageList(BuildContext context, AiViewModel vm) {
    if (vm.messages.isEmpty) {
      return Center(
        child: Text(
          'Belum ada pesan',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: vm.messages.length,
      itemBuilder: (context, index) {
        final msg = vm.messages[index];
        return _buildMessageBubble(context, msg, index);
      },
    );
  }

  Widget _buildMessageBubble(
      BuildContext context, ChatMessage msg, int index) {
    final isUser = msg.role == MessageRole.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index % 5) * 50),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(isUser ? 20 * (1 - value) : -20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF065F46)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: AppTheme.secondary, size: 16),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: msg.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesan disalin'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [AppTheme.primary, Color(0xFF065F46)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUser
                        ? null
                        : isDark
                            ? AppTheme.surfaceDark
                            : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? AppTheme.primary.withOpacity(0.25)
                            : Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: isUser
                        ? null
                        : Border.all(
                            color: AppTheme.primary.withOpacity(0.08),
                            width: 1,
                          ),
                  ),
                  child: isUser
                      ? Text(
                          msg.text,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        )
                      : MarkdownBody(
                          data: msg.text,
                          styleSheet: MarkdownStyleSheet(
                            p: GoogleFonts.inter(
                              fontSize: 14.5,
                              color: isDark ? Colors.white : AppTheme.textDark,
                              height: 1.6,
                            ),
                            strong: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                            code: GoogleFonts.sourceCodePro(
                              fontSize: 13,
                              backgroundColor:
                                  AppTheme.primary.withOpacity(0.08),
                            ),
                            blockquote: GoogleFonts.inter(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                        ),
                ),
              ),
            ),
            if (isUser) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // ─── TYPING INDICATOR ───────────────────────────────────────────────────────
  Widget _buildTypingIndicator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF065F46)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: AppTheme.secondary, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ─── INPUT BAR ──────────────────────────────────────────────────────────────
  Widget _buildInputBar(BuildContext context, AiViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.primary.withOpacity(0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 12,
        bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              maxLines: 4,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Tanyakan sesuatu tentang Islam...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppTheme.primary.withOpacity(0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
              ),
              style: GoogleFonts.inter(fontSize: 14),
              onSubmitted: (text) {
                _sendMessage(vm);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Quick suggestions button
          _buildQuickSuggestButton(context, vm),
          const SizedBox(width: 6),
          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Material(
              color: vm.isLoading
                  ? Colors.grey[300]
                  : AppTheme.primary,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: vm.isLoading ? null : () => _sendMessage(vm),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  child: Icon(
                    vm.isLoading
                        ? Icons.hourglass_top_rounded
                        : Icons.send_rounded,
                    color: vm.isLoading ? Colors.grey : AppTheme.secondary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestButton(BuildContext context, AiViewModel vm) {
    return Material(
      color: AppTheme.secondary.withOpacity(0.15),
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => _showQuickSuggestions(context, vm),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: const Icon(Icons.lightbulb_outline_rounded,
              color: AppTheme.secondary, size: 20),
        ),
      ),
    );
  }

  void _sendMessage(AiViewModel vm) {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    vm.sendMessage(text);
    _scrollToBottom();
  }

  void _showQuickSuggestions(BuildContext context, AiViewModel vm) {
    final suggestions = [
      '🤲 Apa bacaan doa sebelum tidur?',
      '🕌 Jelaskan rukun Islam dan Iman',
      '📖 Apa keutamaan membaca Al-Quran?',
      '⏰ Apa hukum sholat tepat waktu?',
      '🌙 Apa amalan di bulan Ramadan?',
      '💡 Berikan motivasi islami untuk hari ini',
      '📿 Apa dzikir pagi dan petang?',
      '💑 Bagaimana etika pergaulan dalam Islam?',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '✨ Pertanyaan Populer',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              ...suggestions.map((s) => ListTile(
                    dense: true,
                    title: Text(s,
                        style: GoogleFonts.inter(fontSize: 14)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _inputController.text = s;
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showClearDialog(BuildContext context, AiViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Bersihkan Chat?',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
        content: Text('Semua riwayat percakapan akan dihapus.',
            style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              vm.clearChat();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Hapus',
                style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context, AiViewModel vm) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Ubah API Key',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Masukkan API Key baru...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              vm.clearChat();
              vm.configure(ctrl.text);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Simpan',
                style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── TYPING DOTS ANIMATION ──────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _animations = _controllers
        .map((c) =>
            Tween<double>(begin: 0, end: -6).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (int i = 0; i < 3; i++) {
        if (!mounted) return;
        _controllers[i].forward();
        await Future.delayed(const Duration(milliseconds: 150));
      }
      await Future.delayed(const Duration(milliseconds: 300));
      for (var c in _controllers) {
        if (!mounted) return;
        c.reverse();
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) {
            return Transform.translate(
              offset: Offset(0, _animations[i].value),
              child: Container(
                width: 7,
                height: 7,
                margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.5 + i * 0.15),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
