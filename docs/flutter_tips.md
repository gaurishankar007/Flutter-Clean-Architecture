# Flutter Tips 🚀

A collection of best practices for writing efficient, readable, and performant Flutter code.

## Introduction

At the heart of Flutter's performance is its rendering pipeline, which revolves around three trees and a few core mechanisms. Understanding them is crucial for optimization.

### The Three Trees

Flutter doesn't just have one tree, but three that work together.

- **Widget Tree**: This is the blueprint you create in your code. It's a lightweight, immutable description of the UI's configuration. Because widgets are just configuration and cheap to create, they can be rebuilt frequently without a major performance hit.
- **Element Tree**: This is the manager. For every widget in the widget tree, Flutter creates a mutable Element.The Element tree manages the lifecycle of widgets and holds the reference to both the widget and the render object. It is the crucial bridge that decides whether to reuse, update, or create new components. The `BuildContext` you use in `build` methods is actually a reference to an element.
- **RenderObject Tree**: This is the workhorse responsible for the actual layout, painting (drawing), and hit-testing (handling touch events). RenderObjects are expensive to create, so Flutter's architecture is designed to reuse them as much as possible.

### Rebuild vs. Repaint

- **Rebuild**: Triggered by a state change (e.g., `setState()`), this is when Flutter calls the `build()` method to create a new tree of widgets. The Element tree then intelligently updates itself based on these conditions:

  - **If the new widget has a different type or key**: The old Element and RenderObject are discarded, and new ones are created. This is the most expensive outcome, as it involves tearing down and recreating a part of the tree.
  - **If the widget's properties don't change**: If a new widget has the same type and key, Flutter compares its properties to the old one. If they are identical, the underlying RenderObject is not updated. Using `const` is a key optimization because it allows Flutter to skip this comparison entirely, doing almost no work.

- **Repaint**: This is the separate act of redrawing pixels on the screen. A rebuild only triggers a repaint if the RenderObject's visual properties change.

  - **A rebuild will not trigger a repaint** if the new widget configuration doesn't alter the visual properties of the underlying RenderObject. For example, if a counter value changes for a non-visual purpose (like an ID), but the resulting color, size, and text of the widget remain the same, no repaint will occur. However, if that counter value is displayed in a `Text` widget, its visual properties _have_ changed, and it will trigger a repaint.
  - **Light vs. Heavy Repainting**: The cost of a repaint depends on what changed. A simple color change is a "light" repaint. A size or position change is "heavier" because it can trigger a full layout pass, forcing the parent and potentially other widgets in the tree to recalculate their sizes and positions.

- **Optimization**: The goal is to rebuild only the necessary widgets and avoid triggering expensive repaints or layouts. Isolating frequently changing UI in a small widget with its own state or using a `RepaintBoundary` for complex animations are key strategies.

### Garbage Collection (GC)

- Dart is a garbage-collected language. Frequent GC events are normal in Flutter and often happen during idle time to clean up short-lived objects (like widgets created during a rebuild) without impacting performance.
- The main performance concern is not the GC itself, but **memory leaks**—when objects are unintentionally held in memory, preventing the GC from cleaning them up.

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

- **PointerInterceptor:** When using `HtmlElementView` to display web content, it can block interactions with Flutter widgets layered on top (like a `FloatingActionButton` or a dialog). To solve this, wrap the overlapping Flutter widget with `PointerInterceptor` from the `pointer_interceptor` package. This ensures your Flutter widgets remain interactive.

### General Best Practices

Follow these guidelines to keep your app fast and your codebase clean.

- **Use `const` Liberally**: For any widget that doesn't change, declare it as `const`. Flutter can skip rebuilding it entirely.

- **Keep the `build` Method Pure**: The `build` method should be free of side effects and heavy computations. Its only job is to return a widget tree based on the current state and properties.

- **Isolates:** Use isolates for CPU-bound, heavy work (large JSON parsing, image processing, encryption, or complex computations) to keep the UI thread responsive and avoid jank. For short-lived tasks prefer `compute()` or `Isolate.run`. For long-running or reusable background workers use `Isolate.spawn`, or consider packages like `flutter_isolate`. But isolates do not run in background threads on the web platform.

- **Use `ValueKey` for list items:** When building lists (for example with `ListView.builder`), give each item a stable key such as `ValueKey(item.id)` to preserve widget identity across updates, reorders, or insertions/removals. This reduces unnecessary rebuilds/repaints and preserves the state of stateful child widgets. Avoid non-unique or mutable keys (for example index-based keys) — prefer stable identifiers that reflect the item's identity.

- **Avoid Methods that Return Widgets**: Prefer creating a separate `StatelessWidget` over a method that returns a widget. While methods can be acceptable for simple, stateless widget compositions, they should never be used to return a `StatefulWidget`. Doing so causes state loss and inefficient rebuilds because.

## Web Configurations

### Routing

- **URL Strategy**: Use the `Path` style to remove the `#` from URLs for a cleaner look.
- **Query Parameters**: Use query params to pass data between pages.
- **Standard URL Path Names**: Adopt consistent URL naming for better navigation.
- **Route Guards**: Protect routes with route guards from unauthorized access via direct URL entry.

### Design System

- **DPI Awareness**: UI elements can render at different sizes on web versus mobile due to varying DPI. Always test on target browsers and adjust font sizes and layouts for a consistent appearance.
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
