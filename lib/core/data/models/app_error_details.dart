import 'package:uuid/uuid.dart';

class AppErrorDetails {
  AppErrorDetails({
    String? id,
    required this.title,
    this.message,
    required this.error,
    this.stackTrace,
    this.appFlavor,
    this.appVersion,
    this.deviceDetails,
    this.extras,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String? message;
  final String error;
  final String? stackTrace;
  final String? appFlavor;
  final String? appVersion;
  final String? deviceDetails;
  final Map<String, String>? extras;
  final DateTime createdAt;

  AppErrorDetails copyWith({
    String? title,
    String? message,
    String? error,
    String? stackTrace,
    String? appFlavor,
    String? appVersion,
    String? deviceDetails,
    Map<String, String>? extras,
  }) {
    return AppErrorDetails(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      appFlavor: appFlavor ?? this.appFlavor,
      appVersion: appVersion ?? this.appVersion,
      deviceDetails: deviceDetails ?? this.deviceDetails,
      createdAt: createdAt,
      extras: extras ?? this.extras,
    );
  }

  String get gitHubIssueDetails {
    final body = StringBuffer();

    if (message != null && message!.isNotEmpty) {
      body.writeln('**Message**: $message');
    }
    if (error.isNotEmpty) {
      body.writeln('\n**Error**: $error');
    }
    if (stackTrace?.isNotEmpty ?? false) {
      body.writeln('\n### Stack Trace\n$stackTrace');
    }
    body.writeln('\n### Environment');
    if (appFlavor != null && appFlavor!.isNotEmpty) {
      body.writeln('- **App Flavor**: $appFlavor');
    }
    if (appVersion != null && appVersion!.isNotEmpty) {
      body.writeln('- **App Version**: $appVersion');
    }
    if (deviceDetails != null && deviceDetails!.isNotEmpty) {
      body.writeln('- **Device Details**: $deviceDetails');
    }
    body.writeln('- **Crashed At**: $createdAt');
    if (extras != null && extras!.isNotEmpty) {
      body.writeln('\n### Extras\n$extras');
    }

    return body.toString();
  }

  @override
  String toString() {
    return '''
AppErrorDetails(
  id: $id,
  title: $title,
  message: $message,
  error: $error,
  stackTrace: $stackTrace,
  environment: $appFlavor,
  appVersion: $appVersion,
  deviceDetails: $deviceDetails,
  createdAt: $createdAt,
  extras: $extras,
)
    ''';
  }
}
