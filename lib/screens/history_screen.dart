import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_outline),
            onPressed: history.items.isEmpty
                ? null
                : () => _confirmClearHistory(context),
          ),
        ],
      ),
      body: history.items.isEmpty
          ? const Center(
              child: Text('Chua co phep tinh nao.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: history.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = history.items[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    item.expression,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(item.timestamp),
                  ),
                  trailing: Text(
                    item.result,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  onTap: () {
                    context.read<CalculatorProvider>().useHistory(item);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
    );
  }

  Future<void> _confirmClearHistory(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoa tat ca lich su?'),
        content: const Text('Hanh dong nay khong the hoan tac.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Huy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xoa'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<HistoryProvider>().clearHistory();
    }
  }
}
