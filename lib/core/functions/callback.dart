import 'dart:async';
import 'package:Silaaty/core/class/SyncServer.dart';
import 'package:Silaaty/core/functions/CheckInternat.dart';


class SyncForegroundService {
  final SyncService syncService = SyncService();
  Timer? _timer;

  void start() {
    syncService.syncAll();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 15), (_) async {
      if (await checkInternet()) {
        print("🔔 تنفيذ مهمة مزامنة دورية (foreground)...");
        await syncService.syncAll();
      }
    });

    syncService.initSyncListener();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
