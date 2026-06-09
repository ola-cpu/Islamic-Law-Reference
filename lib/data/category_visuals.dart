import 'package:flutter/material.dart';

/// Visuels par icône de catégorie (hors ligne, sans URL réseau).
class CategoryVisuals {
  CategoryVisuals._();

  static const _assetByIcon = <String, String>{
    'mosque': 'assets/images/categories/mosque.png',
    'volunteer_activism': 'assets/images/categories/volunteer_activism.png',
    'people': 'assets/images/categories/people.png',
    'family_restroom': 'assets/images/categories/family_restroom.png',
    'monetization_on': 'assets/images/categories/monetization_on.png',
    'gavel': 'assets/images/categories/gavel.png',
    'favorite': 'assets/images/categories/favorite.png',
    'restaurant': 'assets/images/categories/restaurant.png',
    'description': 'assets/images/categories/description.png',
    'accessibility': 'assets/images/categories/accessibility.png',
    'account_balance': 'assets/images/categories/account_balance.png',
    // Sous-catégories → visuel parent
    'water_drop': 'assets/images/categories/mosque.png',
    'shower': 'assets/images/categories/mosque.png',
    'landscape': 'assets/images/categories/mosque.png',
    'flight': 'assets/images/categories/mosque.png',
    'payments': 'assets/images/categories/family_restroom.png',
    'unfold_less': 'assets/images/categories/family_restroom.png',
    'trending_up': 'assets/images/categories/monetization_on.png',
  };

  static String? assetPath(String icon, {String? imageUrl}) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('asset:')) return imageUrl.substring(6);
      if (imageUrl.startsWith('assets/')) return imageUrl;
    }
    return _assetByIcon[icon];
  }

  static List<Color> gradient(String icon) {
    switch (icon) {
      case 'mosque':
      case 'water_drop':
      case 'shower':
      case 'landscape':
      case 'flight':
        return [const Color(0xFF1B5E20), const Color(0xFF66BB6A)];
      case 'volunteer_activism':
      case 'trending_up':
        return [const Color(0xFF4A148C), const Color(0xFFAB47BC)];
      case 'people':
        return [const Color(0xFF0D47A1), const Color(0xFF42A5F5)];
      case 'family_restroom':
      case 'payments':
      case 'unfold_less':
        return [const Color(0xFF880E4F), const Color(0xFFEC407A)];
      case 'monetization_on':
        return [const Color(0xFFE65100), const Color(0xFFFFA726)];
      case 'gavel':
        return [const Color(0xFF37474F), const Color(0xFF78909C)];
      case 'favorite':
        return [const Color(0xFF00695C), const Color(0xFF26A69A)];
      case 'restaurant':
        return [const Color(0xFF33691E), const Color(0xFF9CCC65)];
      case 'description':
        return [const Color(0xFF4527A0), const Color(0xFF7E57C2)];
      case 'accessibility':
        return [const Color(0xFF1565C0), const Color(0xFF64B5F6)];
      case 'account_balance':
        return [const Color(0xFF4E342E), const Color(0xFFA1887F)];
      default:
        return [const Color(0xFF1B5E4B), const Color(0xFF4DB6A9)];
    }
  }

  static IconData iconData(String icon) {
    switch (icon) {
      case 'mosque':
        return Icons.mosque;
      case 'people':
        return Icons.people;
      case 'monetization_on':
        return Icons.monetization_on;
      case 'gavel':
        return Icons.gavel;
      case 'favorite':
        return Icons.favorite;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'business':
        return Icons.business;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'restaurant':
        return Icons.restaurant;
      case 'description':
        return Icons.description;
      case 'accessibility':
        return Icons.accessibility;
      case 'account_balance':
        return Icons.account_balance;
      case 'water_drop':
        return Icons.water_drop;
      case 'shower':
        return Icons.shower;
      case 'landscape':
        return Icons.landscape;
      case 'flight':
        return Icons.flight;
      case 'payments':
        return Icons.payments;
      case 'unfold_less':
        return Icons.unfold_less;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }
}
