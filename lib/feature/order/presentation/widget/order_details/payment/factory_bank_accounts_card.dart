import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class FactoryBankAccountsCard extends StatelessWidget {
  final List<BankAccountModel> accounts;
  final double totalAmount;

  const FactoryBankAccountsCard({
    super.key,
    required this.accounts,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.bank,
                  color: ColorManger.primaryLight,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بيانات الحسابات البنكية المعتمدة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'قم بالتحويل لأي من الحسابات التالية بالمبلغ المطلوب',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Required total amount banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManger.goldDark.withValues(alpha: 0.12),
                  ColorManger.gold.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: ColorManger.goldDark.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.money_send,
                      size: 18.sp,
                      color: ColorManger.goldDark,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'المبلغ المطلوب تحويله:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorManger.primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$totalAmount ج.م',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.goldDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          ...accounts.map((account) => _buildAccountItem(context, account)),
        ],
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, BankAccountModel account) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.card_pos,
                size: 16.sp,
                color: ColorManger.primaryLight,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  account.bankName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
              ),
              if (account.branchName != null)
                Text(
                  account.branchName!,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildCopyableRow(
            context: context,
            label: 'اسم الحساب',
            value: account.accountHolderName,
            allowCopy: false,
          ),
          SizedBox(height: 6.h),
          _buildCopyableRow(
            context: context,
            label: 'رقم الحساب',
            value: account.accountNumber,
            allowCopy: true,
          ),
          if (account.iban.isNotEmpty) ...[
            SizedBox(height: 6.h),
            _buildCopyableRow(
              context: context,
              label: 'الآيبان (IBAN)',
              value: account.iban,
              allowCopy: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCopyableRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool allowCopy,
  }) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textDirection: allowCopy ? TextDirection.ltr : null,
            textAlign: allowCopy ? TextAlign.left : TextAlign.right,
          ),
        ),
        if (allowCopy) ...[
          SizedBox(width: 6.w),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
            },
            borderRadius: BorderRadius.circular(4.r),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Icon(
                Iconsax.copy,
                size: 15.sp,
                color: ColorManger.primaryLight,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
