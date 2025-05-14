import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_habit_chart/chart.dart';
import 'package:testing_habit_chart/levelups.dart';
import 'package:testing_habit_chart/methods.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  //firebase class acesss

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Methods>(
      builder: (context, method, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(controller: _tabController, tabs: [
              Tab(icon: Icon(Icons.radar_rounded)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.stacked_bar_chart_rounded)),
            ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Chart(),

              // ? Center(child: Text('No habits', style: TextStyle(fontSize: 20, color: Colors.grey),))

              StreamBuilder(
                  stream: method.gethabitStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List habitList = snapshot.data.docs;
                      return ListView.builder(
                          itemCount: habitList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = habitList[index];
                            String docID = document.id;
                            Map habitdata = document.data() as Map;
                            return ListTile(
                              title: Text(habitdata['habitname']),
                              subtitle: Text(habitdata['category']),
                              trailing: IconButton(
                                  onPressed: () =>
                                      method.habitFinished(habitdata['category'], docID),
                                  icon: const Icon(Icons.check)),
                            );
                          });
                          
                    } else {
                      return const Center(
                          child: Text(
                        'No habits',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ));
                    }
                  }),
              LevelTiles(),
            ],
          ),
          floatingActionButton: _currentIndex == 1
              ? FloatingActionButton(
                  onPressed: () => method.addingHabit(context),
                  child: Icon(Icons.add),
                )
              : null,
        ),
      ),
    );
  }
}
