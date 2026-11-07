import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/providers.dart';

/// Statistics are read-only and cheap to recompute, so they are not cached in
/// SQLite. Each range keeps its own FutureProvider entry for instant switching.
final statsOverviewProvider =
    FutureProvider.autoDispose.family<StatsOverview, String>((ref, range) {
      return ref
          .watch(libraryRepositoryProvider)
          .statsOverview(range: range);
    });
