# Flutter Tips and Tricks 🚀

A collection of best practices for writing efficient, readable, and performant Flutter code.

---

## Table of Contents 📌

- Performance & Optimization
- Offline First & Caching

---

## Performance & Optimization

### 1. Widget Loading Strategies

Understanding how widgets load is key to a snappy UI.

- **Upfront (Non-Lazy)**: Widgets are built immediately, even if off-screen. Use for a small, fixed number of children.

  - **Examples**: `Column`, `Row`, `Stack`, default `ListView`.

- **Lazy**: Widgets are built only when they are about to become visible. Best for long or infinite lists.
  - **Examples**: `ListView.builder`, `GridView.builder`, `PageView.builder`, `CustomScrollView` with Slivers.

### 2. Choosing the Right List/Grid View

Choosing the right constructor is crucial for performance.

| Constructor        | Use Case                                                        | Loading Strategy   |
| ------------------ | --------------------------------------------------------------- | ------------------ |
| **(default)**      | Small, fixed number of children.                                | Upfront (Non-Lazy) |
| **`.builder()`**   | Large or infinite lists, built on demand.                       | **Lazy**           |
| **`.separated()`** | Like `.builder()`, but with separators.                         | **Lazy**           |
| **`.count()`**     | (GridView) Grid with a fixed number of tiles in the cross-axis. | **Lazy**           |
| **`.extent()`**    | (GridView) Grid where tiles have a max cross-axis extent.       | **Lazy**           |
| **`.custom()`**    | Full control over child building via a `SliverChildDelegate`.   | **Lazy**           |

### 3. General Best Practices

Follow these guidelines to keep your app fast and your codebase clean.

- **Use `const` Liberally**: For any widget that doesn't change, declare it as `const`. Flutter can skip rebuilding it entirely.

  ```dart
  // Good: This widget and its children won't be rebuilt unnecessarily.
  return const Center(
    child: Text('Hello, World!'),
  );
  ```

- **Prefer `StatelessWidget`**: Create `StatelessWidget` for UI parts that are independent and don't manage any internal state. This prevents unnecessary rebuilds. Use `StatefulWidget` only when a widget needs to manage its own internal state.

- **Keep the `build` Method Pure**: The `build` method should be free of side effects and heavy computations. Its only job is to return a widget tree based on the current state and properties.

- **Use `RepaintBoundary`**: Wrap complex, static, or animated visuals (like a custom painter canvas) in a `RepaintBoundary`. This isolates its rendering from the rest of the UI, preventing unnecessary repaints of other widgets when it changes, and vice-versa.

- **Beware of `shrinkWrap` in ListViews**: Using `shrinkWrap: true` on a `ListView.builder` can degrade performance with large datasets. It forces the `ListView` to calculate the total height of all its items before building them, defeating the purpose of lazy loading. Avoid it unless absolutely necessary.

- **Use `Flexible` with `ConstrainedBox` and `ListView` in `Column`**: When using a `ConstrainedBox` (containing a `ListView`) inside a `Column`, wrap it with `Flexible` to avoid layout errors. The `Flexible` widget helps manage the unbounded height constraints that `Column` passes to its children.

---

## Web Configurations

### 1. Routing

- **URL Strategy**: Use the `Path` style to remove the `#` from URLs for a cleaner look.
- **Query Parameters**: Use query params to pass data between pages.
- **Standard URL Path Names**: Adopt consistent URL naming for better navigation.
- **Route Guards**: Protect routes with route guards from unauthorized access via direct URL entry.

### 2. Design System

- **DPI Awareness**: Text appears larger on web (DPI of 1); adjust UI accordingly for consistency.
- **Web Interop**: Use the `web` package to interact with browser APIs like local storage or JavaScript.

### 2. Design System

- **DPI Awareness**: Flutter web has a DPI value of 1, so the text will appear larger compared to mobile platforms. Adjust font sizes and UI elements accordingly to ensure a consistent look and feel across devices.
- For platform specific interaction use the 'web' package to interact with browser APIs.
- **Web Interop**: For platform-specific interactions, use the `web` package to interact with browser APIs. This allows you to access and utilize features unique to the web environment, such as local storage, cookies, and JavaScript functions.
- **DPI Awareness**: Text appears larger on web (DPI of 1); adjust UI accordingly for consistency.
- **Web Interop**: Use the `web` package to interact with browser APIs like local storage or JavaScript.

## Offline Storage Strategies

Effective offline storage ensures a smooth user experience, even with intermittent connectivity.

### Caching Mechanism (Save and Clear)

A robust caching strategy involves both saving data for offline access and clearing it when it becomes stale or irrelevant.

#### 1. Timestamp-Based Synchronization

This is a common technique to decide whether to update local data.

- Store a `lastUpdated` timestamp with local data to determine if a server fetch is needed.

- **How it works**: When you save data from the server to your local database (e.g., SQLite, Hive), store a `lastUpdated` timestamp alongside it.
- **On next fetch**: Before making a network call, check the timestamp of your local data. You can then decide whether the data is fresh enough or if you need to fetch updates from the server. The server response can also include a timestamp, allowing for a direct comparison.

#### 2. Cache Expiration and Cleanup

To prevent local storage from growing indefinitely and holding stale data, implement an expiration policy.

- Set an `expirationTime` on cached data and run periodic cleanup tasks to remove stale entries.

- **Set Expiration Time**: When caching data, save an `expirationTime` (e.g., current time + 24 hours). Before using cached data, check if `DateTime.now()` is past the `expirationTime`.
- **Scheduled Cleanup**: Use background tasks or scheduled jobs (e.g., with `workmanager` or `cron`) to periodically scan the local database and remove expired or old data.

#### 3. Storage Limits (LRU Cache)

To manage storage space, you can implement a "Least Recently Used" (LRU) policy.

- **How it works**: Limit the total storage size or the number of cached items.
- **Eviction**: When the storage limit is reached, prioritize keeping the most important or most recently accessed data and remove the oldest or least-used items to make space for new ones.
- Implement a "Least Recently Used" (LRU) policy to manage storage by removing the oldest items when limits are reached.
