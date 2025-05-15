// test/distance_calculator_test.dart
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371; // Earth radius in km
  double dLat = (lat2 - lat1) * pi / 180;
  double dLon = (lon2 - lon1) * pi / 180;
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c; // Distance in km
}

void main() {
  group('calculateDistance', () {
    test('returns 0 for same coordinates', () {
      double distance = calculateDistance(0, 0, 0, 0);
      expect(distance, 0);
    });

    test('returns correct distance between two cities', () {
      // Distance between New York (40.7128° N, 74.0060° W)
      // and Los Angeles (34.0522° N, 118.2437° W) is approx 3936 km
      double distance = calculateDistance(40.7128, -74.0060, 34.0522, -118.2437);
      expect(distance, closeTo(3936, 5)); // within 5 km tolerance
    });

    test('returns correct distance across equator', () {
      double distance = calculateDistance(-1.0, 36.0, 1.0, 36.0);
      expect(distance, closeTo(222, 1)); // ~111 km per degree latitude
    });

    test('returns correct distance for positive values', () {
      double distance = calculateDistance(10.0, 20.0, 30.0, 40.0);
      expect(distance, closeTo(3140, 10));
    });

    test('returns correct distance for negative values', () {
      double distance = calculateDistance(-10.0, -20.0, -30.0, -40.0);
      expect(distance, closeTo(3140, 10));
    });

    test('returns correct distance when longitude difference is > 180', () {
      double distance = calculateDistance(0.0, 170.0, 0.0, -170.0);
      expect(distance, closeTo(2224, 1));
    });

    test('returns 0 when points are very close', () {
      double distance = calculateDistance(0.0001, 0.0001, 0.0002, 0.0002);
      expect(distance, closeTo(0, 0.01));
    });
  });
}
