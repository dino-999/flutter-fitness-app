import 'dart:convert';

import 'package:fitness_app/models/training_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './news.dart';

class TrainingDatesProvider with ChangeNotifier {
  List<TrainingDate> _tds = [];

  List<TrainingDate> get trainingDates {
    return [..._tds];
  }

  Future<void> addPeople(String id, String? uid) async {
    final url = Uri.parse('http://10.0.2.2:5000/training/' + id);

    print(url);
    print(uid);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "uid": uid,
        }),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchTrainingDates(DateTime date) async {
    final url = Uri.parse('http://10.0.2.2:5000/training');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      print(extractedData);

      if (extractedData == null) {
        return;
      }
      final List<TrainingDate> loadedTds = [];
      extractedData.forEach(
        (td) {
          loadedTds.add(
            TrainingDate(
                id: td['id'],
                title: td['title'],
                dateOfTraining: DateTime.parse(
                  td['dateOfTraining'],
                ),
                people: td['people'],),
          );
        },
      );

      _tds =
          loadedTds.where((td) => td.dateOfTraining.day == date.day).toList();

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
