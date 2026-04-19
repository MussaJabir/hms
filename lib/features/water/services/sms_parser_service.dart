import 'package:hms/features/water/models/parsed_sms_result.dart';

class SmsParserService {
  ParsedSmsResult parse(String smsText) {
    final raw = smsText;
    final text = _normalize(smsText);

    if (text.isEmpty) {
      return ParsedSmsResult(
        isSuccessful: false,
        rawText: raw,
        errorMessage: 'Empty SMS text',
      );
    }

    final amount = _extractAmount(text);
    final period = _extractBillingPeriod(text);
    final prevReading = _extractPreviousReading(text);
    final currReading = _extractCurrentReading(text);
    final dueDate = _extractDueDate(text);

    final anyFound =
        amount != null ||
        period != null ||
        prevReading != null ||
        currReading != null ||
        dueDate != null;

    return ParsedSmsResult(
      billAmount: amount,
      billingPeriod: period,
      previousMeterReading: prevReading,
      currentMeterReading: currReading,
      dueDate: dueDate,
      isSuccessful: anyFound,
      rawText: raw,
      errorMessage: anyFound ? null : 'No recognisable bill data found',
    );
  }

  String _normalize(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  double? _extractAmount(String text) {
    // Keywords: total, amount, bill, kiasi (amount), jumla (sum/total)
    final patterns = [
      RegExp(
        r'(?:total|amount\s*due|amount|bill|kiasi|jumla(?:\s+ya\s+bili)?)\s*:?\s*(?:tzs|tsh)?\s*([\d,]+(?:\.\d+)?)',
        caseSensitive: false,
      ),
      RegExp(r'(?:tzs|tsh)\s*([\d,]+(?:\.\d+)?)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(raw);
        if (value != null && value > 0) return value;
      }
    }
    return null;
  }

  String? _extractBillingPeriod(String text) {
    final monthNames = {
      'january': '01',
      'february': '02',
      'march': '03',
      'april': '04',
      'may': '05',
      'june': '06',
      'july': '07',
      'august': '08',
      'september': '09',
      'october': '10',
      'november': '11',
      'december': '12',
      'jan': '01',
      'feb': '02',
      'mar': '03',
      'apr': '04',
      'jun': '06',
      'jul': '07',
      'aug': '08',
      'sep': '09',
      'oct': '10',
      'nov': '11',
      'dec': '12',
      // Swahili month names
      'januari': '01',
      'februari': '02',
      'machi': '03',
      'aprili': '04',
      'mei': '05',
      'juni': '06',
      'julai': '07',
      'agosti': '08',
      'septemba': '09',
      'oktoba': '10',
      'novemba': '11',
      'desemba': '12',
    };

    // Pattern: "Period: March 2026" or "Billing Period: 03/2026" or "Kipindi: Machi 2026"
    final keywordMonthYear = RegExp(
      r'(?:period|billing\s+period|kipindi)\s*:?\s*([a-z]+)\s+(\d{4})',
      caseSensitive: false,
    );
    final matchMY = keywordMonthYear.firstMatch(text);
    if (matchMY != null) {
      final monthStr = matchMY.group(1)!.toLowerCase();
      final year = matchMY.group(2)!;
      final monthNum = monthNames[monthStr];
      if (monthNum != null) return '$year-$monthNum';
    }

    // Pattern: "03/2026" or "03-2026"
    final keywordSlash = RegExp(
      r'(?:period|billing\s+period|kipindi)\s*:?\s*(\d{1,2})[/\-](\d{4})',
      caseSensitive: false,
    );
    final matchSlash = keywordSlash.firstMatch(text);
    if (matchSlash != null) {
      final month = matchSlash.group(1)!.padLeft(2, '0');
      final year = matchSlash.group(2)!;
      return '$year-$month';
    }

    return null;
  }

  double? _extractPreviousReading(String text) {
    final patterns = [
      RegExp(
        r'(?:prev(?:ious)?\s*(?:meter\s*)?read(?:ing)?|old\s*read(?:ing)?|usomaji\s+uliopita)\s*:?\s*([\d,]+(?:\.\d+)?)',
        caseSensitive: false,
      ),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(raw);
        if (value != null) return value;
      }
    }
    return null;
  }

  double? _extractCurrentReading(String text) {
    final patterns = [
      RegExp(
        r'(?:curr(?:ent)?\s*(?:meter\s*)?read(?:ing)?|new\s*read(?:ing)?|usomaji\s+wa\s+sasa)\s*:?\s*([\d,]+(?:\.\d+)?)',
        caseSensitive: false,
      ),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(raw);
        if (value != null) return value;
      }
    }
    return null;
  }

  DateTime? _extractDueDate(String text) {
    // Keywords: due, due date, pay before, tarehe ya mwisho
    final patterns = [
      RegExp(
        r'(?:due\s*(?:date)?|pay\s+before|tarehe\s+ya\s+mwisho)\s*:?\s*(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{4})',
        caseSensitive: false,
      ),
      // yyyy-MM-dd after keyword
      RegExp(
        r'(?:due\s*(?:date)?|pay\s+before|tarehe\s+ya\s+mwisho)\s*:?\s*(\d{4})[/\-](\d{1,2})[/\-](\d{1,2})',
        caseSensitive: false,
      ),
    ];

    final match1 = patterns[0].firstMatch(text);
    if (match1 != null) {
      final day = int.tryParse(match1.group(1)!);
      final month = int.tryParse(match1.group(2)!);
      final year = int.tryParse(match1.group(3)!);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final match2 = patterns[1].firstMatch(text);
    if (match2 != null) {
      final year = int.tryParse(match2.group(1)!);
      final month = int.tryParse(match2.group(2)!);
      final day = int.tryParse(match2.group(3)!);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }
}
