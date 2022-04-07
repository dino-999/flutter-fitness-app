import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/models/training_date.dart';
import 'package:fitness_app/providers/auth.dart';
import 'package:fitness_app/screens/news_detail.dart';
import 'package:provider/provider.dart';

import '../providers/training_dates_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  var _isInit = true;
  var _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TrainingDatesProvider>(context, listen: false)
          .fetchTrainingDates(_selectedDate)
          .then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _getTrainingDates(DateTime date, BuildContext context) async {
    await Provider.of<TrainingDatesProvider>(context, listen: false)
        .fetchTrainingDates(_selectedDate);
  }

  Future<void> _InsertPeopleIntoDate(
      String id, String? uid, BuildContext context) async {
    await Provider.of<TrainingDatesProvider>(context, listen: false)
        .addPeople(id, uid);
  }

  bool checkActive(List<TrainingDate> dates, String uid) {
    for (var td in dates) {
      for (var p in td.people) {
        if (p == uid) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tdsData = Provider.of<TrainingDatesProvider>(context);
    final tds = tdsData.trainingDates;
    final currentUser = FirebaseAuth.instance.currentUser;
    var _isActive = checkActive(tds, currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Training Dates'),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 10,
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(
                          DateTime.now(),
                        ),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Colors.grey[600]),
                      ),
                      const Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 5, bottom: 10),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Theme.of(context).primaryColor,
              selectedTextColor: Colors.white,
              dayTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                  _getTrainingDates(date, context);
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tds.length,
              itemBuilder: (ctx, i) => Card(
                elevation: 5,
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  title: Text(
                    tds[i].title, 
                    style: TextStyle(color: _isActive ? Colors.red[600] : Colors.grey[600])
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(tds[i].dateOfTraining),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("Training"),
                              content: const Text(
                                  'Would you like to come to this training?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      print(tds[i].id);
                                      print(currentUser.uid);

                                      _InsertPeopleIntoDate(
                                          tds[i].id, currentUser.uid, context);

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'))
                              ],
                            ));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
