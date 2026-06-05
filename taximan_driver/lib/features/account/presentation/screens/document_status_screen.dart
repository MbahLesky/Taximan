import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../onboarding/application/providers/driver_providers.dart';
import '../../../onboarding/domain/driver_document_requirements.dart';

class DocumentStatusScreen extends ConsumerWidget {
  const DocumentStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(currentDriverProvider).valueOrNull;
    final documents =
        ref.watch(driverDocumentsProvider).valueOrNull ?? const [];
    final documentByType = {
      for (final document in documents) document.documentType: document,
    };
    final verificationStatus = driver?.verificationStatus ?? 'pending';
    final normalizedStatus = verificationStatus.toLowerCase();
    final canUpdateDocuments =
        normalizedStatus == 'rejected' ||
        requiredDriverDocuments.any(
          (document) => !documentByType.containsKey(document.type),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Document status')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.verified_user_outlined,
                color: _statusColor(verificationStatus),
              ),
              title: const Text('Verification status'),
              subtitle: Text(_statusLabel(verificationStatus)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...requiredDriverDocuments.map((requirement) {
            final document = documentByType[requirement.type];
            final status = document?.status ?? 'missing';
            final color = _statusColor(status);
            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.description_outlined, color: color),
                title: Text(requirement.label),
                subtitle: Text(
                  status == 'rejected'
                      ? document?.rejectionReason ??
                            'This document needs to be updated.'
                      : _statusLabel(status),
                ),
                trailing: Text(
                  _statusLabel(status),
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Update documents',
            variant: AppButtonVariant.secondary,
            onPressed: canUpdateDocuments
                ? () => context.go('/document-upload')
                : null,
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  return switch (status.toLowerCase()) {
    'approved' => AppColors.success,
    'rejected' || 'suspended' => AppColors.error,
    'missing' => AppColors.textSecondary,
    _ => AppColors.warning,
  };
}

String _statusLabel(String status) {
  return switch (status.toLowerCase()) {
    'approved' => 'Approved',
    'rejected' => 'Rejected',
    'suspended' => 'Suspended',
    'not_submitted' => 'Not submitted',
    'missing' => 'Missing',
    _ => 'Pending',
  };
}
