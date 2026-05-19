import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/category.dart';
import 'search_screen.dart';
import 'topic_list_screen.dart';
import '../l10n/app_localizations.dart';
import 'media_gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? parentCategoryId;
  final String? categoryName;

  const HomeScreen({super.key, this.parentCategoryId, this.categoryName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.getCategories(parentId: widget.parentCategoryId);
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'mosque': return Icons.mosque;
      case 'people': return Icons.people;
      case 'monetization_on': return Icons.monetization_on;
      case 'gavel': return Icons.gavel;
      case 'favorite': return Icons.favorite;
      case 'self_improvement': return Icons.self_improvement;
      case 'business': return Icons.business;
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'family_restroom': return Icons.family_restroom;
      case 'restaurant': return Icons.restaurant;
      case 'description': return Icons.description;
      case 'accessibility': return Icons.accessibility;
      case 'account_balance': return Icons.account_balance;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? l10n.appTitle),
        actions: [
          if (widget.parentCategoryId == null) ...[
            IconButton(
              icon: const Icon(Icons.photo_library),
              tooltip: "Bibliothèque Média",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MediaGalleryScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ]
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? _buildTopicList()
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return _buildCategoryCard(context, category);
                  },
                ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                parentCategoryId: category.id,
                categoryName: category.name,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            if (category.imageUrl != null)
              Positioned.fill(
                child: Image.network(
                  category.imageUrl!,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            if (category.imageUrl == null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green.shade700, Colors.green.shade400],
                    ),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getIconData(category.icon), size: 40, color: Colors.white),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                        shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicList() {
    if (widget.parentCategoryId == null) {
      return const Center(child: Text("No categories found."));
    }
    return TopicListScreen(
      categoryId: widget.parentCategoryId!,
      categoryName: widget.categoryName!,
    );
  }
}
