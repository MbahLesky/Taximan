import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

class FareProposalScreen extends StatelessWidget {
  const FareProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Propose fare')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.payments_outlined),
              title: Text('Original fare'),
              subtitle: Text(DummyData.estimatedFare),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'Proposed fare',
            hint: 'Example: 3,500 FCFA',
            icon: Icons.edit,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'Optional message',
            hint: 'Short note to passenger',
            icon: Icons.message_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Submit proposal',
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
    );
  }
}
