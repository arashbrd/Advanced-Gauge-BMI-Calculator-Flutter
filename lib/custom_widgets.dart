import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';


class MyGauge extends StatelessWidget {
  const MyGauge({
    super.key,
    required ValueNotifier<double>
        needleValueNotifier,
  }) : _needleValueNotifier = needleValueNotifier;

  final ValueNotifier<double>
      _needleValueNotifier;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 50,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 50,
              color: Colors.green,
            ),
            GaugeRange(
              startValue: 0,
              endValue: 16,
              color: const Color(0xFFbc2020),
            ),
            GaugeRange(
              startValue: 16,
              endValue: 17,
              color: const Color(0xFFd38888),
            ),
            GaugeRange(
              startValue: 17,
              endValue: 18.5,
              color: const Color(0xFF008137),
            ),
            GaugeRange(
              startValue: 18.5,
              endValue: 25,
              color: const Color(0xFF008137),
            ),
            GaugeRange(
              startValue: 25,
              endValue: 30,
              color: const Color(0xFFffe400),
            ),
            GaugeRange(
              startValue: 35,
              endValue: 40,
              color: const Color(0xFFbc2020),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 50,
              color: const Color(0xFF8a0101),
            ),
          ],
          annotations: [
            GaugeAnnotation(
                widget: Text(
                    _needleValueNotifier.value
                        .toString(),
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight:
                            FontWeight.bold)),
                angle: 90,
                positionFactor: 0.5)
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              enableAnimation: true,
              value: _needleValueNotifier.value,
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CardExample extends StatelessWidget {
  CardExample(
      {super.key,
      required this.info1,
      required this.info2,
      required this.info3,
      required this.info4});
  String info1 = '';
  String info2 = '';
  String info3 = '';
  String info4 = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.amber[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(info1),
              subtitle: Text(info2),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: _launchURL,
                  child:
                      const Text('GO to website'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('See More'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext
                            context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context);
                                  },
                                  child:
                                      const Text(
                                          'OK'))
                            ],
                            title: Text(info3),
                            content: Text(info4),
                          );
                        });
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.calculator.net/bmi-calculator.html');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
