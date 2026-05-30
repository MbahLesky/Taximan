import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class DocumentStatusScreen extends StatelessWidget {
  const DocumentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document status')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          ...DummyData.documents.map((document) {
            final status = document['status'] ?? '';
            final color = status == 'Approved'
                ? AppColors.success
                : status == 'Rejected'
                ? AppColors.error
                : AppColors.warning;
            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.description_outlined, color: color),
                title: Text(document['name'] ?? ''),
                subtitle: Text(status == 'Rejected' ? DummyData.rejectionReason : status),
                trailing: Text(
                  status,
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          AppButton(label: 'View rejected example', variant: AppButtonVariant.secondary, onPressed: () => context.go('/verification-rejected')),
        ],
      ),
    );
  }
}
