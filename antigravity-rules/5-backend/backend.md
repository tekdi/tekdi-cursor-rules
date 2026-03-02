---
trigger: model_decision
description: Universal Backend Coding Rules. These rules should be applied when introducing new files, routes, functions / methods and when doing security and performance fixes in backend API code.
---

# Universal Backend Coding Standards

## 1. Project Organization & Architecture

- Layered Decoupling: Maintain strict separation between Transport (API/Controllers), Business Logic (Services), and Data Access (Repositories/Models).
- Dependency Inversion: High-level modules must not depend on low-level modules; both should depend on abstractions.
- Single Responsibility: Each module, class, or function must have one reason to change.
- Statelessness: Design services to be stateless to ensure horizontal scalability.

## 2. API Design & Communication

- RESTful Compliance: Use standard HTTP methods (GET, POST, PUT, PATCH, DELETE) and status codes (2xx for success, 4xx for client errors, 5xx for server errors).
- Resource Naming: Use plural nouns for endpoints (e.g., `/users`, `/orders`). Avoid verbs in URLs.
- Versioning: Mandatory API versioning via URL (e.g., `/v1/`) to prevent breaking changes.
- Idempotency: Ensure that PUT and DELETE operations can be called multiple times without side effects beyond the initial change.

## 3. Data Integrity & Persistence

- Soft Deletes: Use a `deleted_at` or `is_active` flag instead of hard-deleting records for auditability.
- Database Transactions: Atomic operations must be wrapped in transactions to maintain data consistency.
- Indexing: Always index columns used in `WHERE`, `JOIN`, and `ORDER BY` clauses to optimize query performance.
- Migrations: All schema changes must be version-controlled via migration scripts; never apply manual DB changes.

## 4. Input Validation & Security

- Strict Validation: Validate all incoming data (body, query, params) against a predefined schema before processing.
- Sanitization: Strip or escape malicious characters to prevent SQL Injection, XSS, and Command Injection.
- Authentication/Authorization:
  - Centralize auth logic via middleware.
  - Follow the Principle of Least Privilege (PoLP).
- Secrets Management: Never hardcode credentials. Use environment variables or a dedicated secret manager.

## 5. Error Handling & Logging

- Structured Error Responses: Return consistent error objects (e.g., `{ "code": "ERR_CODE", "message": "User friendly message", "details": [] }`).
- Global Exception Handling: Implement a catch-all handler to prevent raw stack traces from leaking to the client.
- Centralized Logging: Log significant events (errors, security warnings, audit trails) using structured JSON logging for easy indexing.
- Contextual Logs: Include request IDs or correlation IDs in logs to trace execution across distributed services.

## 6. Performance & Scalability

- Pagination: Mandatory pagination for all list-returning endpoints using `limit/offset` or cursor-based approaches.
- Asynchronous Processing: Offload time-consuming tasks (email, image processing) to background workers or message queues.
- Caching: Implement caching strategies (e.g., Cache-Aside) for frequently accessed, slow-changing data.
- N+1 Query Avoidance: Use eager loading or join-based fetching to prevent excessive database roundtrips.

## 7. Testing & Quality Assurance

- Unit Testing: Aim for high coverage of business logic in service layers.
- Integration Testing: Verify the interaction between the application and external systems (DB, APIs).
- Environment Parity: Ensure development, staging, and production environments are as identical as possible using containerization.
