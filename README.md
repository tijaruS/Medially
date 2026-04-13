# Medially

> A full-stack social media platform built with Next.js 14, TypeScript, and PostgreSQL.

![TypeScript](https://img.shields.io/badge/TypeScript-95%25-3178C6?style=flat-square&logo=typescript&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-14-000000?style=flat-square&logo=next.js)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=flat-square&logo=prisma)

---

## Overview

Medially is a social media application with a focus on type safety, clean data modeling, and a responsive UI. Built using the Next.js 14 App Router with React Server Components, Prisma ORM for the database layer, and shadcn/ui for the component library.

## Features

- **Authentication** — Session-based user auth with protected routes
- **Posts & Feed** — Create, read, and interact with posts in a real-time feed
- **Responsive UI** — Mobile-first design using Tailwind CSS and shadcn/ui components
- **Type-safe codebase** — End-to-end TypeScript with strict mode enabled
- **Database layer** — Prisma ORM with schema-first data modeling on PostgreSQL
- **Automated setup** — `start-db.sh` script handles database initialization and migrations

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 14 (App Router) |
| Language | TypeScript |
| Database | PostgreSQL |
| ORM | Prisma |
| UI Components | shadcn/ui |
| Styling | Tailwind CSS |

## Project Structure

```
Medially/
├── prisma/
│   └── schema.prisma       # Database schema
├── public/                 # Static assets
├── src/
│   ├── app/                # Next.js App Router pages & layouts
│   ├── components/         # Reusable UI components
│   └── lib/                # Utilities, DB client, auth helpers
├── start-db.sh             # DB init & migration script
├── next.config.ts
└── tsconfig.json
```

## Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL running locally (or a connection string)

### Installation

```bash
# Clone the repo
git clone https://github.com/tijaruS/Medially.git
cd Medially

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your DATABASE_URL and auth secrets

# Initialize the database
bash start-db.sh

# Run the development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Environment Variables

```env
DATABASE_URL="postgresql://user:password@localhost:5432/medially"
NEXTAUTH_SECRET="your-secret"
NEXTAUTH_URL="http://localhost:3000"
```

## Author

**Surajit Das** — [@tijaruS](https://github.com/tijaruS)
