---
trigger: model_decision
description: Universal Frontend Coding Rules. These rules should be applied when introducing new files, managing states, doing API integrations, introducing new CSS, functions / methods and when doing security and performance fixes in frontend UI code.
---

# Universal Frontend Coding Standards

## 1. Component Architecture & UI Logic

- Atomic Design Principles: Break UI into Atoms (buttons, inputs), Molecules (form groups), and Organisms (headers, sidebars).
- Component Purity: Prefer functional, stateless components for presentation. Keep business logic and side effects out of the UI layer.
- Props & Data Flow: Maintain a unidirectional data flow. Avoid "Prop Drilling" by using Context or State Management for deeply nested data.
- Composition over Inheritance: Use component composition to build complex UIs rather than extending classes.
- Reusability: Create generic, highly configurable components. Use slots/children for flexible content injection.

## 2. State Management

- Single Source of Truth: Ensure each piece of state lives in only one place.
- Local vs. Global State:
  - Use Local State for UI-only concerns (e.g., "is modal open").
  - Use Global/Server State for shared data (e.g., "user profile").
- Derived State: Do not store data that can be computed from existing state or props; calculate it on the fly.
- Immutability: Never mutate state directly. Always return new copies of objects/arrays to ensure predictable UI updates.

## 3. API Interaction & Data Fetching

- Service Layering: Abstract API calls into dedicated service modules. Components should call services, not `fetch` or `axios` directly.
- Loading & Error States: Every data-fetching operation must explicitly handle "Loading," "Error," and "Empty" states.
- Standardized DTOs: Map backend data structures to frontend-friendly models immediately upon retrieval to decouple UI from API changes.
- Caching & Freshness: Implement strategies for stale-while-revalidate or client-side caching to reduce unnecessary network load.

## 4. Styling & User Interface

- Design Token Consistency: Use a centralized theme (colors, spacing, typography). Avoid hardcoded "magic" values in styles.
- Responsive Design: Follow a Mobile-First approach. Use relative units (rem, em, %) instead of fixed pixels where possible.
- Accessibility (A11y):
  - Use semantic HTML (e.g., `<button>` for actions, `<nav>` for menus).
  - Ensure high color contrast and provide `aria-label` attributes where visual cues are missing.
  - Maintain full keyboard navigability (tab index, focus states).

## 5. Performance Optimization

- Lazy Loading: Code-split routes and heavy components to reduce initial bundle size.
- Asset Optimization: Use modern image formats (WebP) and implement lazy loading for images/videos below the fold.
- Memoization: Cache expensive computations and prevent unnecessary re-renders of heavy components using framework-appropriate memoization tools.
- Debouncing/Throttling: Limit the execution frequency of high-rate events like window resizing, scrolling, or real-time search inputs.

## 6. Error Handling & Resilience

- Error Boundaries: Wrap major UI sections in error boundaries to prevent a single component crash from breaking the entire application.
- Validation: Perform client-side validation for immediate feedback, but never treat it as a replacement for backend validation.
- Graceful Degradation: Ensure the application remains usable (even if limited) during network outages or if specific non-critical features fail.

## 7. Code Quality & Maintenance

- Declarative Code: Write code that describes _what_ the UI should look like for a given state, rather than _how_ to change it manually.
- Documentation: Document complex component APIs (Props, Events, Slots) and non-obvious business logic.
- Modular CSS: Use scoped styles (CSS Modules, CSS-in-JS, or BEM) to prevent global namespace pollution and unintended style overrides.
