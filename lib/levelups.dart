import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_habit_chart/categories.dart';
import 'package:testing_habit_chart/methods.dart';

class LevelTiles extends StatefulWidget {
  const LevelTiles({super.key});

  @override
  State<LevelTiles> createState() => _LevelTilesState();
}

class _LevelTilesState extends State<LevelTiles> {
  // Get all enum values as a list
  final List<HCategory> categories = HCategory.values.toList();
  @override
  Widget build(BuildContext context) {
    return Consumer<Methods>(
        builder: (context, methods, child) => ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, int index) {
              final category = categories[index];
              return ListTile(
                
                title: Text(category.name),
                subtitle: LinearProgressIndicator(
                  value: methods.categoryValues[category] / 3,
                ),
                trailing: Text('level:${methods.categoryLevels[category]}'),
              );
            }));
  }
}
