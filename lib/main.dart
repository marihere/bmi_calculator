import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
          displayMedium: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
          bodyMedium: GoogleFonts.poppins(color: Colors.black, fontSize: 32),
          bodySmall: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
          titleSmall: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 1.25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.25),
          ),
        ),
      ),
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
  double bmi = 0;
  String classification = "error";
  Color? color;

  void bmiClassification(double bmi) {
    setState(() {
      if (bmi < 16.00) {
        classification = "are severely underweight";
        color = Colors.blue[900];
      }
      if (bmi >= 16.00 && bmi < 18.50) {
        classification = "are underweight";
        color = Colors.blue;
      }
      if (bmi >= 18.50 && bmi < 25.00) {
        classification = "have an healthy weight";
        color = Colors.green;
      }
      if (bmi >= 25.00 && bmi < 30.00) {
        classification = "are overweight";
        color = Colors.orange;
      }
      if (bmi >= 30.00 && bmi < 35.00) {
        classification = "are obese (Type 1)";
        color = Colors.orange[900];
      }
      if (bmi >= 35.00 && bmi < 40.00) {
        classification = "are obese (Type 2)";
        color = Colors.red;
      }
      if (bmi >= 40.00) {
        classification = "are obese (Type 3)";
        color = Colors.red[900];
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.title,
            style: theme.textTheme.displayMedium,
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 160,
                        height: 200,
                        child: Column(children: [
                          Text("Height (cm)", style: theme.textTheme.bodySmall),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: controller,
                            validator: (value) {
                              int intvalue = 0;
                              if (value == null || value.isEmpty) {
                                return 'Enter a valid\nvalue';
                              }

                              intvalue = int.parse(value);
                              if (intvalue <= 0) {
                                return 'Enter a positive\nnumber';
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                                labelStyle:
                                    theme.inputDecorationTheme.labelStyle),
                          )
                        ])),
                    SizedBox(
                        width: 160,
                        height: 200,
                        child: Column(children: [
                          Text("Weight (kg)", style: theme.textTheme.bodySmall),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: controller1,
                            validator: (value) {
                              int intvalue = 0;
                              if (value == null || value.isEmpty) {
                                return 'Enter a valid\nvalue';
                              }

                              intvalue = int.parse(value);
                              if (intvalue <= 0) {
                                return 'Enter a positive\nnumber';
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                                labelStyle:
                                    theme.inputDecorationTheme.labelStyle),
                          )
                        ])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.white,
          ),
          SizedBox(
            height: 60,
            width: 170,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  bmi = double.parse((double.parse(controller1.text) /
                          pow((double.parse(controller.text) / 100), 2))
                      .toStringAsFixed(2));
                  bmiClassification(bmi);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BMIResult(
                          bmi: bmi,
                          classification: classification,
                          color: color)));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Calculate', style: theme.textTheme.titleSmall),
            ),
          ),
        ],
      ),
    );
  }
}

class BMIResult extends StatefulWidget {
  const BMIResult(
      {Key? key,
      required this.bmi,
      required this.classification,
      required this.color})
      : super(key: key);

  final double bmi;
  final String classification;
  final Color? color;

  @override
  State<BMIResult> createState() => _BMIResultState();
}

class _BMIResultState extends State<BMIResult> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SizedBox(
            height: 400,
            width: double.infinity,
            child: Column(
              children: [
                Stack(alignment: AlignmentDirectional.center, children: [
                  CircleAvatar(radius: 70, backgroundColor: widget.color),
                  Text('${widget.bmi}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ]),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: SfLinearGauge(
                    maximum: 56,
                    showLabels: false,
                    ranges: <LinearGaugeRange>[
                      LinearGaugeRange(
                          startValue: 0, endValue: 16, color: Colors.blue[900]),
                      const LinearGaugeRange(
                          startValue: 16, endValue: 18.50, color: Colors.blue),
                      const LinearGaugeRange(
                          startValue: 18.51, endValue: 25, color: Colors.green),
                      const LinearGaugeRange(
                          startValue: 25.01,
                          endValue: 30,
                          color: Colors.orange),
                      LinearGaugeRange(
                          startValue: 30.01,
                          endValue: 35,
                          color: Colors.orange[900]),
                      const LinearGaugeRange(
                          startValue: 35.01, endValue: 40, color: Colors.red),
                      LinearGaugeRange(
                          startValue: 40.01,
                          endValue: 56,
                          color: Colors.red[900]),
                    ],
                    markerPointers: [
                      LinearShapePointer(value: widget.bmi),
                    ],
                  ),
                ),
                Text('You ${widget.classification}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall)
              ],
            )),
      ),
    );
  }
}
