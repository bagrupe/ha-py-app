/// Number of complete calendar days included in the default appointment query.
const defaultTermineQueryDayCount = 181;

/// Returns stable UTC boundaries for all appointment queries on one local day.
({DateTime from, DateTime until}) defaultTermineQueryDateRange(DateTime now) {
  final from = DateTime.utc(now.year, now.month, now.day);
  final until = from
      .add(const Duration(days: defaultTermineQueryDayCount))
      .subtract(const Duration(microseconds: 1));
  return (from: from, until: until);
}
