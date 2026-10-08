const _months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];

String clockTime(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${d.hour < 12 ? 'am' : 'pm'}';
}

String dayMonth(DateTime d) => '${d.day} ${_months[d.month - 1]}';

bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
