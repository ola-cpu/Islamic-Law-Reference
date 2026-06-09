import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/school.dart';
import '../models/category.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Topic> _searchResults = [];
  bool _isSearching = false;
  int? _selectedSchoolId;
  int? _selectedCategoryId;
  List<School> _schools = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final schools = await DatabaseHelper().getAllSchools(locale: userProvider.locale);
    final categories = await DatabaseHelper().getCategories(locale: userProvider.locale);
    setState(() {
      _schools = schools;
      _categories = categories;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty && _selectedSchoolId == null && _selectedCategoryId == null) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final results = await DatabaseHelper().searchTopics(
      query,
      locale: userProvider.locale,
      schoolId: _selectedSchoolId,
      categoryId: _selectedCategoryId,
    );

    if (query.isNotEmpty) {
      await userProvider.recordRecentSearch(query);
    }

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _showFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.filterBySchool),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _selectedSchoolId,
                      decoration: InputDecoration(labelText: l10n.school),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.allSchools)),
                        ..._schools.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
                      ],
                      onChanged: (val) {
                        setDialogState(() => _selectedSchoolId = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedCategoryId,
                      decoration: InputDecoration(labelText: l10n.filterByCategory),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.allCategories)),
                        ..._categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                      ],
                      onChanged: (val) {
                        setDialogState(() => _selectedCategoryId = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _performSearch(_controller.text);
                  },
                  child: Text(l10n.applyFilters),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.close),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecentSearches(BuildContext context, AppLocalizations l10n, UserProvider user) {
    final recent = user.recentSearches;
    if (recent.isEmpty) {
      return Center(child: Text(l10n.searchHint, style: TextStyle(color: Colors.grey.shade600)));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Text(l10n.recentSearches, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton(onPressed: () => user.clearRecentSearches(), child: Text(l10n.clearRecentSearches)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: recent.map((q) {
            return ActionChip(
              label: Text(q),
              onPressed: () {
                _controller.text = q;
                _performSearch(q);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final isAr = userProvider.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textAlign: isAr ? TextAlign.right : TextAlign.left,
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(fontFamily: isAr ? 'Amiri' : null),
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: _performSearch,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: (_selectedSchoolId != null || _selectedCategoryId != null) ? Colors.blue : null),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty && _controller.text.isNotEmpty
              ? Center(child: Text(l10n.noResults))
              : _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final topic = _searchResults[index];
                        return ListTile(
                          title: Text(
                            topic.title,
                            textAlign: isAr ? TextAlign.right : TextAlign.left,
                            style: TextStyle(fontFamily: isAr ? 'Amiri' : null),
                          ),
                          subtitle: Text(
                            topic.description,
                            textAlign: isAr ? TextAlign.right : TextAlign.left,
                            style: TextStyle(fontFamily: isAr ? 'Amiri' : null),
                          ),
                          onTap: () => context.push(AppRoutes.topic(topic.id!)),
                        );
                      },
                    )
                  : _buildRecentSearches(context, l10n, userProvider),
    );
  }
}
