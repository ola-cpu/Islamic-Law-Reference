import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/guided_courses.dart';
import '../providers/user_provider.dart';
import '../views/home_screen.dart';
import '../views/onboarding_screen.dart';
import '../views/topic_loader_screen.dart';
import '../views/learn_hub_screen.dart';
import '../views/favorites_screen.dart';
import '../views/settings_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/search_screen.dart';
import '../views/courses_screen.dart';
import '../views/course_detail_screen.dart';
import '../views/media_gallery_screen.dart';
import '../views/compare_hub_screen.dart';

class AppRoutes {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const learn = '/learn';
  static const library = '/library';
  static const settings = '/settings';
  static const dashboard = '/dashboard';
  static const search = '/search';
  static const courses = '/courses';
  static const media = '/media';
  static const compare = '/compare';

  static String topic(int id) => '/topic/$id';
  static String category(int id, {String? name}) {
    final base = '/category/$id';
    if (name == null) return base;
    return '$base?name=${Uri.encodeComponent(name)}';
  }

  static String course(String courseId) => '/course/$courseId';
}

GoRouter createAppRouter(UserProvider userProvider) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: userProvider,
    redirect: (context, state) {
      if (!userProvider.isInitialized) return null;
      final onOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!userProvider.hasCompletedOnboarding && !onOnboarding) {
        return AppRoutes.onboarding;
      }
      if (userProvider.hasCompletedOnboarding && onOnboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/topic/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TopicLoaderScreen(topicId: id);
        },
      ),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final name = state.uri.queryParameters['name'];
          return HomeScreen(parentCategoryId: id, categoryName: name);
        },
      ),
      GoRoute(
        path: AppRoutes.learn,
        builder: (context, state) => const LearnHubScreen(),
      ),
      GoRoute(
        path: AppRoutes.library,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.courses,
        builder: (context, state) => const CoursesScreen(),
      ),
      GoRoute(
        path: AppRoutes.media,
        builder: (context, state) => const MediaGalleryScreen(),
      ),
      GoRoute(
        path: AppRoutes.compare,
        builder: (context, state) => const CompareHubScreen(),
      ),
      GoRoute(
        path: '/course/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final course = GuidedCourses.all.firstWhere(
            (c) => c.id == courseId,
            orElse: () => GuidedCourses.prayerBasics,
          );
          return CourseDetailScreen(course: course);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: Center(child: Text(state.error?.toString() ?? 'Page introuvable')),
    ),
  );
}
