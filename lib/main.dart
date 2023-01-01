import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
          // textTheme: TextTheme(
          //   decoration: InputDecoration(
          //     contentPadding: EdgeInsets.symmetric(vertical: 40.0),
          //   ),
          // ),
          ),
      home: const MyHomePage(title: 'Homepage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final controller1 = TextEditingController();
  bool viewVisible = false;
  double? bmi;
  String classification = "error";

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void whaat(double bmi) {
    setState(() {
      if (bmi < 16.00) {
        classification = "severely underweight";
      }
      if (bmi >= 16.00 && bmi < 18.50) {
        classification = "underweight";
      }
      if (bmi >= 18.50 && bmi < 25.00) {
        classification = "normal";
      }
      if (bmi >= 25.00 && bmi < 30.00) {
        classification = "overweight";
      }
      if (bmi >= 30.00 && bmi < 35.00) {
        classification = "obese (Type 1)";
      }
      if (bmi >= 35.00 && bmi < 40.00) {
        classification = "obese (Type 2)";
      }
      if (bmi >= 40.00) {
        classification = "obese (Type 3)";
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: 150,
                            child: Column(children: [
                              Text("Height (cm)"),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: controller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid value';
                                  }
                                  return null;
                                },
                              )
                            ])),
                        SizedBox(
                            width: 150,
                            child: Column(children: [
                              Text("Weight (kg)"),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: controller1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid value';
                                  }
                                  return null;
                                },
                              )
                            ])),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              bmi = double.parse(
                                  (double.parse(controller1.text) /
                                          pow(
                                              (double.parse(controller.text) /
                                                  100),
                                              2))
                                      .toStringAsFixed(2));
                              showWidget();
                              whaat(bmi!);
                            }
                          },
                          child: const Text('Calculate!'),
                        ),
                      ),
                    ),
                    Center(
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: viewVisible,
                        child: SizedBox(
                            height: 100,
                            width: 500,
                            child: Column(
                              children: <Widget>[
                                Text('Your BMI is $bmi',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 25)),
                                Text('You\'re $classification',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 25))
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
