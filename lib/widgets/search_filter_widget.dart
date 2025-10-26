import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String?) onCategoryChanged;
  final Function(bool?) onMasteredFilterChanged;
  final Function(String) onSortChanged;
  final List<String> categories;
  final String currentCategory;
  final bool? masteredFilter;
  final String currentSort;

  const SearchFilterWidget({
    super.key,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onMasteredFilterChanged,
    required this.onSortChanged,
    required this.categories,
    required this.currentCategory,
    required this.masteredFilter,
    required this.currentSort,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vocabulary...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: widget.onSearchChanged,
            ),

            // Expandable Filters
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? null : 0,
              child: _isExpanded ? _buildFilters() : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: widget.currentCategory.isEmpty
                ? null
                : widget.currentCategory,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('All Categories'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Categories'),
              ),
              ...widget.categories.map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              ),
            ],
            onChanged: widget.onCategoryChanged,
          ),

          const SizedBox(height: 16),

          // Mastered Filter
          const Text(
            'Learning Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: widget.masteredFilter == null,
                onSelected: (_) => widget.onMasteredFilterChanged(null),
              ),
              FilterChip(
                label: const Text('Mastered'),
                selected: widget.masteredFilter == true,
                onSelected: (_) => widget.onMasteredFilterChanged(true),
              ),
              FilterChip(
                label: const Text('Learning'),
                selected: widget.masteredFilter == false,
                onSelected: (_) => widget.onMasteredFilterChanged(false),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sort Options
          const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: widget.currentSort,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: 'word_asc', child: Text('Word (A-Z)')),
              DropdownMenuItem(value: 'word_desc', child: Text('Word (Z-A)')),
              DropdownMenuItem(
                value: 'created_desc',
                child: Text('Newest First'),
              ),
              DropdownMenuItem(
                value: 'created_asc',
                child: Text('Oldest First'),
              ),
              DropdownMenuItem(
                value: 'difficulty_asc',
                child: Text('Easiest First'),
              ),
              DropdownMenuItem(
                value: 'difficulty_desc',
                child: Text('Hardest First'),
              ),
              DropdownMenuItem(
                value: 'review_count_desc',
                child: Text('Most Reviewed'),
              ),
            ],
            onChanged: (value) => widget.onSortChanged(value ?? 'word_asc'),
          ),
        ],
      ),
    );
  }
}
