import 'package:navinotes/packages.dart';

String formatRelativeTime(int unixTimestamp) {
  final updated = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
  final now = DateTime.now();
  final diff = now.difference(updated);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes} minutes ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  if (diff.inDays == 1) return 'Yesterday';
  return '${diff.inDays} days ago';
}

String formatUnixTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateFormat('MMM d, yyyy').format(date);
}

int generateUnixTimestamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
