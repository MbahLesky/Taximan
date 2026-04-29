import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool reportIssue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppTextField(
            label: 'Comment',
            hint: 'Tell us about your ride',
            icon: Icons.chat_bubble_outline,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: reportIssue,
              title: const Text('Report an issue'),
              subtitle: const Text('Flag this trip for support review later.'),
              onChanged: (value) => setState(() => reportIssue = value ?? false),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Submit feedback', onPressed: () => context.go('/home')),
        ],
      ),
    );
  }
}
