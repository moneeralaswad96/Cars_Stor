import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        });
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List list = [];
    var listfiltter = list.where((e) => e.startwith(query)).toList();
    return query == ""
        ? Center(child: Text('ابحث عن المنتج'))
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, index) => ListTile(
              title:  Text(list[index]),
            ),
          );
  }
}
