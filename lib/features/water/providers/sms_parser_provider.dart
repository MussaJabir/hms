import 'package:hms/features/water/services/sms_parser_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sms_parser_provider.g.dart';

@riverpod
SmsParserService smsParserService(Ref ref) => SmsParserService();
