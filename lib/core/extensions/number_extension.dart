import 'package:easy_localization/easy_localization.dart';

extension NumberFormatExtension on num {
  String get asThousands {
    final formatter = NumberFormat('#,##,###.##');
    return formatter.format(this);
  }
}
