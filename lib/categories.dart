enum HCategory { int, effiecient, strength, adaptation, productive }

extension HCategoryExtension on HCategory {
  String get name {
    return toString().split('.').last;
  }
}