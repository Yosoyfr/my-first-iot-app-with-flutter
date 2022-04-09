import 'package:flutter/material.dart';
import 'package:iot_app/api/metrics_api.dart';
import 'package:iot_app/models/metric.dart';
import 'package:iot_app/utils/date.dart';
import 'package:iot_app/widgets/line_chart.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:collection/collection.dart';
import 'package:lottie/lottie.dart';
import 'package:iot_app/widgets/error.dart';
import 'package:iot_app/widgets/loader.dart';

import '../helpers/streams.dart';
import '../widgets/rounded_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCFF),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: const [
                Body(),
                BottomModal(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(25),
            color: const Color(0xFF5B1BED),
            child: const BottomMenuBar(),
          ),
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  static final MetricsAPI _api = MetricsAPI.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 1, child: Header()),
          Expanded(
            flex: 4,
            child: StreamBuilder(
                stream: Streams.onceAndPeriodic(
                    const Duration(seconds: 30), (i) => i).asyncMap(
                  (i) => _api.getMetricsFromDevice(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final metric = (snapshot.data as List<Metric>).last;
                    return Column(
                      children: [
                        Lottie.asset('assets/hot.json', reverse: true),
                        Column(
                          children: [
                            const Text(
                              'Temp',
                              style: TextStyle(
                                color: Color(0xFFBEC6DD),
                              ),
                            ),
                            Text(
                              '${metric.temperature}°C',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF26376D)),
                            )
                          ],
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Error(
                      text: 'Something went wrong',
                      color: Colors.white,
                    );
                  }
                  return const Loader();
                }),
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today, ${Date.getHomeScreenDate()}',
          style: const TextStyle(color: Color(0xFFBEC6DD)),
        ),
        const Text(
          'IoT-001',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          HomeButton(),
          LightButton(),
        ],
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: const Color(0xFFEAE9F7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(
            Icons.home_outlined,
            color: Color(0xFF5F6FA2),
          ),
          SizedBox(width: 5),
          Text(
            'Home',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF707FAD),
            ),
          ),
        ],
      ),
    );
  }
}

class LightButton extends StatefulWidget {
  const LightButton({Key? key}) : super(key: key);

  @override
  State<LightButton> createState() => _LightButtonState();
}

class _LightButtonState extends State<LightButton> {
  bool isLightTurnedOn = false;
  final MetricsAPI _api = MetricsAPI.instance;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLightTurnedOn ? Icons.lightbulb : Icons.lightbulb_outline,
        color: const Color(0xFF5F6FA2),
      ),
      onPressed: () {
        setState(() {
          isLightTurnedOn = !isLightTurnedOn;
        });
        _api.toggleLight(isLightTurnedOn);
      },
    );
  }
}

class BottomModal extends StatelessWidget {
  const BottomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? childWidget;
    //TODO: check if issue was updated: https://github.com/flutter/flutter/issues/67219
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: ((context, scrollController) {
        childWidget ??= Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: ModalBody(
            scrollController: scrollController,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF5B1BED),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
        );
        return childWidget!;
      }),
    );
  }
}

class ModalBody extends StatelessWidget {
  ModalBody({Key? key, required this.scrollController}) : super(key: key);
  final ScrollController scrollController;

  final MetricsAPI _api = MetricsAPI.instance;

  final List<Metric> metrics = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Streams.onceAndPeriodic(const Duration(seconds: 30), (i) => i)
            .asyncMap(
          (i) => _api.getMetricsFromDevice(),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (metrics.isNotEmpty && metrics.length > 10) {
              metrics.removeAt(0);
            }
            final metric = (snapshot.data as List<Metric>).last;

            metrics.add(metric);

            final spots = metrics.mapIndexed((index, metric) {
              return fl.FlSpot(
                index.toDouble(),
                metric.temperature.toDouble(),
              );
            }).toList();

            return ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125),
                  child: Container(
                    color: const Color(0xFF8C6AE5),
                    height: 4,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Temperature (°C)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                LineChart(
                  spots: spots,
                  height: 250,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => MetricCard(
                    metric: metrics[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: metrics.length,
                )
              ],
              controller: this.scrollController,
            );
          }
          if (snapshot.hasError) {
            return const Error(
              text: 'Something went wrong',
              color: Colors.white,
            );
          }
          return const Loader();
        } // builder should also handle the case when data is not fetched yet
        );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    Key? key,
    required this.metric,
  }) : super(key: key);

  final Metric metric;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: const Color(0xFF642FF3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${metric.temperature} °C',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            Date.getFormattedDate(metric.date),
            style: const TextStyle(
              color: Color(0xFF9672F6),
            ),
          ),
        ],
      ),
    );
  }
}
