import 'package:fitness_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RfmScreen extends StatefulWidget {
  static const routeName = '/rfm';
  const RfmScreen({Key? key}) : super(key: key);

  @override
  State<RfmScreen> createState() => _RfmScreenState();
}

class _RfmScreenState extends State<RfmScreen> {
  int currentIndex = 0;
  String? result;
  String? rfmStatus;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('RFM Calculator'),
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
                "Your waist circumference in Cm",
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
                    hintText: "Your waist circumference in Cm",
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
                  "Your RFM is: ",
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
                  rfmStatus != null ? "$rfmStatus" : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    getRfmStatus(double.parse(result!));
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

  void calculateBmi(double height, double waist) {
    double finalResult = 0.0;
    if (currentIndex == 0) {
      finalResult = 64 - 20 * (height / waist);
    } else {
      finalResult = 76 - 20 * (height / waist);
    }

    Provider.of<Auth>(context, listen: false).setRFM(finalResult);
    String rfm = finalResult.toStringAsFixed(2);
    setState(() {
      result = rfm;
    });
  }

  void getRfmStatus(double rfmResult) {
    if (currentIndex == 0) {
      if (rfmResult >= 2.0 && rfmResult <= 5.0) {
        rfmStatus = "Essential fat";
      } else if (rfmResult >= 6.0 && rfmResult <= 13.0) {
        rfmStatus = "Athletes";
      } else if (rfmResult >= 14.0 && rfmResult <= 17.0) {
        rfmStatus = "Fitness";
      } else if (rfmResult >= 18.0 && rfmResult < 24.0) {
        rfmStatus = "Average";
      } else if (rfmResult > 25.0) {
        rfmStatus = "Obese";
      }
    } else {
      if (rfmResult >= 10.0 && rfmResult <= 13.0) {
        rfmStatus = "Essential fat";
      } else if (rfmResult >= 14.0 && rfmResult <= 20.0) {
        rfmStatus = "Athletes";
      } else if (rfmResult >= 21.0 && rfmResult <= 24.0) {
        rfmStatus = "Fitness";
      } else if (rfmResult >= 25.0 && rfmResult < 31.0) {
        rfmStatus = "Average";
      } else if (rfmResult > 32.0) {
        rfmStatus = "Obese";
      }
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
