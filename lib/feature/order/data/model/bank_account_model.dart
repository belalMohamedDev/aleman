class BankAccountModel {
  final int id;
  final String bankName;
  final String accountNumber;
  final String iban;
  final String accountHolderName;
  final String? branchName;
  final String? swiftCode;
  final String? logoUrl;
  final bool isActive;

  const BankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.iban,
    required this.accountHolderName,
    this.branchName,
    this.swiftCode,
    this.logoUrl,
    this.isActive = true,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      bankName: json['bankName'] as String? ?? 'البنك الأهلي المصري',
      accountNumber: json['accountNumber'] as String? ?? '',
      iban: json['iban'] as String? ?? '',
      accountHolderName:
          json['accountHolderName'] as String? ?? 'شركة آل إيمان للأعلاف',
      branchName: json['branchName'] as String?,
      swiftCode: json['swiftCode'] as String?,
      logoUrl: json['logoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bankName': bankName,
        'accountNumber': accountNumber,
        'iban': iban,
        'accountHolderName': accountHolderName,
        'branchName': branchName,
        'swiftCode': swiftCode,
        'logoUrl': logoUrl,
        'isActive': isActive,
      };
}
