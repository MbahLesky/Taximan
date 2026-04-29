import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class DocumentUploadScreen extends StatelessWidget {
  const DocumentUploadScreen({super.key});

  static const documents = [
    'National ID',
    'Driver license',
    'Vehicle registration',
    'Insurance',
    'Road worthiness',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload documents')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          ...documents.map(
            (document) => AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.upload_file, color: AppColors.primaryDark),
                title: Text(document),
                subtitle: const Text('Upload placeholder'),
                trailing: const Icon(Icons.add_circle_outline),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue', onPressed: () => context.go('/profile-photo')),
        ],
      ),
    );
  }
}
