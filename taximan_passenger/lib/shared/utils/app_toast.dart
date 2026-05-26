import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  const AppToast._();

  static void success(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.success,
      title: title,
      description: description,
    );
  }

  static void warning(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.warning,
      title: title,
      description: description,
    );
  }

  static void error(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    _show(
      context,
      type: ToastificationType.error,
      title: title,
      description: description,
      duration: const Duration(seconds: 5),
    );
  }

  static void _show(
    BuildContext context, {
    required ToastificationType type,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      showProgressBar: true,
      closeOnClick: true,
      dragToClose: true,
      title: Text(title),
      description: description == null ? null : Text(description),
    );
  }
}
