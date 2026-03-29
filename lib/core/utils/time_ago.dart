import 'package:intl/intl.dart';

/// Returns a human-readable relative time string for [dateTime].
///
/// - "Just now" (< 1 min)
/// - "X min ago" (1–59 min)
/// - "X hours ago" (1–23 hours)
/// - "Yesterday" (24–47 hours)
/// - "X days ago" (2–6 days)
/// - "dd/MM/yyyy" (7+ days)
String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) {
    final h = diff.inHours;
    return '$h ${h == 1 ? 'hour' : 'hours'} ago';
  }
  if (diff.inHours < 48) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays} days ago';
  return DateFormat('dd/MM/yyyy').format(dateTime);
}
