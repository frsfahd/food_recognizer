String toPercentage(num value, {int decimalPlaces = 2}) {
  return '${(value * 100).toStringAsFixed(decimalPlaces)}%';
}
