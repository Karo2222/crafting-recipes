import 'package:flutter/material.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/singleton.dart';

/// Lets the user stop a sync while it is running; hidden otherwise.
class CancelSyncButton extends StatelessWidget {
  const CancelSyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SyncStatus>(
      valueListenable: Singleton().getValueNotifierSyncStatus(),
      builder: (context, status, _) => status == SyncStatus.runningSync
          ? OutlinedButton.icon(
              onPressed: Singleton().getCancelToken().cancel,
              icon: const Icon(Icons.cancel_outlined),
              label: Text(Languages.of(context)!.cancelSync),
            )
          : const SizedBox.shrink(),
    );
  }
}
