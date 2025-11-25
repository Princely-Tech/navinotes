import 'package:navinotes/packages.dart';

enum CalendarProvider {
  google,
  apple,
  device,
}

enum SyncStatus {
  pending,
  syncing,
  synced,
  failed,
}

class CalendarSyncInfo {
  final String id;
  final String boardId;
  final CalendarProvider provider;
  final String? calendarId;
  final SyncStatus status;
  final DateTime lastSyncAt;
  final String? errorMessage;
  final Map<String, String> syncedEventIds;

  CalendarSyncInfo({
    required this.id,
    required this.boardId,
    required this.provider,
    this.calendarId,
    required this.status,
    required this.lastSyncAt,
    this.errorMessage,
    this.syncedEventIds = const {},
  });

  CalendarSyncInfo copyWith({
    String? id,
    String? boardId,
    CalendarProvider? provider,
    String? calendarId,
    SyncStatus? status,
    DateTime? lastSyncAt,
    String? errorMessage,
    Map<String, String>? syncedEventIds,
  }) {
    return CalendarSyncInfo(
      id: id ?? this.id,
      boardId: boardId ?? this.boardId,
      provider: provider ?? this.provider,
      calendarId: calendarId ?? this.calendarId,
      status: status ?? this.status,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      errorMessage: errorMessage ?? this.errorMessage,
      syncedEventIds: syncedEventIds ?? this.syncedEventIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'board_id': boardId,
      'provider': provider.name,
      'calendar_id': calendarId,
      'status': status.name,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'error_message': errorMessage,
      'synced_event_ids': jsonEncode(syncedEventIds),
    };
  }

  factory CalendarSyncInfo.fromMap(Map<String, dynamic> map) {
    Map<String, String> syncedEventIds = {};
    if (map['synced_event_ids'] != null) {
      if (map['synced_event_ids'] is String) {
        syncedEventIds = Map<String, String>.from(
          jsonDecode(map['synced_event_ids']),
        );
      } else if (map['synced_event_ids'] is Map) {
        syncedEventIds = Map<String, String>.from(map['synced_event_ids']);
      }
    }

    return CalendarSyncInfo(
      id: map['id'] ?? const Uuid().v4(),
      boardId: map['board_id'] ?? '',
      provider: CalendarProvider.values.firstWhere(
        (e) => e.name == map['provider'],
        orElse: () => CalendarProvider.device,
      ),
      calendarId: map['calendar_id'],
      status: SyncStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SyncStatus.pending,
      ),
      lastSyncAt: DateTime.fromMillisecondsSinceEpoch(
        map['last_sync_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      errorMessage: map['error_message'],
      syncedEventIds: syncedEventIds,
    );
  }
}

class CalendarSettings {
  final String id;
  final CalendarProvider provider;
  final String? calendarId;
  final String? calendarName;
  final bool autoSync;
  final int syncIntervalHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarSettings({
    required this.id,
    required this.provider,
    this.calendarId,
    this.calendarName,
    this.autoSync = true,
    this.syncIntervalHours = 24,
    required this.createdAt,
    required this.updatedAt,
  });

  CalendarSettings copyWith({
    String? id,
    CalendarProvider? provider,
    String? calendarId,
    String? calendarName,
    bool? autoSync,
    int? syncIntervalHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarSettings(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      calendarId: calendarId ?? this.calendarId,
      calendarName: calendarName ?? this.calendarName,
      autoSync: autoSync ?? this.autoSync,
      syncIntervalHours: syncIntervalHours ?? this.syncIntervalHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider': provider.name,
      'calendar_id': calendarId,
      'calendar_name': calendarName,
      'auto_sync': autoSync ? 1 : 0,
      'sync_interval_hours': syncIntervalHours,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CalendarSettings.fromMap(Map<String, dynamic> map) {
    return CalendarSettings(
      id: map['id'] ?? const Uuid().v4(),
      provider: CalendarProvider.values.firstWhere(
        (e) => e.name == map['provider'],
        orElse: () => CalendarProvider.device,
      ),
      calendarId: map['calendar_id'],
      calendarName: map['calendar_name'],
      autoSync: map['auto_sync'] == 1,
      syncIntervalHours: map['sync_interval_hours'] ?? 24,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  static CalendarSettings create({
    required CalendarProvider provider,
    String? calendarId,
    String? calendarName,
    bool autoSync = true,
    int syncIntervalHours = 24,
  }) {
    final now = DateTime.now();
    return CalendarSettings(
      id: const Uuid().v4(),
      provider: provider,
      calendarId: calendarId,
      calendarName: calendarName,
      autoSync: autoSync,
      syncIntervalHours: syncIntervalHours,
      createdAt: now,
      updatedAt: now,
    );
  }
}

class SyncEvent {
  final String id;
  final String calendarSyncInfoId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? externalEventId;
  final DateTime createdAt;

  SyncEvent({
    required this.id,
    required this.calendarSyncInfoId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.externalEventId,
    required this.createdAt,
  });

  SyncEvent copyWith({
    String? id,
    String? calendarSyncInfoId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? externalEventId,
    DateTime? createdAt,
  }) {
    return SyncEvent(
      id: id ?? this.id,
      calendarSyncInfoId: calendarSyncInfoId ?? this.calendarSyncInfoId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      externalEventId: externalEventId ?? this.externalEventId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calendar_sync_info_id': calendarSyncInfoId,
      'title': title,
      'description': description,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'external_event_id': externalEventId,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SyncEvent.fromMap(Map<String, dynamic> map) {
    return SyncEvent(
      id: map['id'] ?? const Uuid().v4(),
      calendarSyncInfoId: map['calendar_sync_info_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['end_time']),
      externalEventId: map['external_event_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  static SyncEvent create({
    required String calendarSyncInfoId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? externalEventId,
  }) {
    return SyncEvent(
      id: const Uuid().v4(),
      calendarSyncInfoId: calendarSyncInfoId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      externalEventId: externalEventId,
      createdAt: DateTime.now(),
    );
  }
}
