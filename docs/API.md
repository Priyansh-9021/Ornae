# API Contract — Jewellery VTO Store

This document is the source of truth for the REST API between `frontend/` and `backend/`. It's a **draft** — endpoints will be implemented incrementally, but the frontend can build against these shapes now using mocked responses. Update this file whenever a contract changes; treat changes here as something to flag in the PR that makes them, since frontend work may depend on the old shape.

## Conventions

- Base URL (dev): `http://localhost:8080/api`
- All request/response bodies are JSON.
- Authenticated endpoints require: `Authorization: Bearer <access_token>`
- Timestamps are ISO 8601 UTC strings (`"2026-09-23T10:15:00Z"`).
- IDs are UUID strings unless noted.

### Standard error response

```json
{
  "timestamp": "2026-09-23T10:15:00Z",
  "status": 400,
  "error": "VALIDATION_ERROR",
  "message": "Email is already registered",
  "path": "/api/auth/register"
}
```

### Standard pagination (list endpoints)

Query params: `?page=0&size=20&sort=createdAt,desc`

```json
{
  "content": [ /* array of items */ ],
  "page": 0,
  "size": 20,
  "totalElements": 137,
  "totalPages": 7
}
```

---

## Auth

### `POST /api/auth/register`
**Body**
```json
{
  "email": "user@example.com",
  "password": "string",
  "fullName": "string"
}
```
**Response `201`**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "fullName": "string"
}
```

### `POST /api/auth/login`
**Body**
```json
{ "email": "user@example.com", "password": "string" }
```
**Response `200`**
```json
{
  "accessToken": "jwt",
  "refreshToken": "jwt",
  "expiresIn": 3600,
  "user": { "id": "uuid", "email": "string", "fullName": "string" }
}
```

### `POST /api/auth/refresh`
**Body**
```json
{ "refreshToken": "jwt" }
```
**Response `200`**
```json
{ "accessToken": "jwt", "expiresIn": 3600 }
```

### `POST /api/auth/logout`
**Auth required.** Invalidates the refresh token. **Response `204`**

---

## Users

### `GET /api/users/me`
**Auth required.**
**Response `200`**
```json
{
  "id": "uuid",
  "email": "string",
  "fullName": "string",
  "createdAt": "timestamp"
}
```

### `PUT /api/users/me`
**Auth required.**
**Body**
```json
{ "fullName": "string" }
```
**Response `200`** — same shape as `GET /api/users/me`

---

## Categories

### `GET /api/categories`
**Response `200`**
```json
[
  { "id": "uuid", "name": "Rings", "slug": "rings" },
  { "id": "uuid", "name": "Earrings", "slug": "earrings" },
  { "id": "uuid", "name": "Necklaces", "slug": "necklaces" }
]
```

---

## Products

### `GET /api/products`
**Query params:** `?category=rings&minPrice=1000&maxPrice=50000&metalType=gold&page=0&size=20`
**Response `200`** — paginated list of:
```json
{
  "id": "uuid",
  "name": "string",
  "description": "string",
  "category": { "id": "uuid", "name": "Rings", "slug": "rings" },
  "metalType": "gold | silver | platinum",
  "price": 24999.00,
  "currency": "INR",
  "images": ["https://cdn.../img1.jpg"],
  "glbModelUrl": "https://cdn.../ring_01.glb",
  "stock": 12,
  "createdAt": "timestamp"
}
```

### `GET /api/products/{id}`
**Response `200`** — single product, same shape as above

### `POST /api/products` — admin only
**Auth required (admin role).**
**Body** — same shape as product, minus `id`/`createdAt`
**Response `201`**

### `PUT /api/products/{id}` — admin only
**Body** — partial or full product fields
**Response `200`**

### `DELETE /api/products/{id}` — admin only
**Response `204`**

---

## Cart

### `GET /api/cart`
**Auth required.**
**Response `200`**
```json
{
  "id": "uuid",
  "items": [
    {
      "id": "uuid",
      "product": { "id": "uuid", "name": "string", "price": 24999.00, "images": ["..."] },
      "quantity": 1,
      "subtotal": 24999.00
    }
  ],
  "total": 24999.00
}
```

### `POST /api/cart/items`
**Auth required.**
**Body**
```json
{ "productId": "uuid", "quantity": 1 }
```
**Response `201`** — updated cart, same shape as `GET /api/cart`

### `PUT /api/cart/items/{itemId}`
**Body**
```json
{ "quantity": 2 }
```
**Response `200`** — updated cart

### `DELETE /api/cart/items/{itemId}`
**Response `204`**

---

## Orders

### `POST /api/orders`
**Auth required.** Creates an order from the current cart (checkout).
**Body**
```json
{
  "shippingAddress": {
    "line1": "string",
    "line2": "string",
    "city": "string",
    "state": "string",
    "postalCode": "string",
    "country": "string"
  },
  "paymentMethodId": "string"
}
```
**Response `201`**
```json
{
  "id": "uuid",
  "status": "PENDING | CONFIRMED | SHIPPED | DELIVERED | CANCELLED",
  "items": [ /* order items, same shape as cart items */ ],
  "total": 24999.00,
  "shippingAddress": { /* as above */ },
  "createdAt": "timestamp"
}
```

### `GET /api/orders`
**Auth required.** Paginated list of the current user's orders.

### `GET /api/orders/{id}`
**Auth required.** Single order detail — same shape as `POST /api/orders` response.

---

## Internal API (chatbot ↔ backend only)

Not consumed by the frontend. Authenticated via a service token (`Authorization: Bearer <service_token>`), not a user JWT.

### `GET /internal/customers/{customerId}/orders`
Returns the given customer's orders — only callable when the chatbot's active session is authenticated as that customer.

### `GET /internal/orders/{orderId}/status`
Returns order status + shipping tracking info for a given order.

---

## Try-on / AI processing (via backend, not called directly by frontend)

### `POST /api/try-on/process`
**Auth required.**
**Body**
```json
{ "productId": "uuid", "landmarkData": { /* MediaPipe landmark payload */ } }
```
**Response `200`**
```json
{ "renderedAssetUrl": "https://cdn.../render_result.glb" }
```
*(Exact shape TBD once the AI processing service's interface is finalized — placeholder for frontend to build against.)*

---

## Open questions / TBD

- Product image upload endpoint for admin (multipart vs. presigned S3 URL flow)
- Wishlist/favorites endpoints
- Review/rating endpoints
- Search endpoint (separate from filtered `GET /api/products`?)
