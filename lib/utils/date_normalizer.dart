import 'package:intl/intl.dart';

/// Normalizes various date formats to ISO 8601 format (YYYY-MM-DD)
class DateNormalizer {
  /// Normalize a date string that might be in various formats
  /// Returns null if the date cannot be parsed or is empty/null
  static String? normalize(String? dateStr, {DateTime? referenceDate}) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return null;
    }

    final cleanDate = dateStr.trim();
    final now = DateTime.now();
    final reference = referenceDate ?? now;

    try {
      // Try parsing as ISO date first (YYYY-MM-DD)
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(cleanDate)) {
        final date = DateTime.parse(cleanDate);
        return _formatDate(date);
      }

      // Try parsing full datetime
      if (cleanDate.contains('T') || cleanDate.contains(':')) {
        final date = DateTime.parse(cleanDate);
        return _formatDate(date);
      }

      // Try parsing "Month Day" format (e.g., "April 30", "Nov 15")
      final monthDayMatch = RegExp(
        r'^([A-Za-z]+)\.?\s+(\d{1,2})(?:st|nd|rd|th)?$',
      ).firstMatch(cleanDate);
      
      if (monthDayMatch != null) {
        final monthStr = monthDayMatch.group(1)!;
        final day = int.parse(monthDayMatch.group(2)!);
        final month = _parseMonth(monthStr);
        
        if (month != null) {
          return _normalizeMonthDay(month, day, reference);
        }
      }

      // Try parsing "Month Day, Year" format (e.g., "April 30, 2024")
      final monthDayYearMatch = RegExp(
        r'^([A-Za-z]+)\.?\s+(\d{1,2})(?:st|nd|rd|th)?,?\s+(\d{4})$',
      ).firstMatch(cleanDate);
      
      if (monthDayYearMatch != null) {
        final monthStr = monthDayYearMatch.group(1)!;
        final day = int.parse(monthDayYearMatch.group(2)!);
        final year = int.parse(monthDayYearMatch.group(3)!);
        final month = _parseMonth(monthStr);
        
        if (month != null) {
          final date = DateTime(year, month, day);
          return _formatDate(date);
        }
      }

      // Try parsing "MM/DD/YYYY" or "DD/MM/YYYY"
      final slashMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(cleanDate);
      if (slashMatch != null) {
        final part1 = int.parse(slashMatch.group(1)!);
        final part2 = int.parse(slashMatch.group(2)!);
        final year = int.parse(slashMatch.group(3)!);
        
        // Assume MM/DD/YYYY format (US style)
        if (part1 <= 12) {
          final date = DateTime(year, part1, part2);
          return _formatDate(date);
        }
      }

      // Try parsing "Day Month" format (e.g., "30 April", "15 Nov")
      final dayMonthMatch = RegExp(
        r'^(\d{1,2})(?:st|nd|rd|th)?\s+([A-Za-z]+)\.?$',
      ).firstMatch(cleanDate);
      
      if (dayMonthMatch != null) {
        final day = int.parse(dayMonthMatch.group(1)!);
        final monthStr = dayMonthMatch.group(2)!;
        final month = _parseMonth(monthStr);
        
        if (month != null) {
          return _normalizeMonthDay(month, day, reference);
        }
      }

      return null;
    } catch (e) {
      print('Error normalizing date "$dateStr": $e');
      return null;
    }
  }

  /// Normalize month-day to full date, determining the year based on reference date
  static String _normalizeMonthDay(int month, int day, DateTime reference) {
    int year = reference.year;
    
    // Create date with current year
    var date = DateTime(year, month, day);
    
    // If the date is more than 6 months in the past, assume it's next year
    if (date.isBefore(reference) && 
        reference.difference(date).inDays > 180) {
      year++;
      date = DateTime(year, month, day);
    }
    
    return _formatDate(date);
  }

  /// Parse month name to month number (1-12)
  static int? _parseMonth(String monthStr) {
    final monthLower = monthStr.toLowerCase();
    
    const months = {
      'january': 1, 'jan': 1,
      'february': 2, 'feb': 2,
      'march': 3, 'mar': 3,
      'april': 4, 'apr': 4,
      'may': 5,
      'june': 6, 'jun': 6,
      'july': 7, 'jul': 7,
      'august': 8, 'aug': 8,
      'september': 9, 'sep': 9, 'sept': 9,
      'october': 10, 'oct': 10,
      'november': 11, 'nov': 11,
      'december': 12, 'dec': 12,
    };
    
    return months[monthLower];
  }

  /// Format date to ISO 8601 string (YYYY-MM-DD)
  static String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Normalize a list of dates, ensuring they follow chronological order
  /// If a date appears to be before the previous one, it's assumed to be in the next year
  static List<String?> normalizeSequence(List<String?> dates) {
    final normalized = <String?>[];
    DateTime? lastDate;

    for (final dateStr in dates) {
      if (dateStr == null || dateStr.trim().isEmpty) {
        normalized.add(null);
        continue;
      }

      final normalizedDate = normalize(dateStr, referenceDate: lastDate);
      
      if (normalizedDate != null) {
        var parsedDate = DateTime.parse(normalizedDate);
        
        // If this date is before the last date, assume it's next year
        if (lastDate != null && parsedDate.isBefore(lastDate)) {
          parsedDate = DateTime(
            parsedDate.year + 1,
            parsedDate.month,
            parsedDate.day,
          );
        }
        
        final finalDate = _formatDate(parsedDate);
        normalized.add(finalDate);
        lastDate = parsedDate;
      } else {
        normalized.add(null);
      }
    }

    return normalized;
  }
}
