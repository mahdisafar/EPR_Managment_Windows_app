import 'package:flutter/material.dart';

class LedgerSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const LedgerSearchBar({super.key, required this.onSearch});

  @override
  State<LedgerSearchBar> createState() => _LedgerSearchBarState();
}

class _LedgerSearchBarState extends State<LedgerSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: _controller,
        onChanged: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'جستجو در عنوان، شماره سند یا توضیحات...',
          hintStyle: const TextStyle(fontSize: 12, fontFamily: 'IranYekan'),
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
