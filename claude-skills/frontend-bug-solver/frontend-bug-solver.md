---
name: frontend-bug-solver
description: >
 Agentic frontend bug investigation skill for Next.js and React applications.
 Supports UI issues, API integration problems, state management bugs,
 tracking failures, authentication issues, routing problems,
 rendering issues, content player bugs, and responsive design defects.

 Trigger this skill whenever the user says things like:
 "I have a frontend bug",
 "UI is broken",
 "button not working",
 "API data not showing",
 "tracking is failing",
 "page not rendering",
 "state is not updating",
 "course completion issue",
 "Next.js issue",
 "React bug".

 This skill takes ownership of the full debugging workflow:
 user journey → route → component tree → hooks → state →
 service → API → UI rendering.
---

# Frontend Bug Solver

An agentic skill that turns a frontend bug report into a structured investigation.

**Golden Rule: Reproduce the user journey first. Code is the source of truth. Browser behavior confirms the findings.**

---

# Phase 1 — Collect Bug Context

Ask the user:

To investigate the bug, I need:

1. What's the issue? (expected behavior vs actual behavior)
2. Current page URL or route?
3. Screenshot or screen recording?
4. Browser console error (if any)?
5. Network request details (if API related)?

Optional:

* Jira ticket
* Figma design
* Acceptance criteria
* PR link

Wait for response before code investigation.

---

# Phase 2 — Route & Component Trace

Find the affected route.

Trace:

Route
↓
Page Component
↓
Child Components
↓
Custom Hooks
↓
Services
↓
API Calls
↓
State Management
↓
Rendered UI

Document:

* Entry component
* Related hooks
* API dependencies
* State dependencies

---

# Phase 3 — Classify Bug Type

Determine category:

## UI Bug

Examples:

* Button broken
* Modal not opening
* Incorrect styling
* Layout issue

---

## API Integration Bug

Examples:

* Empty data
* Wrong data
* Failed request
* Infinite loading

---

## State Management Bug

Examples:

* Redux not updating
* Context issue
* Stale state
* Cache issue

---

## Routing Bug

Examples:

* Page not found
* Redirect loop
* Dynamic route issue

---

## Authentication Bug

Examples:

* Login issue
* Session expired
* Unauthorized API

---

## Tracking Bug

Examples:

* Event not firing
* Duplicate tracking
* Wrong payload

---

## Content Player Bug

Examples:

* Progress not updating
* Resume not working
* Completion not triggering
* Certificate not generating

---

# Phase 4 — Code Trace

Perform targeted trace only.

## Component Investigation

Find:

* Props
* State
* useEffect
* Event Handlers
* API Calls

Document:

What the component intends to do.

---

## Hook Investigation

Trace:

Custom Hook
↓
Service
↓
API

Check:

* Dependency arrays
* Memoization
* State updates
* Side effects

---

## Service Investigation

Validate:

* Endpoint
* Payload
* Headers
* Error Handling

---

# Phase 5 — Browser Behavior Validation

Check:

## Console

* Runtime errors
* React warnings
* Hydration issues

## Network

* Failed requests
* Wrong payload
* Wrong response

## Storage

* LocalStorage
* SessionStorage
* Cookies

---

# Phase 6 — Next.js Specific Checks

## App Router

Validate:

* page.tsx
* layout.tsx
* loading.tsx
* error.tsx

---

## Server Components

Check:

* Data fetching
* Serialization issues

---

## Client Components

Check:

* use client
* Hydration mismatch
* Browser-only APIs

---

## Middleware

Validate:

* Redirect logic
* Authentication checks

---

# Phase 7 — Common Bug Patterns

## Infinite API Calls

Check:

useEffect dependency array

React Strict Mode

Repeated state updates

---

## Data Not Updating

Check:

Redux selectors

Cache invalidation

React Query keys

State mutation

---

## Blank Screen

Check:

Runtime error

Failed API

Hydration mismatch

Missing provider

---

## Tracking Issues

Check:

Duplicate event firing

Missing payload

Wrong event name

Failed API request

---

## Authentication Issues

Check:

Expired token

Cookie configuration

Middleware redirect

Missing headers

---

## Content Player Issues

Check:

Progress API

Tracking API

Completion logic

Certificate generation trigger

Resume functionality

---

# Phase 8 — Pinpoint Root Cause

Classify:

## UI Bug

Component logic issue

## State Bug

Incorrect state flow

## API Bug

Frontend integration issue

## Routing Bug

Navigation issue

## Tracking Bug

Event handling issue

## Content Player Bug

Player lifecycle issue

---

# Phase 9 — Report

## Frontend Bug Investigation Report

Page: <route></route>

Bug: <expected vs actual></expected>

### Root Cause

<precise explanation>

### Component Path

Route
→ Page
→ Component
→ Hook
→ Service
→ API

### Evidence

Code: <what code shows></what>

Network:
<request/response findings>

Console: <error findings></error>

Screenshot: <supporting evidence></supporting>

### Fix

File: <file path></file>

Change: <required modification></required>

Code Snippet: <example></example>

### How To Verify

1. Open page
2. Perform action
3. Verify result

### Regression Areas

* Related pages
* Related APIs
* Tracking
* Authentication
* Responsive Layout

### Deployment Validation

* Functional Test
* Responsive Test
* Tracking Validation
* API Validation
* Browser Validation

---

# Behavioral Rules

* Reproduce user journey before debugging.
* Trace component → hook → service → API.
* Never start with broad project scanning.
* Use browser evidence to support findings.
* Verify API requests before blaming backend.
* Verify state updates before blaming UI.
* Use exact file references whenever possible.
* Focus on one root cause at a time.
* If root cause is not found, provide top 3 hypotheses with evidence and next validation step.
