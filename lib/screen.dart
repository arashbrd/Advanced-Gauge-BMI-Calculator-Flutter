import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController weightCntl =
      TextEditingController();
  TextEditingController heightCntl =
      TextEditingController();
  String buttonText = 'Tap the Button';
  final ValueNotifier<double>
      _needleValueNotifier =
      ValueNotifier<double>(0.0);

  final formKey = GlobalKey<FormState>();
  int group = 1;
  bool isUsMetric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BMI CALCULATOR'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,
                  children: [
                    const Text('Metric Units'),
                    Radio(
                      value: 1,
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          group = value!;
                          isUsMetric = false;
                        });
                      },
                    ),
                    const Text('US Units'),
                    Radio(
                      value: 2,
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          group = value!;
                          isUsMetric = true;
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets
                                .symmetric(
                            horizontal: 10.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .deny(
                              RegExp("[a-z]+"),
                            ),
                          ],
                          validator:
                              (String? value) {
                                try{
                                  if (value!.isEmpty) {
                              return "Empty Value!!";
                            }
                            var numValue =
                                int.tryParse(
                                    value);
                            if (numValue! > 180 ||
                                numValue < 5) {
                              return 'Enter between 5-200';
                            }
                            
                                }on Exception catch(e){
                                  return '$e';
                                }
                            return null;
                          },
                          controller: weightCntl,
                          textAlign:
                              TextAlign.center,
                          decoration:
                              const InputDecoration(
                                  hintText:
                                      'Weight'),
                          keyboardType:
                              TextInputType
                                  .number,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets
                                .symmetric(
                            horizontal: 10.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .deny(
                              RegExp("[a-z]+"),
                            ),
                          ],
                          validator:
                              (String? value) {
                            var numValue =
                                int.tryParse(
                                    value!);
                            if (numValue! > 220 ||
                                numValue < 30) {
                              return 'Enter between 30-220';
                            }
                            if (value.isEmpty) {
                              return "Empty Value!!";
                            }
                            return null;
                          },
                          controller: heightCntl,
                          textAlign:
                              TextAlign.center,
                          decoration:
                              const InputDecoration(
                                  hintText:
                                      'Height'),
                          keyboardType:
                              TextInputType
                                  .number,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    formKey.currentState!
                            .validate()
                        ? changeText()
                        : ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                                const SnackBar(
                            content: Text(
                                'Try again...'),
                          ));
                  },
                  child:
                      const Text('Calculate BMI'),
                ),
                const SizedBox(height: 15),
                Text(
                  buttonText,
                  style: const TextStyle(
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 330,
                  width: 330,
                  child: MyGauge(
                      needleValueNotifier:
                          _needleValueNotifier),
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 100,
                  endIndent: 100,
                  color: Colors.brown,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0,10,20),
                  child: CardExample(
                    info1: buttonText,
                    info2:
                        'More information about your BMI',
                    info3:
                        'your stage is $buttonText',
                    info4:
                        'you should do this steps:\n${guideAsStage(buttonText)}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //! functions--Starts
  void changeText() {
    setState(() {
      _needleValueNotifier.value = double.parse(
        bmiCalcuator(
          double.parse(weightCntl.text),
          double.parse(heightCntl.text),isUsMetric: isUsMetric
        ),
      );

      buttonText = resultChecker(
          _needleValueNotifier.value);
    });
  }

  String resultChecker(double bmi) {
    String res = '';
    switch (bmi) {
      case > 40:
        {
          res = 'Obese Class III';
        }
        break;
      case >= 35 && <= 40:
        {
          res = 'Obese Class II';
        }
        break;
      case >= 30 && < 35:
        {
          res = 'Obese Class I';
        }
        break;
      case >= 25 && < 30:
        {
          res = 'Overweight';
        }
        break;
      case >= 18.5 && < 25:
        {
          res = 'Normal';
        }
      case >= 17 && < 18.5:
        {
          res = 'Mild Thinness';
        }
        break;
      case >= 16 && < 17:
        {
          res = 'Moderate Thinness';
        }
      case < 16:
        {
          res = 'Severe Thinness';
        }
        break;
    }

    return res;
  }

  String bmiCalcuator(
      double weight, double height,
      {bool isUsMetric = false}) {
    if (!isUsMetric) {
      try {
        double res1 =
            (weight / pow(height, 2)) * 10000;

        return res1.toStringAsFixed(2);
      } on Exception catch (e) {
        return e.toString();
      }
    } else {
      try {
        double res1 =
            703 *(weight / pow(height, 2)) * 10000;

        return res1.toStringAsFixed(2);
      } on Exception catch (e) {
        return e.toString();
      }
    }
  }

  String guideAsStage(String stage) {
    String res = '';
    switch (stage) {
      case 'Obese Class III':
        {
          res = '1-Eat lessss\n2-Do more';
        }
        break;
      case 'Obese Class II':
        {
          res = '1-Eat lesss\n2-Do more';
        }
        break;
      case 'Obese Class I':
        {
          res = '1-Eat less\n2-Do more';
        }
        break;
      case 'Overweight':
        {
          res = '1-Eat less\n';
        }
        break;
      case 'Normal':
        {
          res = '1-Eat as you want\n';
        }
        break;
      case 'Mild Thinness':
        {
          res = '1-Eat moore\n';
        }
        break;
      case 'Moderate Thinness':
        {
          res = '1-Eat moooore\n';
        }
        break;
      case 'Severe Thinness':
        {
          res = '1-Eat moooooore\n';
        }
        break;
    }
    return res;
  }
  //! functions--Ends
}

