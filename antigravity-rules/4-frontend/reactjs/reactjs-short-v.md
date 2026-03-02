---
trigger: model_decision
description: React.js Development Standards. These rules should be applied when introducing new files, managing states, doing API integrations, introducing new CSS, functions / methods and when doing security and performance fixes in frontend UI code in react.
---

# React.js Development Standards

## 1. Core Principles & Logic

- Functional Paradigm: Always use functional components and Hooks. Class components are strictly prohibited.
- Purity & Idempotency: Components and Hooks must be pure functions. They must return the same output for the same inputs (props, state, context) and avoid side effects during rendering.
- Rules of Hooks:
  - Call hooks only at the top level of the component.
  - Never call hooks inside loops, conditions, or nested functions.
  - Call hooks only from React functions (components or custom hooks).

## 2. Component Architecture & Design

- Single Responsibility: Each file should export exactly one primary component.
- Atomic structure:
  - Presentational (Dumb): Receive data via props, handle UI only, and emit events.
  - Container (Smart): Manage state, fetch data, and handle business logic.
- Composition: Prefer component composition over complex conditional rendering logic or inheritance patterns.
- Naming: Use `PascalCase` for component names and `snake_case` or `kebab-case` for non-component helper files.

## 3. State Management

- Local State: Use `useState` for simple local state and `useReducer` for complex state logic within a component.
- Global State: Use Context API for light global state (themes, auth). For complex data-heavy applications, use Redux Toolkit or TanStack Query.
- State Initialization: Always provide explicit initial values to avoid `undefined` errors during the first render.
- Derived Data: Do not store values in state that can be calculated from props or existing state; compute them during render (using `useMemo` if expensive).

## 4. Hooks & Side Effects

- Custom Hooks: Extract reusable logic into custom hooks (e.g., `useAuth`, `useWindowSize`) to keep components clean.
- useEffect Guidelines:
  - Always provide a dependency array.
  - Use cleanup functions (return) to cancel subscriptions, timers, or async tasks.
  - Keep effects single-purpose; do not mix unrelated logic in one `useEffect`.
- Ref Usage: Use `useRef` for DOM access or persisting values that shouldn't trigger a re-render.

## 5. Performance Optimization

- Memoization: Use `React.memo` for expensive-to-render components and `useCallback`/`useMemo` to stabilize references passed to dependencies.
- Lazy Loading: Utilize `React.lazy` and `Suspense` for code-splitting routes and heavy UI modules.
- List Optimization: Always use unique, stable `key` props (never use array indices for dynamic lists).

## 6. Rendering & JSX

- Declarative JSX: Keep JSX readable and minimal. Move complex logic into helper functions or variables above the `return` statement.
- Fragments: Use `<>...</>` to avoid unnecessary DOM nodes.
- Boolean Logic: Use short-circuit evaluation (`condition && <Component />`) carefully; ensure the left side is a boolean to avoid rendering `0`.

## 7. Quality & Error Handling

- Prop Validation: Use TypeScript interfaces/types for strict prop checking.
- Error Boundaries: Wrap critical UI sections (like sidebars or widgets) in Error Boundaries to prevent total application crashes.
- Loading States: Explicitly handle and display loading and error states for every asynchronous operation.
