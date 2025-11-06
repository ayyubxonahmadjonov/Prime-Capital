// user_model.dart
class UserModel {
  final int id;
  final String email;
  final String name;
  final String? firstName;
  final String? phoneNumber;
  final String? avatar;
  final double phpInvestBalance;
  final double phpReitBalance;
  final double totalBalance;
  final bool pushNotifications;
  final bool isPhoneVerified;
  final List<BalanceHistoryModel> balanceHistory;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.firstName,
    this.phoneNumber,
    this.avatar,
    required this.phpInvestBalance,
    required this.phpReitBalance,
    required this.totalBalance,
    required this.pushNotifications,
    required this.isPhoneVerified,
    required this.balanceHistory,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      avatar: json['avatar']?.toString(),

      // String yoki num → double
      phpInvestBalance: _toDouble(json['php_invest_balance']),
      phpReitBalance: _toDouble(json['php_reit_balance']),
      totalBalance: _toDouble(json['total_balance']),

      pushNotifications: json['push_notifications'] as bool? ?? false,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,

      balanceHistory: (json['balance_history'] as List<dynamic>?)
              ?.map((e) => BalanceHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Helper: xavfsiz double konvertatsiya
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
// balance_history_model.dart
class BalanceHistoryModel {
  final String id;
  final DateTime ts;
  final double oldInvest;
  final double oldReit;
  final double newInvest;
  final double newReit;
  final double diffInvest;
  final double diffReit;
  final double total;

  BalanceHistoryModel({
    required this.id,
    required this.ts,
    required this.oldInvest,
    required this.oldReit,
    required this.newInvest,
    required this.newReit,
    required this.diffInvest,
    required this.diffReit,
    required this.total,
  });

  factory BalanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return BalanceHistoryModel(
      id: json['id']?.toString() ?? '',
      ts: _parseDateTime(json['ts']),
      oldInvest: _toDouble(json['old_invest']),
      oldReit: _toDouble(json['old_reit']),
      newInvest: _toDouble(json['new_invest']),
      newReit: _toDouble(json['new_reit']),
      diffInvest: _toDouble(json['diff_invest']),
      diffReit: _toDouble(json['diff_reit']),
      total: _toDouble(json['total']),
    );
  }

  // Helper: xavfsiz double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper: ISO string → DateTime
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ts': ts.toIso8601String(),
      'old_invest': oldInvest,
      'old_reit': oldReit,
      'new_invest': newInvest,
      'new_reit': newReit,
      'diff_invest': diffInvest,
      'diff_reit': diffReit,
      'total': total,
    };
  }
}