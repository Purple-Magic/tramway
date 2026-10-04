# Tramway SolidQueue Plugin

See the [main README's Plugins section](https://github.com/Purple-Magic/tramway#plugins) for how to enable the
`:solid_queue` plugin and what it provides.

## "Discard" removes the job entirely

Clicking "Discard" on a job (or selecting jobs and using the bulk "Discard" action) calls SolidQueue's own
`Job#discard`, which destroys the job's current execution *and the job record itself*. It does not leave behind a
"discarded" job you can still see or retry later — once discarded, the job is gone.

## Retrying requires jobs enqueued the normal way

Retry only works for jobs that carry the `arguments` SolidQueue/ActiveJob normally attaches when a job is enqueued
through `perform_later`/`ActiveJob`. Jobs inserted directly into the `solid_queue_jobs` table without that payload
(for example, by hand in a console or a script) will error on retry, since SolidQueue needs it to reset execution
counters.

## Pausing a queue

Pausing a queue stops new jobs on it from being picked up for execution; it does not remove or affect jobs already
in the queue. Resuming un-pauses it.

## Queue throughput

The "Throughput" column on the queues list shows how many jobs on that queue finished per minute, based on a
rolling 5-minute window. It's a live indicator of how fast a queue is currently draining, not a historical or
all-time average.

## "Destroy all" respects your current filters

The "Destroy all" button on the jobs list destroys every job that matches whatever filters are currently
applied — status, queue, class name, and/or free-text search — not just the jobs shown on the current page or any
jobs you've checked. With no filters applied, it destroys every job.

## Bulk actions and "Destroy all" run in the background

Clicking a bulk action (retry/discard/destroy a selection) or "Destroy all" does not run instantly: it enqueues a
background job and redirects right away, with a flash message telling you the action was queued (e.g. "Destroying
all matching jobs in the background"). The job processes the matching records in batches of 1,000, and runs on its
own dedicated worker queue (`tramway_solid_queue_bulk_actions`, with 20 worker threads) so a large bulk action
doesn't starve your application's other background jobs. `bin/rails g tramway:install` adds this queue to your
`config/queue.yml` automatically; if you don't run the generator, add it yourself so bulk actions actually get
picked up by a worker.

## Pages update on their own

The jobs list, queues list, recurring tasks list, and job detail page periodically refresh themselves in the
background, so you'll see job/queue status changes (e.g. a job moving from "Ready" to "Claimed" to "Finished")
without reloading the page. A refresh never interrupts you: it skips updating while you have a checkbox checked in
the jobs list (so your bulk selection isn't lost) or while you're typing/focused in a field inside the refreshed
area.
