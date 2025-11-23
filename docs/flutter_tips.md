# Flutter Tips 🚀

A collection of best practices for writing efficient, readable, and performant Flutter code.

## Performance & Optimization

### Choosing Right Widget

- **StatelessWidget:** Create `StatelessWidget` for UI parts that are independent and don't manage any internal state. When a widget's appearance depends only on constructor parameters, `StatelessWidget` avoids unnecessary rebuilds. Use `StatefulWidget` only when local state, animations, or lifecycle handling are required.

- **Lazy loading widgets (e.g., `ListView.builder`, `GridView.builder`):** Use these when you have long or infinite lists. They build items on demand, reducing memory and CPU usage and preventing UI jank for large datasets.

- **Non-lazy widgets (e.g., `Column`, `Row`, `Stack`, default `ListView`):** Use when you have a small, fixed number of children. These build upfront and are simpler when the child count is predictable.

- **RepaintBoundary:** Wrap complex, static, or animated visuals (like a custom painter canvas) in a `RepaintBoundary`. This isolates rendering so repaints inside the boundary don't force the rest of the UI to redraw.

- **ListView `shrinkWrap`:** Only use `shrinkWrap: true` when an inner list must size itself within another scrollable. It forces the `ListView` to measure all children (defeating lazy height calculation) and can be very slow with large datasets—prefer `CustomScrollView` with slivers instead.

- **CustomScrollView (with slivers):** Use when the screen contains multiple scrollable sections or mixed content that must scroll together. Slivers give fine-grained control and avoid expensive layout passes that nested scrollables can cause.

- **SingleChildScrollView + `Row`:** Use for simple horizontal scrolling when the height is unconstrained and you only have a few children. For many horizontally scrolling items, prefer `ListView.builder` with `scrollDirection: Axis.horizontal` to leverage lazy building.

- **Flexible / Expanded:** `Column/Row` doesn't provide constraints to it's child. Use `Flexible` when a child should take a flexible portion of available space and `Expanded` when a child must expand to fill the remaining space in a `Column/Row`.

### General Best Practices

Follow these guidelines to keep your app fast and your codebase clean.

- **Use `const` Liberally**: For any widget that doesn't change, declare it as `const`. Flutter can skip rebuilding it entirely.

- **Keep the `build` Method Pure**: The `build` method should be free of side effects and heavy computations. Its only job is to return a widget tree based on the current state and properties.

- **Isolates:** Use isolates for CPU-bound, heavy work (large JSON parsing, image processing, encryption, or complex computations) to keep the UI thread responsive and avoid jank. For short-lived tasks prefer `compute()`. For long-running or reusable background workers use `Isolate.spawn`, or consider packages like `flutter_isolate`.

## Web Configurations

### Routing

- **URL Strategy**: Use the `Path` style to remove the `#` from URLs for a cleaner look.
- **Query Parameters**: Use query params to pass data between pages.
- **Standard URL Path Names**: Adopt consistent URL naming for better navigation.
- **Route Guards**: Protect routes with route guards from unauthorized access via direct URL entry.

### Design System

- **DPI Awareness**: Flutter web has a DPI value of 1, so the text will appear larger compared to mobile platforms. Adjust font sizes and UI elements accordingly to ensure a consistent look and feel across devices.
- **Web Interop**: For platform-specific interactions, use the `web` package to interact with browser APIs. This allows you to access and utilize features unique to the web environment, such as local storage, cookies, and JavaScript functions.

## Offline Storage Strategies

Effective offline storage ensures a smooth user experience, even with intermittent connectivity.

### Caching Mechanism (Save and Clear)

A robust caching strategy involves both saving data for offline access and clearing it when it becomes stale or irrelevant.

#### Timestamp-Based Synchronization

This is a common technique to decide whether to update local data.

- Store a `lastUpdated` timestamp with local data to determine if a server fetch is needed.

- **How it works**: When you save data from the server to your local database (e.g., SQLite, Hive), store a `lastUpdated` timestamp alongside it.
- **On next fetch**: Before making a network call, check the timestamp of your local data. You can then decide whether the data is fresh enough or if you need to fetch updates from the server. The server response can also include a timestamp, allowing for a direct comparison.

#### Cache Expiration and Cleanup

To prevent local storage from growing indefinitely and holding stale data, implement an expiration policy.

- Set an `expirationTime` on cached data and run periodic cleanup tasks to remove stale entries.

- **Set Expiration Time**: When caching data, save an `expirationTime` (e.g., current time + 24 hours). Before using cached data, check if `DateTime.now()` is past the `expirationTime`.
- **Scheduled Cleanup**: Use background tasks or scheduled jobs (e.g., with `workmanager` or `cron`) to periodically scan the local database and remove expired or old data.

#### Storage Limits (LRU Cache)

To manage storage space, you can implement a "Least Recently Used" (LRU) policy.

- **How it works**: Limit the total storage size or the number of cached items.
- **Eviction**: When the storage limit is reached, prioritize keeping the most important or most recently accessed data and remove the oldest or least-used items to make space for new ones.
- Implement a "Least Recently Used" (LRU) policy to manage storage by removing the oldest items when limits are reached.
