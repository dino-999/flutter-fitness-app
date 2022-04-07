import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmiScreen extends StatefulWidget {
  static const routeName = '/bmi';
  const BmiScreen({Key? key}) : super(key: key);

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  int currentIndex = 0;
  String? result;
  String? bmiStatus;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('BMI Calculator'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Theme.of(context).primaryColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  radioButton("Man", Colors.blue, 0),
                  radioButton("Woman", Colors.pink, 1),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Your Height in Cm:",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: heightController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "Your Height in Cm",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Your Weight in kg:",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: weightController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "Your Weight in kg",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                child: const Text(
                  "Your BMI is: ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  result != null ? "$result" : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  bmiStatus != null ? "$bmiStatus" : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 140.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    double h = double.parse(heightController.value.text);
                    double w = double.parse(weightController.value.text);
                    calculateBmi(h, w);
                    getBmiStatus(double.parse(result!));
                  },
                  child: const Text(
                    "Calculate",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateBmi(double height, double weight) {
    double finalResult = weight / (height * height / 10000);
    Provider.of<Auth>(context,listen: false).setBMI(finalResult);
    String bmi = finalResult.toStringAsFixed(2);
    setState(() {
      result = bmi;
    });
  }

  void getBmiStatus(double bmiResult) {
    if (bmiResult < 18.5) {
      bmiStatus = "Underfed";
    } else if (bmiResult > 18.5 && bmiResult < 25.0) {
      bmiStatus = "Normal weight";
    } else if (bmiResult > 25.0 && bmiResult < 30.0) {
      bmiStatus = "Overweight";
    } else if (bmiResult > 30 && bmiResult < 40.0) {
      bmiStatus = "Obesity";
    } else if (bmiResult > 40) {
      bmiStatus = "Morbid obesity";
    }
  }

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget radioButton(String value, Color color, int index) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        height: 80.0,
        child: FlatButton(
          color: currentIndex == index ? color : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: () {
            changeIndex(index);
          },
          child: Text(
            value,
            style: TextStyle(
                color: currentIndex == index ? Colors.white : color,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
