import 'package:flutter/material.dart';

/// Nenásilná nabídka IAP/Pass po happy momentu.
class UpsellCard extends StatelessWidget {
  const UpsellCard({
    super.key,
    required this.title,
    required this.cta,
    required this.onPressed,
    this.onDismiss,
    this.subtitle = 'Bez reklam, bez sledování, jedna platba.',
  });
  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback onPressed;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: t.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: t.textTheme.bodySmall),
            const SizedBox(height: 12),
            Row(children: [
              FilledButton(onPressed: onPressed, child: Text(cta)),
              if (onDismiss != null)
                TextButton(onPressed: onDismiss, child: const Text('Později')),
            ]),
          ],
        ),
      ),
    );
  }
}
