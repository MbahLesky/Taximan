import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? readDateTime(Object? value) {
  if (value is DateTime) {
    return value;
  }
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

Object? writeDateTime(DateTime? value) => value?.toIso8601String();
