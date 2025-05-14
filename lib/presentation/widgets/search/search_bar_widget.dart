import 'package:flutter/material.dart';
import 'dart:ui';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final List<String> searchSuggestions;
  final String hintText;
  final bool isFloating;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.searchSuggestions = const [],
    this.hintText = 'Search for events, places...',
    this.isFloating = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _showSuggestions = false;
  String _searchText = '';
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // This will filter suggestions based on user input
  List<String> get filteredSuggestions {
    if (_searchText.isEmpty) {
      return widget.searchSuggestions.take(5).toList();
    }
    return widget.searchSuggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(_searchText.toLowerCase()))
        .take(5)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onSearchChanged);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused && _controller.text.isNotEmpty) {
        _showSuggestionOverlay();
      } else {
        _removeSuggestionOverlay();
      }
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _controller.text;
      if (_isFocused && _searchText.isNotEmpty) {
        _showSuggestionOverlay();
      } else {
        _removeSuggestionOverlay();
      }
    });
  }

  void _showSuggestionOverlay() {
    _removeSuggestionOverlay();
    _overlayEntry = _createSuggestionsOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeSuggestionOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onSearchChanged);
    _removeSuggestionOverlay();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    widget.onSearch(value);
    _focusNode.unfocus();
    _removeSuggestionOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.isFloating ? 28 : 16),
            boxShadow: widget.isFloating
                ? [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.isFloating ? 28 : 16),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.isFloating ? 10 : 0,
                sigmaY: widget.isFloating ? 10 : 0,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.isFloating
                      ? (isDark
                          ? Colors.black.withOpacity(0.6)
                          : Colors.white.withOpacity(0.8))
                      : (isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF7F8FC)),
                  borderRadius:
                      BorderRadius.circular(widget.isFloating ? 28 : 16),
                  border: Border.all(
                    color: _isFocused
                        ? primaryColor
                        : (isDark ? Colors.white10 : Colors.black12),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: _submitSearch,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: _isFocused
                          ? primaryColor
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                            },
                            color: isDark ? Colors.white60 : Colors.black54,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createSuggestionsOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredSuggestions.map((suggestion) {
                return ListTile(
                  leading: Icon(
                    Icons.search,
                    color: isDark ? Colors.white54 : Colors.black45,
                    size: 20,
                  ),
                  title: Text(
                    suggestion,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    _controller.text = suggestion;
                    _submitSearch(suggestion);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple widget for using the search bar
class SearchBarWithSuggestions extends StatelessWidget {
  final Function(String) onSearch;
  final List<String> searchSuggestions;
  final String hintText;
  final bool isFloating;

  const SearchBarWithSuggestions({
    super.key,
    required this.onSearch,
    this.searchSuggestions = const [],
    this.hintText = 'Search for events, places...',
    this.isFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(
      onSearch: onSearch,
      searchSuggestions: searchSuggestions,
      hintText: hintText,
      isFloating: isFloating,
    );
  }
}
