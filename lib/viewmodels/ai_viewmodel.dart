import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

enum MessageRole { user, model }

class ChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
  });
}

class AiViewModel extends ChangeNotifier {
  // API Key Gemini — ganti dengan key Anda
  static const String _apiKey = 'AIzaSyCoinObNMZBLYuIGTb9fgaf1zMJSh9ITGQ';

  GenerativeModel? _model;
  ChatSession? _chat;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isConfigured = false;
  String _customApiKey = '';

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isConfigured => _isConfigured;

  /// Auto-configure saat pertama kali dibuat jika _apiKey sudah diisi
  AiViewModel() {
    if (_apiKey != 'MASUKKAN_API_KEY_GEMINI_ANDA_DI_SINI' &&
        _apiKey.isNotEmpty) {
      configure(_apiKey);
    }
  }

  static const String _systemPrompt = '''
Kamu adalah Ustadz AI — asisten islami yang cerdas, bijaksana, dan penuh kasih sayang.

Peranmu:
- Menjawab pertanyaan seputar Islam: fiqh, akidah, akhlak, hadits, tafsir Al-Quran
- Memberikan motivasi islami dan pengingat ibadah harian
- Membantu memahami doa-doa dan maknanya
- Menjelaskan jadwal sholat dan tata cara ibadah
- Berbicara dengan bahasa yang ramah, sopan, dan mudah dipahami
- Selalu awali dengan Bismillah atau salam jika sesuai konteks
- Sertakan referensi ayat Al-Quran atau hadits bila relevan

Batasan:
- Jangan membahas topik di luar Islam kecuali untuk perbandingan yang memberi pemahaman
- Selalu ingatkan untuk berkonsultasi dengan ulama untuk masalah hukum serius
- Gunakan bahasa Indonesia yang baik dan benar

Format respons:
- Gunakan emoji yang relevan agar lebih menarik 🌙✨
- Tulis ayat Arab dalam huruf Arab jika ada
- Berikan penjelasan yang lengkap namun padat
''';

  void configure(String apiKey) {
    final key = apiKey.trim().isEmpty ? _apiKey : apiKey.trim();

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: key,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
    _chat = _model!.startChat();
    _isConfigured = true;
    _customApiKey = key;

    // Welcome message
    _messages.add(ChatMessage(
      text:
          'Assalamu\'alaikum warahmatullahi wabarakatuh 🌙\n\nAku adalah **Ustadz AI**, asisten islami yang siap membantu Anda!\n\nSilakan tanyakan apapun seputar:\n• 📖 Al-Quran & Tafsir\n• 🕌 Fiqh & Ibadah\n• 📿 Doa & Dzikir\n• 🌟 Motivasi Islami\n• ⏰ Jadwal Sholat\n\nAda yang ingin ditanyakan?',
      role: MessageRole.model,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading || !_isConfigured) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _chat!.sendMessage(Content.text(text.trim()));
      final responseText =
          response.text ?? 'Maaf, tidak ada respons dari server.';

      _messages.add(ChatMessage(
        text: responseText,
        role: MessageRole.model,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        text:
            '❌ Terjadi kesalahan: ${_getErrorMessage(e.toString())}\n\nPastikan API Key Anda valid.',
        role: MessageRole.model,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('API_KEY_INVALID') || error.contains('invalid')) {
      return 'API Key tidak valid. Mohon periksa kembali.';
    } else if (error.contains('quota') || error.contains('QUOTA')) {
      return 'Kuota API habis. Coba lagi nanti.';
    } else if (error.contains('network') || error.contains('SocketException')) {
      return 'Tidak ada koneksi internet.';
    }
    return error.length > 100 ? '${error.substring(0, 100)}...' : error;
  }

  void clearChat() {
    _messages.clear();
    if (_isConfigured) {
      _chat = _model!.startChat();
      configure(_customApiKey);
    }
    notifyListeners();
  }
}
