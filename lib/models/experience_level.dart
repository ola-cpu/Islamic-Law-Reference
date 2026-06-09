enum ExperienceLevel {
  beginner,
  student;

  String get storageKey => name;

  static ExperienceLevel fromKey(String? key) {
    return ExperienceLevel.values.firstWhere(
      (e) => e.name == key,
      orElse: () => ExperienceLevel.student,
    );
  }
}
