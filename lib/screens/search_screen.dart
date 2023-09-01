import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _listItems = [
    "Apple",
    "Orange",
    "Banana",
    "Grapes",
    "Mango",
    "Watermelon",
    "Pineapple",
    "Papaya",
    "Strawberry",
    "Blueberry",
  ];
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(_listItems);
    _searchController.addListener(_performSearch);
  }

  void _performSearch() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = List.from(_listItems);
      });
      return;
    }

    setState(() {
      _searchResults = _listItems
          .where((element) =>
              element.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
