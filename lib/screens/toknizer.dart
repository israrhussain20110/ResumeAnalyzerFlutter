import 'package:flutter/services.dart';

class SimpleTokenizer {
  final Map<String, int> vocab;
  final int maxLength;

  SimpleTokenizer(this.vocab, {this.maxLength = 128});

  Map<String, List<int>> tokenize(String text) {
    // Simple whitespace tokenization with lowercase conversion
    final words = text.toLowerCase().split(RegExp(r'\s+'));

    // Initialize with [CLS] token (ID 101)
    final inputIds = [vocab['[CLS]'] ?? 101];
    final attentionMask = [1];

    // Add words up to maxLength - 2 (reserving space for [SEP])
    for (final word in words.take(maxLength - 2)) {
      inputIds.add(vocab[word] ?? vocab['[UNK]'] ?? 100);
      attentionMask.add(1);
    }

    // Add [SEP] token (ID 102)
    inputIds.add(vocab['[SEP]'] ?? 102);
    attentionMask.add(1);

    // Pad to maxLength
    while (inputIds.length < maxLength) {
      inputIds.add(vocab['[PAD]'] ?? 0);
      attentionMask.add(0);
    }

    return {
      'input_ids': inputIds,
      'attention_mask': attentionMask,
    };
  }

  static Future<SimpleTokenizer> loadFromAsset(String assetPath) async {
    try {
      final vocabString = await rootBundle.loadString(assetPath);
      final vocab = <String, int>{};
      final lines = vocabString.split('\n');

      for (int i = 0; i < lines.length; i++) {
        final word = lines[i].trim();
        if (word.isNotEmpty) {
          vocab[word] = i;
        }
      }

      // Add special tokens if not present
      vocab.putIfAbsent('[CLS]', () => 101);
      vocab.putIfAbsent('[SEP]', () => 102);
      vocab.putIfAbsent('[PAD]', () => 0);
      vocab.putIfAbsent('[UNK]', () => 100);

      return SimpleTokenizer(vocab);
    } catch (e) {
      throw Exception('Failed to load tokenizer: $e');
    }
  }
}