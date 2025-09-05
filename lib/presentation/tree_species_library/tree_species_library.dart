import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_card_widget.dart';
import './widgets/species_card_widget.dart';

class TreeSpeciesLibrary extends StatefulWidget {
  const TreeSpeciesLibrary({Key? key}) : super(key: key);

  @override
  State<TreeSpeciesLibrary> createState() => _TreeSpeciesLibraryState();
}

class _TreeSpeciesLibraryState extends State<TreeSpeciesLibrary> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allSpecies = [];
  List<Map<String, dynamic>> _filteredSpecies = [];
  Map<String, String> _activeFilters = {};
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isOffline = false;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadSpeciesData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreSpecies();
    }
  }

  Future<void> _loadSpeciesData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock data for Northern Kenya tree species
    final List<Map<String, dynamic>> mockSpecies = [
      {
        "id": 1,
        "localName": "Acacia",
        "swahiliName": "Mti wa Acacia",
        "scientificName": "Acacia tortilis",
        "image":
            "https://images.pexels.com/photos/1172675/pexels-photo-1172675.jpeg?auto=compress&cs=tinysrgb&w=800",
        "climateZone": "Arid",
        "growthRate": "Fast",
        "waterNeeds": "Low",
        "soilType": "Sandy",
        "description":
            "Hardy drought-resistant tree perfect for Northern Kenya's arid climate. Provides excellent shade and fodder for livestock.",
        "uses": ["Shade", "Fodder", "Timber", "Medicine"],
        "height": "8-15 meters",
        "isFavorite": false,
      },
      {
        "id": 2,
        "localName": "Baobab",
        "swahiliName": "Mbuyu",
        "scientificName": "Adansonia digitata",
        "image":
            "https://images.pexels.com/photos/631317/pexels-photo-631317.jpeg?auto=compress&cs=tinysrgb&w=800",
        "climateZone": "Arid",
        "growthRate": "Slow",
        "waterNeeds": "Low",
        "soilType": "Sandy",
        "description":
            "Iconic African tree known for its massive trunk and longevity. Stores water and provides nutritious fruit.",
        "uses": ["Food", "Medicine", "Fiber", "Storage"],
        "height": "15-25 meters",
        "isFavorite": true,
      },
      {
        "id": 3,
        "localName": "Desert Date",
        "swahiliName": "Mukoma",
        "scientificName": "Balanites aegyptiaca",
        "image":
            "https://images.pexels.com/photos/1172849/pexels-photo-1172849.jpeg?auto=compress&cs=tinysrgb&w=800",
        "climateZone": "Arid",
        "growthRate": "Medium",
        "waterNeeds": "Low",
        "soilType": "Sandy",
        "description":
            "Multi-purpose tree producing edible fruits and oil. Excellent for erosion control in dry areas.",
        "uses": ["Food", "Oil", "Medicine", "Erosion Control"],
        "height": "6-10 meters",
        "isFavorite": false,
      },
      {
        "id": 4,
        "localName": "Doum Palm",
        "swahiliName": "Mkoma",
        "scientificName": "Hyphaene thebaica",
        "image":
            "https://images.pexels.com/photos/1172849/pexels-photo-1172849.jpeg?auto=compress&cs=tinysrgb&w=800",
        "climateZone": "Semi-Arid",
        "growthRate": "Slow",
        "waterNeeds": "Medium",
        "soilType": "Clay",
        "description":
            "Native palm tree with edible fruits. Thrives in seasonal wetlands and provides construction materials.",
        "uses": ["Food", "Construction", "Crafts", "Shade"],
        "height": "8-12 meters",
        "isFavorite": false,
      },
      {
        "id": 5,
        "localName": "Fever Tree",
        "swahiliName": "Mti wa Homa",
        "scientificName": "Acacia xanthophloea",
        "image":
            "https://images.pexels.com/photos/1172675/pexels-photo-1172675.jpeg?auto=compress&cs=tinysrgb&w=800",
        "climateZone": "Semi-Arid",
        "growthRate": "Fast",
        "waterNeeds": "Medium",
        "soilType": "Loamy",
        "description":
            "Distinctive yellow-barked acacia that grows near water sources. Important for wildlife habitat.",
        "uses": ["Shade", "Wildlife Habitat", "Medicine", "Timber"],
        "height": "10-20 meters",
        "isFavorite": true,
      },
      {
        "id": 6,
        "localName": "Moringa",
        "swahiliName": "Mrongo",
        "scientificName": "Moringa oleifera",
        "image":
            "https://images.pixabay.com/photo-2019/08/15/15/19/moringa-4408793_1280.jpg",
        "climateZone": "Tropical",
        "growthRate": "Fast",
        "waterNeeds": "Medium",
        "soilType": "Loamy",
        "description":
            "Superfood tree with highly nutritious leaves. Fast-growing and drought-tolerant miracle tree.",
        "uses": ["Food", "Medicine", "Water Purification", "Nutrition"],
        "height": "8-12 meters",
        "isFavorite": false,
      },
      {
        "id": 7,
        "localName": "Neem",
        "swahiliName": "Mwarobaini",
        "scientificName": "Azadirachta indica",
        "image":
            "https://images.unsplash.com/photo-1574263867128-a3d5c1b1deaa?auto=format&fit=crop&w=800&q=80",
        "climateZone": "Semi-Arid",
        "growthRate": "Medium",
        "waterNeeds": "Low",
        "soilType": "Sandy",
        "description":
            "Medicinal tree with natural pesticide properties. Excellent for organic farming and health remedies.",
        "uses": ["Medicine", "Pesticide", "Shade", "Timber"],
        "height": "12-18 meters",
        "isFavorite": false,
      },
      {
        "id": 8,
        "localName": "Tamarind",
        "swahiliName": "Ukwaju",
        "scientificName": "Tamarindus indica",
        "image":
            "https://images.unsplash.com/photo-1595147389795-37094173bfd8?auto=format&fit=crop&w=800&q=80",
        "climateZone": "Tropical",
        "growthRate": "Slow",
        "waterNeeds": "Medium",
        "soilType": "Loamy",
        "description":
            "Long-lived tree producing tangy edible pods. Provides excellent shade and has cultural significance.",
        "uses": ["Food", "Medicine", "Shade", "Cultural"],
        "height": "15-25 meters",
        "isFavorite": true,
      },
    ];

    setState(() {
      _allSpecies = mockSpecies;
      _filteredSpecies = mockSpecies.take(_itemsPerPage).toList();
      _isLoading = false;
    });
  }

  Future<void> _loadMoreSpecies() async {
    if (_isLoadingMore || _filteredSpecies.length >= _allSpecies.length) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, _allSpecies.length);

    if (startIndex < _allSpecies.length) {
      setState(() {
        _filteredSpecies.addAll(_allSpecies.sublist(startIndex, endIndex));
        _currentPage++;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _filterSpecies() {
    List<Map<String, dynamic>> filtered = _allSpecies;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((species) {
        final localName = (species['localName'] as String).toLowerCase();
        final scientificName =
            (species['scientificName'] as String).toLowerCase();
        final swahiliName = (species['swahiliName'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return localName.contains(query) ||
            scientificName.contains(query) ||
            swahiliName.contains(query);
      }).toList();
    }

    // Apply active filters
    _activeFilters.forEach((key, value) {
      filtered = filtered.where((species) => species[key] == value).toList();
    });

    setState(() {
      _filteredSpecies = filtered.take(_itemsPerPage).toList();
      _currentPage = 1;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterSpecies();
  }

  void _onFiltersChanged(Map<String, String> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _filterSpecies();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _onSpeciesCardTap(Map<String, dynamic> species) {
    // Navigate to species detail screen with shared element transition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${species['localName']} details...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onSpeciesCardLongPress(Map<String, dynamic> species) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName:
                    species['isFavorite'] ? 'favorite' : 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(species['isFavorite']
                  ? 'Remove from Favorites'
                  : 'Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite(species);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share Species'),
              onTap: () {
                Navigator.pop(context);
                _shareSpecies(species);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'compare',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Compare with Others'),
              onTap: () {
                Navigator.pop(context);
                _compareSpecies(species);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> species) {
    setState(() {
      species['isFavorite'] = !species['isFavorite'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          species['isFavorite']
              ? '${species['localName']} added to favorites'
              : '${species['localName']} removed from favorites',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareSpecies(Map<String, dynamic> species) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${species['localName']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _compareSpecies(Map<String, dynamic> species) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding ${species['localName']} to comparison...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadSpeciesData();
  }

  List<String> get _activeFilterLabels {
    List<String> labels = [];
    _activeFilters.forEach((key, value) {
      switch (key) {
        case 'climateZone':
          labels.add('Climate: $value');
          break;
        case 'growthRate':
          labels.add('Growth: $value');
          break;
        case 'waterNeeds':
          labels.add('Water: $value');
          break;
        case 'soilType':
          labels.add('Soil: $value');
          break;
      }
    });
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tree Species Library'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          if (_isOffline)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: CustomIconWidget(
                iconName: 'cloud_off',
                color: AppTheme.warningColor,
                size: 24,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
          ),

          // Active Filter Chips
          if (_activeFilterLabels.isNotEmpty)
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _activeFilterLabels.length,
                itemBuilder: (context, index) {
                  final label = _activeFilterLabels[index];
                  return FilterChipWidget(
                    label: label,
                    count: 0,
                    isSelected: true,
                    onTap: () {
                      // Remove specific filter
                      final filterKey = _activeFilters.keys.elementAt(index);
                      setState(() {
                        _activeFilters.remove(filterKey);
                      });
                      _filterSpecies();
                    },
                  );
                },
              ),
            ),

          // Species Grid
          Expanded(
            child: _isLoading
                ? _buildSkeletonGrid()
                : _filteredSpecies.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 100.w > 600 ? 3 : 2,
                            crossAxisSpacing: 3.w,
                            mainAxisSpacing: 3.w,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _filteredSpecies.length +
                              (_isLoadingMore ? 2 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _filteredSpecies.length) {
                              return const SkeletonCardWidget();
                            }

                            final species = _filteredSpecies[index];
                            return SpeciesCardWidget(
                              species: species,
                              onTap: () => _onSpeciesCardTap(species),
                              onLongPress: () =>
                                  _onSpeciesCardLongPress(species),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 100.w > 600 ? 3 : 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const SkeletonCardWidget(),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No Species Found',
        subtitle:
            'Try adjusting your search or filters to find more tree species suitable for Northern Kenya.',
        actionText: 'Clear Filters',
        onActionTap: () {
          setState(() {
            _searchController.clear();
            _searchQuery = '';
            _activeFilters.clear();
          });
          _filterSpecies();
        },
      );
    }

    return const EmptyStateWidget(
      title: 'No Species Available',
      subtitle:
          'Check your internet connection and pull to refresh to load tree species data.',
    );
  }
}
