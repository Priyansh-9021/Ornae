# Jewellery Virtual Try-On Store

An online jewellery store where customers can virtually try on rings, earrings, and necklaces directly in their browser — using real-time face, hand, and pose tracking — before adding items to cart.

## Architecture

The project is a monorepo with three independently deployable services:

- **`frontend/`** — Next.js + React + TypeScript + Tailwind. Runs MediaPipe (face/hand/pose tracking) and Three.js (3D rendering) client-side in the browser.
- **`backend/`** — Spring Boot + Spring Security + JWT. Core API for products, cart, orders, and auth. Orchestrates calls to the AI processing service and exposes internal endpoints for the chatbot.
- **`chatbot/`** — Python + LangGraph. LLM-based customer support chatbot. Calls the backend's internal API (service-token authenticated) to look up order/customer data on behalf of the active session.

Shared infrastructure: PostgreSQL (primary data store), Redis (cache/sessions), AWS S3 + CloudFront (product images and GLB 3D assets), Docker (containers).

```
Client browser (Next.js + MediaPipe + Three.js)
        │
        ├──► Backend (Spring Boot, JWT auth) ──► PostgreSQL
        │            │                     └───► Redis
        │            │                     └───► S3 + CloudFront
        │            └──► AI processing (FastAPI + PyTorch)
        │
        └──► Chatbot (LangGraph) ──► Backend internal API
```

## Getting started

### Prerequisites
- Docker + Docker Compose
- Node.js 20+ (for local frontend dev without Docker)
- Java 21+ (for local backend dev without Docker)
- Python 3.11+ (for local chatbot dev without Docker)

### Run everything locally

```bash
git clone <repo-url>
cd jewellery-vto-store
cp backend/.env.example backend/.env
cp chatbot/.env.example chatbot/.env
cp frontend/.env.example frontend/.env
# fill in the .env files with real values
docker-compose up
```

- Frontend: http://localhost:3000
- Backend: http://localhost:8080
- Chatbot: http://localhost:8000

### Run a single service without Docker

See the README inside each service folder (`frontend/README.md`, `backend/README.md`, `chatbot/README.md`) for service-specific setup.

## Folder structure

```
jewellery-vto-store/
├── frontend/           # Next.js app
├── backend/             # Spring Boot app
├── chatbot/              # LangGraph support chatbot
├── .github/
│   ├── workflows/        # CI pipelines (per service)
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── CODEOWNERS
├── docker-compose.yml
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## Tech stack

| Layer | Tech |
|---|---|
| Frontend | Next.js, React, TypeScript, Tailwind CSS |
| Tracking | MediaPipe (face/hand/pose, client-side) |
| 3D rendering | Three.js, GLB assets |
| Backend | Spring Boot, Spring Security, JWT |
| AI processing | FastAPI, PyTorch |
| Chatbot | LangGraph |
| Database | PostgreSQL |
| Cache | Redis |
| Object storage / CDN | AWS S3, CloudFront |
| Deployment | Docker, AWS |

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for branch naming, commit conventions, and PR guidelines.

## License

MIT — see [LICENSE](./LICENSE).
