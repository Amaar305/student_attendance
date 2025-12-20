enum HistoryRange { last7Days, last30Days, last90Days, allTime }


extension HistoryRangeX on HistoryRange {
  String get label {
    switch (this) {
      case HistoryRange.last7Days:
        return 'Last 7 Days';
      case HistoryRange.last30Days:
        return 'Last 30 Days';
      case HistoryRange.last90Days:
        return 'Last 90 Days';
      case HistoryRange.allTime:
        return 'All Time';
    }
  }
}
