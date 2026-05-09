class DateUtils {
  DateUtils._();
  static String formatTimestamp(DateTime? dt) {
    if (dt == null) return 'Never';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${_p(dt.day)}/${_p(dt.month)}/${dt.year} ${_p(dt.hour)}:${_p(dt.minute)}';
  }
  static String _p(int n) => n.toString().padLeft(2, '0');
}
