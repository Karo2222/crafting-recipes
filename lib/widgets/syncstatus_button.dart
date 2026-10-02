import 'package:flutter/material.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/singleton.dart';

/// Icon and label describing the current [SyncStatus].
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  static (IconData, Color, String) _appearance(SyncStatus status, Languages l) =>
      switch (status) {
        SyncStatus.fullSync => (Icons.cloud_done, Colors.green, l.fullSync),
        SyncStatus.runningSync => (Icons.sync, Colors.blue, l.runningSync),
        SyncStatus.pendingSync =>
          (Icons.sync_problem, Colors.orange, l.pendingSync),
        SyncStatus.cancelledSync =>
          (Icons.sync_disabled, Colors.red, l.cancelledSync),
        SyncStatus.neverSynced =>
          (Icons.cloud_off, Colors.red, l.neverSynced),
      };

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return ValueListenableBuilder<SyncStatus>(
      valueListenable: Singleton().getValueNotifierSyncStatus(),
      builder: (context, status, _) {
        final (icon, color, label) = _appearance(status, l);
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(icon, color: color),
            Text(label, style: TextStyle(color: color)),
          ],
        );
      },
    );
  }
}
