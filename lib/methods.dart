import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testing_habit_chart/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Methods extends ChangeNotifier {
  final CollectionReference habitsdb =
      FirebaseFirestore.instance.collection('habitsdb');
  final CollectionReference valuesdb =
      FirebaseFirestore.instance.collection('valuesdb');

  // Document ID for storing category values (using a fixed document ID for simplicity)
  final String categoryValuesDocId = 'category_values';
  final String categoryLevelDocId = 'category_levels';

  Stream gethabitStream() {
    final habitStream =
        habitsdb.orderBy('category', descending: true).snapshots();
    return habitStream;
  }

  
  final controller = TextEditingController();

  //map of values
  Map categoryValues = {
    HCategory.int: 0,
    HCategory.effiecient: 0,
    HCategory.strength: 0,
    HCategory.adaptation: 0,
    HCategory.productive: 0,
  };

  // New map to track level values
  Map categoryLevels = {
    HCategory.int: 0,
    HCategory.effiecient: 0,
    HCategory.strength: 0,
    HCategory.adaptation: 0,
    HCategory.productive: 0,
  };

    Methods(){
    loadCategoryValues();
  }

  // add habit method
  void addHabit(String name, HCategory category) {
    // final newhabit = Habitdata(name: name, category: category);
    // habits.add(newhabit);
    habitsdb.add({
      'habitname': name,
      'category': category.name,
    });
    notifyListeners();
  }

// adding habit dialog box
  void addingHabit(BuildContext context) {
    // default selected value
    HCategory selectedvalue = HCategory.int;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              DropdownButton(
                  focusColor: Colors.blue,
                  dropdownColor: Colors.amber,
                  value: selectedvalue,
                  items: HCategory.values
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category.name)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedvalue = value!;
                    });
                  }),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (controller.text.isEmpty) {
                    return;
                  }
                  addHabit(controller.text, selectedvalue);
                  controller.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }

  //loading categoryValues
  Future<void> loadCategoryValues() async{
    DocumentSnapshot vDoc = await valuesdb.doc(categoryValuesDocId).get();
    DocumentSnapshot lDoc = await valuesdb.doc(categoryLevelDocId).get();

    Map lData = lDoc.data() as Map;
    Map vData = vDoc.data() as Map;

    // Update the local categoryValues map with values from Firestore
        // We need to convert from the string keys to HCategory enum keys
        categoryValues[HCategory.int] = vData['int'] ?? 0;
        categoryValues[HCategory.effiecient] = vData['effiecient'] ?? 0;
        categoryValues[HCategory.strength] = vData['strength'] ?? 0;
        categoryValues[HCategory.adaptation] = vData['adaptation'] ?? 0;
        categoryValues[HCategory.productive] = vData['productive'] ?? 0;
        //updateing level values
        categoryLevels[HCategory.int] = lData['int'] ?? 0;
        categoryLevels[HCategory.effiecient] = lData['effiecient'] ?? 0;
        categoryLevels[HCategory.strength] = lData['strength'] ?? 0;
        categoryLevels[HCategory.adaptation] = lData['adaptation'] ?? 0;
        categoryLevels[HCategory.productive] = lData['productive'] ?? 0;
        notifyListeners();
  } 

  

  //saving categoryValues
  Future<void> saveCategoryValues() async {
    await valuesdb.doc(categoryValuesDocId).set({
      'int': categoryValues[HCategory.int],
      'effiecient': categoryValues[HCategory.effiecient],
      'strength': categoryValues[HCategory.strength],
      'adaptation': categoryValues[HCategory.adaptation],
      'productive': categoryValues[HCategory.productive],
    });

    await valuesdb.doc(categoryLevelDocId).set({
      'int': categoryLevels[HCategory.int],
      'effiecient': categoryLevels[HCategory.effiecient],
      'strength': categoryLevels[HCategory.strength],
      'adaptation': categoryLevels[HCategory.adaptation],
      'productive': categoryLevels[HCategory.productive],
    });
  }

  // incrementing stats
  void habitFinished(String categoryName, String docID) {
    HCategory? categoryIndex;
    for(var category in HCategory.values){
      if(category.name == categoryName) {
        categoryIndex = category;
        break;
      }
    }

      if(categoryIndex != null){
         // Increment the category value
        categoryValues[categoryIndex] = categoryValues[categoryIndex]! + 1;
        if (categoryValues[categoryIndex] >= 3) {
        //level up
        categoryLevels[categoryIndex] = categoryLevels[categoryIndex]! + 1;
        //reset counter (substrct 10 so we keep remainder toward next level)
        categoryValues[categoryIndex] = categoryValues[categoryIndex]! - 3;
      }
    } else {
      categoryValues[categoryIndex] = 1;
      categoryLevels[categoryIndex] = 0;
    }
      

     saveCategoryValues();
    // deleting from firebasedb
    habitsdb.doc(docID).delete();
    notifyListeners();

    // // Get the category of the habit before removing it
    // HCategory categoryIndex = habits[index].category;

    // // Increment the corresponding category value
    // if (categoryValues.containsKey(categoryIndex)) {
    //   categoryValues[categoryIndex] = categoryValues[categoryIndex]! + 1;

      // check if we reached 5 and should level up
    //   if (categoryValues[categoryIndex] >= 3) {
    //     //level up
    //     categoryLevels[categoryIndex] = categoryLevels[categoryIndex]! + 1;
    //     //reset counter (substrct 10 so we keep remainder toward next level)
    //     categoryValues[categoryIndex] = categoryValues[categoryIndex]! - 3;
    //   }
    // } else {
    //   categoryValues[categoryIndex] = 1;
    //   categoryLevels[categoryIndex] = 0;
    // }
    
   
  }

  // Update to return level values instead of raw counters
  List<RadarEntry> getRadarEntries() {
    final categories = [
      HCategory.productive,
      HCategory.int,
      HCategory.strength,
      HCategory.adaptation,
      HCategory.effiecient,
    ];
    // Return level values for the radar chart
    return categories
        .map((category) =>
            RadarEntry(value: categoryLevels[category]?.toDouble() ?? 0))
        .toList();
  }

}
