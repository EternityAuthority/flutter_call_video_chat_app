import 'package:intl/intl.dart';

String formatDate(date) {
  if (date != null) {
    date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);

    return '${DateFormat('MMMM d').format(date)}, ${DateFormat("yyyy").format(date)}';
  } else {
    return '';
  }
}

String formatMessageDate(DateTime date) {
  if (date != null) {
    final df = new DateFormat('dd-MM-yyyy hh:mm:ss');

    return df.format(date);
  } else {
    return '';
  }
}

String formatTime(date) {
  if (date != null) {
    date = DateFormat('yyyy-MM-dd hh:mm:ss').parse(date);

    return '${DateFormat("hh:mm a").format(date)} ';
  } else {
    return '';
  }
}
