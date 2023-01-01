import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
            bodySmall: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
            titleSmall: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          ),
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid, color: Colors.pinkAccent),
              ))),
      home: const MyHomePage(title: 'BMI Calculator'),
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

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  void bmiClassification(double bmi) {
    setState(() {
      if (bmi < 16.00) {
        classification = "'re severely underweight";
      }
      if (bmi >= 16.00 && bmi < 18.50) {
        classification = "underweight";
      }
      if (bmi >= 18.50 && bmi < 25.00) {
        classification = "have an healthy weight";
      }
      if (bmi >= 25.00 && bmi < 30.00) {
        classification = "'re overweight";
      }
      if (bmi >= 30.00 && bmi < 35.00) {
        classification = "'re obese (Type 1)";
      }
      if (bmi >= 35.00 && bmi < 40.00) {
        classification = "'re obese (Type 2)";
      }
      if (bmi >= 40.00) {
        classification = "'re obese (Type 3)";
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
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: const Color.fromARGB(25, 189, 189, 200),
          centerTitle: true,
          title: Text(
            widget.title,
            style: theme.textTheme.bodyMedium,
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: 150,
                            child: Column(children: [
                              Text("Height (cm)",
                                  style: theme.textTheme.bodySmall),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: controller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    hideWidget();
                                    return 'Please enter a\nvalid value';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelStyle:
                                        theme.inputDecorationTheme.labelStyle),
                              )
                            ])),
                        SizedBox(
                            width: 150,
                            child: Column(children: [
                              Text("Weight (kg)",
                                  style: theme.textTheme.bodySmall),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: controller1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    hideWidget();
                                    return 'Please enter a\nvalid value';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelStyle:
                                        theme.inputDecorationTheme.labelStyle),
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
                              bmiClassification(bmi!);
                            }
                          },
                          child: Text('Calculate!',
                              style: theme.textTheme.titleSmall),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink[200],
                          ),
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
                                    style: theme.textTheme.bodyMedium),
                                Text('You $classification',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium)
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
