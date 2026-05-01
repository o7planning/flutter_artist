# FlutterArtist

A state-management and UI library for Flutter, inspired by the structural integrity of Oracle Forms. Designed for developers who prioritize architecture, scalability, and long-term maintainability.

---

##  Live Showcase

Explore FlutterArtist in action before diving into the code:

[** LAUNCH ONLINE DEMO**](https://o7planning.github.io/flutter-artist/)

### Video Presentation
[![FlutterArtist Showcase](https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
> *Click the image above to watch the framework overview on YouTube.*

---

## Technical Highlights

### 1. Master-Detail Orchestration
![Master Detail GIF](https://via.placeholder.com/1000x400.gif?text=Master-Detail+Relationship+Wide+Demo)

**Hierarchical State Sync** FlutterArtist excels in managing complex parent-child relationships between data blocks.
- **Automatic Synchronization:** Child blocks automatically react to parent record changes.
- **Pending State Handling:** Sophisticated management of child states when a parent has no selection.
- **Deep Nesting:** Support for multi-level relationships (Grandparent > Parent > Child).

---

### 2. Advanced Data Filtering
![Filter GIF](https://via.placeholder.com/1000x400.gif?text=Advanced+Filtering+Wide+Demo)

**Structured Query Logic** A robust filtering system designed for enterprise-grade data navigation.
- **Declarative Filters:** Define complex criteria once, apply anywhere.
- **Reactive UI:** Instant feedback as users refine their search.

---

### 3. Intelligent Form Builder
![Form GIF](https://via.placeholder.com/1000x400.gif?text=Form+Builder+Wide+Demo)

**Constraint-Based Forms** Building forms is no longer about boilerplate code; it's about defining the contract between your UI and your Data Block.
- **FaFormBuilder:** Highly configurable fields with integrated validation.
- **Direct Binding:** Seamlessly link form inputs to Block scalars.

---

### 4. Integrated Debugging Suite
![Debug GIF](https://via.placeholder.com/1000x400.gif?text=Debug+Viewer+Wide+Demo)

**Developer Transparency** We provide built-in tools to help you visualize the internal state of your application.
- **Theme Viewer:** Real-time preview of `FaThemeTokens`.
- **State Inspector:** Monitor every state transition in your Blocks.

---

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_artist: ^1.0.0