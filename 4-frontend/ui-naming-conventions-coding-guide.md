---
description: UI coding guide
---

# Project Coding Standards & Rules

This document outlines the mandatory naming conventions and architectural rules for the Analytics Dashboard project. These rules are designed to ensure modularity, scalability, and framework-agnostic development.

## 1. Naming Conventions

### Files and Directories
- **React Components**: Use `PascalCase` (e.g., `StatCard.tsx`, `Sidebar.tsx`).
- **Utility & Type Files**: Use `camelCase` (e.g., `dateUtils.ts`, `chartTypes.ts`).
- **Directories**: Use `kebab-case` for multi-word directory names (e.g., `data-services`).

### Component Exports
- **Strictly Named Exports**: Do NOT use `default export`.
  - `export const Header = () => { ... }`
  - `export default Header;`
- **Props Interfaces**: Always define an interface for component props and export it.
  - Pattern: `[ComponentName]Props`.

## 2. Component Architecture

### Modular Organization
- **`/components/common`**: Primitive, reusable UI elements (Buttons, Dropdowns, Inputs) that contain no business logic.
- **`/components/charts`**: Specialized visualization components that act as thin wrappers around charting libraries (D3/Recharts).
- **`/pages`**: Main view containers that handle high-level layout and data orchestration.
- **`/utils`**: Stateless helper functions for data transformation, formatting, and mathematical logic.

### Charting Patterns
- **Data-Agnostic Design**: Chart components must not be coupled to a specific backend schema.
- **Dynamic Mapping**: Always provide `dataKey` and `nameKey` props (or equivalent) to map incoming JSON objects dynamically.

