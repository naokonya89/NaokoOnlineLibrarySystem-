# Enhanced Project Requirements: Online Library System

## 1. Project Overview & Vision
The Online Library System is a comprehensive, full-stack web application designed to modernize library management. It serves three distinct user groups. Members can browse the catalog, manage their borrowing history, and place reservations. Administrators and librarians manage library operations, inventory, user accounts, and site content. Developers can generate and manage API keys to build third-party integrations. This project aims to deliver a robust, secure, and scalable solution from planning through a deployable codebase, utilizing modern web technologies and cloud infrastructure.

## 2. Required Tech Stack & Architecture
The application follows a decoupled architecture, separating the client interface from the API and data layers. 

For the frontend, the application utilizes Next.js with React, written in plain JavaScript as requested, avoiding TypeScript. Styling is handled via Tailwind CSS to ensure a responsive, utility-first design. State management can be handled via the React Context API or Zustand, while data fetching is managed by SWR or React Query.

The backend API runs on Node.js using the Express.js framework to deliver a RESTful architecture. Zod is employed for robust request payload validation. Security is reinforced using middleware such as `express-rate-limit`, `helmet`, and proper CORS configurations.

Data persistence, authentication, and file storage are managed by Supabase. The system relies on PostgreSQL with Row Level Security (RLS) to enforce data access rules. Authentication is handled via Supabase Auth, supporting both Email/Password and Google OAuth. Supabase Storage is utilized for hosting book covers and other site assets.

For deployment, the backend is containerized using Docker, making it deployable to environments like Hostinger VPS, AWS EC2 or ECS, and Google Cloud Compute Engine or Cloud Run. The Next.js frontend is configured for Static HTML Export or Server-Side Rendering (SSR), suitable for hosting on Vercel, Netlify, or the aforementioned cloud providers.

## 3. Visual Theme & UI/UX Guidelines
The application must strictly adhere to the "Yellow Ochre Classic" theme to evoke a traditional, warm library atmosphere while maintaining modern usability. The design language features moderate rounded corners, soft drop shadows, and accessible contrast ratios. A mobile-first approach ensures a seamless experience across desktop, tablet, and mobile devices.

Typography relies on serif fonts such as Playfair Display or Merriweather for headings, providing a classic literary feel. Sans-serif fonts like Inter or Lato are used for body text to ensure high readability.

| Color Element | Hex Code | Description |
| :--- | :--- | :--- |
| Primary | `#C68E17` | Yellow Ochre, used for primary actions and branding. |
| Accent | `#D9A441` | Used for secondary actions and highlights. |
| Background (Light) | `#FFF8E7` | Used for main content areas to provide a warm reading environment. |
| Background (Dark) | `#4A3B2A` | Used for footers, sidebars, or dark mode sections. |
| Text (Primary) | `#2E2418` | High contrast text for primary readability. |
| Text (Secondary) | `#6B5B3E` | Used for muted text and secondary information. |
| Success | `#6B8E23` | Semantic color indicating successful actions. |
| Warning/Overdue | `#B85C38` | Semantic color indicating errors or overdue items. |
| Borders/Dividers | `#E0C88E` | Used to separate content blocks smoothly. |

## 4. Core Features by Domain

### 4.1 Public Website (Unauthenticated)
The public-facing website serves as the entry point for all users. The landing page features a dynamic hero section, highlights new and featured arrivals, and displays published announcements. The catalog provides advanced search functionality, allowing users to filter books by category, author, availability status, and publication year. Each book has a dedicated details page showcasing a high-resolution cover image, description, ISBN, total and available copies, alongside user reviews and ratings. An authentication portal handles user registration, login, and password recovery flows.

### 4.2 Member Dashboard
Authenticated members have access to a personalized dashboard. They can view their currently active loans, which include calculated due dates and visual indicators for approaching deadlines. A paginated history view allows members to review past borrowings. If a desired book is unavailable, members can place reservations and track their position in the queue. The dashboard also provides a financial overview of outstanding fines for overdue items. Furthermore, members can manage their profile details and submit reviews or ratings for books they have borrowed.

### 4.3 Admin & Librarian Dashboard
Administrators and librarians require comprehensive tools to manage the library. The inventory management system allows full CRUD operations for books, including the ability to upload cover images directly to Supabase Storage. Books can be organized using the category management feature. The user management interface enables staff to search, view, suspend, or delete member accounts, as well as manage role assignments. 

