extension DurationExtension on Duration {
  /// Returns the duration in string format HH:MM:SS.
  String durationToHMS() {
    var hours = '$inHours';
    var minutes = '${inMinutes.remainder(60)}';
    var seconds = '${inSeconds.remainder(60)}';

    if (hours.length == 1) {
      hours = '0$hours';
    }
    if (minutes.length == 1) {
      minutes = '0$minutes';
    }
    if (seconds.length == 1) {
      seconds = '0$seconds';
    }

    return '$hours:$minutes:$seconds';
  }
}
