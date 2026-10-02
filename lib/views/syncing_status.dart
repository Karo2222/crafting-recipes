import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/widgets/sync_cancel_button.dart';
import 'package:craftingrecipes/widgets/syncstatus_button.dart';

/// Lets the user start or cancel a sync and shows its progress per table.
class SyncingStatus extends StatelessWidget {
  const SyncingStatus({super.key});

  static int _percent(int done, int total) =>
      total == 0 ? 100 : (done * 100 ~/ total);

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final sync = Singleton();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ValueListenableBuilder<SyncStatus>(
            valueListenable: sync.getValueNotifierSyncStatus(),
            builder: (context, status, _) => Center(
              child: status == SyncStatus.runningSync
                  ? const CancelSyncButton()
                  : FilledButton.icon(
                      onPressed: SupabaseToDrift.sync,
                      icon: const Icon(Icons.sync),
                      label: Text(l.startSync),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: SyncStatusIndicator()),
          ValueListenableBuilder<String?>(
            valueListenable: sync.getLastSyncError(),
            builder: (context, error, _) => (error ?? '').isEmpty
                ? const SizedBox.shrink()
                : _ErrorCard(title: l.lastSyncError, message: error!),
          ),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: Listenable.merge([
              sync.getNumberOfSyncSteps(),
              sync.getNumberofSynchedTables(),
            ]),
            builder: (context, _) {
              final total = sync.getNumberOfSyncSteps().value;
              final done = sync.getNumberofSynchedTables().value;
              final percent = total == 0 ? 0 : _percent(done, total);
              return Center(
                child: Text(
                  '${l.syncProgress}: ${l.step} $done/$total ($percent%)',
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<List<ProgressFraction>>(
            valueListenable: sync.getPercentageOfSyncedEntries(),
            builder: (context, tables, _) => Column(
              children: [
                for (final (index, table) in tables.indexed)
                  ListTile(
                    dense: true,
                    title: Text(
                      '${l.step} ${index + 1} '
                      '(${l.syncTableLabel(table.tablename)})',
                    ),
                    trailing: Text(
                      '${table.synced}/${table.total} '
                      '(${_percent(table.synced, table.total)}%)',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(top: 16),
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            SelectableText(message),
          ],
        ),
      ),
    );
  }
}