The circulation desk handles the issuing and returning of books, automatically calculating and applying fines for overdue returns based on predefined rules. Staff can also manage the reservation hold queue, notifying users when items become available. To monitor library performance, visual analytics dashboards built with Recharts display metrics such as the most popular books, active user trends, and revenue generated from fines. Additionally, a built-in CMS featuring a WYSIWYG editor (such as TipTap or React-Quill) allows non-technical staff to publish news and announcements. System settings for global variables like site name, contact info, and fine rates are also accessible here.

### 4.4 Developer Portal
The developer portal provides tools for third-party integration. Developers can generate secure API keys; the system displays the plaintext key only once upon creation, subsequently storing only a cryptographic hash. A key management UI presents a data table detailing each key's label, creation date, last used timestamp, status, and usage metrics. Developers can revoke or regenerate keys as needed. The portal allows configuring and monitoring per-key rate limits. Usage analytics are provided through logs and charts displaying API endpoint usage over time, filterable by specific keys. To facilitate integration, the portal embeds a Swagger UI or OpenAPI specification. Finally, developers can toggle keys between test and live modes.

## 5. Database Schema & Security (Supabase)

The database architecture relies on several interconnected tables. The `profiles` table extends the default `auth.users` table, storing additional information such as full name and role. The `books` table tracks inventory details including title, author, ISBN, category reference, and copy counts. Categories are managed in a dedicated `categories` table. Transactional data is handled by the `borrowings` and `reservations` tables, tracking user interactions with the inventory. User feedback is stored in the `reviews` table. Developer integrations are supported by the `api_keys` and `api_usage_logs` tables. Finally, the `announcements` table stores content for the public website.

Security is enforced at the database level using Row Level Security (RLS) policies. Public users have read-only access to books, categories, and published announcements. Members are restricted to reading and writing only their own borrowings, reservations, reviews, and profile records. Developers are similarly restricted to their own API keys and usage logs. Administrators possess unrestricted CRUD access across all tables.

At the application level, security is maintained by hashing API keys before database storage, ensuring plaintext keys are never saved. Environment variables are strictly separated using `.env` files. All incoming data is sanitized and validated using Zod, and HTTPS is enforced for all external communications.

## 6. Project Structure
The repository is organized to separate concerns and facilitate deployment.

| Directory/File | Description |
| :--- | :--- |
| `frontend/` | Contains the Next.js application, plain JavaScript code, and Tailwind configurations utilizing the Yellow Ochre theme. |
| `backend/` | Contains the Express API, including routes, controllers, middleware, and configuration files. |
| `supabase/migrations/` | Stores SQL schema definitions and RLS policies. |
| `supabase/seed.sql` | Contains seed data including at least 15 books, 5 categories, and sample user accounts. |
| `docker/Dockerfile` | Defines the production-ready Node.js container for the backend. |
| `docs/API.md` | Provides comprehensive REST API documentation. |
| `README.md` | Contains the setup and deployment guide for various hosting providers. |

## 7. Execution & Delivery Plan
To ensure quality, the project should be implemented in the following sequential phases, with verification at each step:

1. **Infrastructure & Data Layer**: Set up the Supabase project, apply SQL migrations, configure RLS policies, and insert the initial seed data.
2. **Backend Development**: Build the Express API, integrate the Supabase Auth middleware, and implement the custom API-key validation middleware.
3. **Public Frontend**: Develop the landing page, catalog, book details view, and authentication flows.
4. **Member Experience**: Build the member dashboard covering borrowings, reservations, and profile management.
5. **Admin Operations**: Build the admin dashboard including inventory management, user administration, circulation desk, CMS, and analytics.
6. **Developer Tools**: Implement the developer portal and the API key management UI.
7. **Theming & Polish**: Apply the "Yellow Ochre Classic" theme globally and ensure rigorous responsive testing across all views.
8. **Documentation**: Write the comprehensive `README.md` with explicit deployment instructions for Hostinger, AWS, and Google Cloud.
9. **End-to-End Testing**: Conduct a full system walkthrough encompassing member registration, book borrowing, admin return processing, and developer API key generation and invocation.

## 8. Final Deliverables
The final delivery will include a complete, well-commented source code repository containing both the frontend and backend applications. It will feature Supabase SQL migration and seed scripts, alongside a `Dockerfile` for backend containerization. Documentation will include a comprehensive `README.md`, an `API.md` file, and an `.env.example` detailing all required environment variables. Finally, a summary report detailing implementation decisions and assumptions will be provided.
