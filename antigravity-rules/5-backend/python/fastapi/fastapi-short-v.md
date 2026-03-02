---
trigger: model_decision
description: FastAPI Development Rules. These rules should be applied when introducing new files, routes, functions / methods and when doing security and performance fixes in backend API code.
---

# FastAPI Development Rules

## 1. Naming Conventions

- URLs/Endpoints: Use `kebab-case` only (e.g., `/weather-stations/{station_id}`). Avoid `camelCase` or `snake_case` in paths.
- Functions & Variables: Use `snake_case` (e.g., `get_weather_data()`).
- Classes & Models: Use `PascalCase` (e.g., `WeatherRequest`, `UserProfile`).
- Constants: Use `UPPER_SNAKE_CASE` (e.g., `MAX_RETRY_COUNT`).
- Private Methods: Prefix with an underscore `_snake_case` (e.g., `_validate_data()`).

## 2. API Path Design & REST Principles

- Nouns over Verbs: Paths must represent entities, not actions.
  - Correct: `GET /api/v1/users`
  - Incorrect: `GET /api/v1/get_users`
- Resource Hierarchy: Use logical structures (e.g., `/api/v1/stations/{id}/readings`).
- Versioning: Maintain backward compatibility via URL paths (`/v1/`) or Headers. Organize code into version-specific directories (e.g., `app/api/v1/`).

## 3. HTTP Methods & Status Codes

- GET (200 OK / 404 Not Found): For retrieving resources.
- POST (201 Created): For creating new resources.
- PUT (200 OK): For full resource replacement.
- PATCH (200 OK): For partial updates.
- DELETE (204 No Content): For removing resources.
- Error States:
  - `400 Bad Request`: Client-side error.
  - `401 Unauthorized`: Authentication required.
  - `403 Forbidden`: Lacks permission.
  - `422 Unprocessable Entity`: Validation/Pydantic failure.
  - `500 Internal Server Error`: Server-side failure.

## 4. Project Structure

- Layered Architecture: Separate logic into:
  - `routers/`: Route definitions.
  - `services/`: Business logic.
  - `repositories/`: Data access.
  - `models/`: DB models.
  - `schemas/`: Pydantic DTOs.
- Modularization: Keep `main.py` minimal; use it only for initialization and mounting routers.

## 5. Request & Response Handling

- Validation: Always use Pydantic schemas for request bodies and response models.
- Standardized Response: Enforce a uniform JSON structure:
  ```json
  { "success": true, "message": "string", "data": {}, "meta": {} }
  ```
- Pagination: Use limit and offset query parameters for list-based endpoints.

## 6. Async & Performance

- Non-blocking I/O: Use async def for DB and external API calls.
- Blocking Code: Avoid time.sleep() in async functions; use await asyncio.sleep().
- Optimization:
  - Use Connection Pooling for databases.
  - Use Caching (e.g., Redis) with Cache-Aside patterns.
  - Offload heavy tasks to BackgroundTasks or Celery.

## 7. Error Handling & Security

- Global Handlers: Implement a global exception handler for consistent error reporting.
- Security: Sanitize error messages in production; never expose stack traces.
- Observability: Use Middleware for CORS and rate limiting; integrate Prometheus for metrics (Counter, Histogram).
