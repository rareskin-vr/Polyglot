class Language {
  final String name; // The language name
  final String code; // The language code

  Language({
    required this.name,
    required this.code,
  });
}

final List<Language> supportedLanguages = [
  Language(name: 'English', code: 'en'),
  Language(name: 'Spanish', code: 'es'),
  Language(name: 'French', code: 'fr'),
  Language(name: 'German', code: 'de'),
  Language(name: 'Chinese', code: 'zh'),
  Language(name: 'Hindi', code: 'hi'),
];