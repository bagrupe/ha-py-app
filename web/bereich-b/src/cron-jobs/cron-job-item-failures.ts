/** Tracks per-item failures during a cron job run for metrics. */
export class CronJobItemFailures {
  private count = 0

  recordFailure(): void {
    this.count++
  }

  recordFailures(count: number): void {
    if (count > 0) {
      this.count += count
    }
  }

  getCount(): number {
    return this.count
  }
}
