import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';

class DuoLayoutController extends ChangeNotifier {
  bool isSideRailActive = false;
  bool isFullyOpen = false;
  StreamSubscription<DuoFoldSnapshot>? _foldSub;

  void init() {
    _foldSub = ItchiDuoFold.snapshots.listen((snap) {
      final opened = snap.pose == DuoFoldPose.fullyOpen;
      if (isFullyOpen != opened) {
        isFullyOpen = opened;
        notifyListeners();
      }
    });
  }

  Future<void> updateSideBackVisibility(bool shouldShow) async {
    final status = await ItchiDuoSideBack.setVisible(shouldShow);
    final active = shouldShow && status == ItchiSideBackStatus.available;
    if (isSideRailActive != active) {
      isSideRailActive = active;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unawaited(ItchiDuoSideBack.setVisible(false));
    _foldSub?.cancel();
    super.dispose();
  }
}