import 'package:dio/dio.dart';
import 'package:iot_app/models/metric.dart';

// TODO: error handling

class MetricsAPI {
  MetricsAPI._internal();
  static MetricsAPI get instance => MetricsAPI._internal();

  final Dio _dio = Dio();

  Future<List<Metric>> getMetricsFromDevice({String device = "iot-001"}) async {
    final response = await _dio.get(
      'http://104.198.225.231:3000/magnitudes',
      queryParameters: {
        "device": device,
      },
    );

    final List<Metric> metrics = (response.data['magnitudes'] as List)
        .map((e) => Metric.fromJson(e))
        .toList();
    return metrics;
  }

  Future<bool> toggleLight(bool newState, {String device = "iot-001"}) async {
    final response = await _dio.post(
      'http://104.198.225.231:3000/automation',
      data: {
        "illumination": newState,
        "device": device,
      },
    );

    final success = response.data['msg'] == 'Success';
    return success;
  }
}
