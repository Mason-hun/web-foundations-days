# Web Foundations Days

Assignments and design exercises for the **1 Million Devs for Africa — Software Engineering** program, Module 3: Web Development.

This repository records the daily work and the reasoning behind it. The goal is not just to finish assignments, but to practise building, testing, explaining and improving software.

## Repository structure

```text
web-foundations-days/
├── day1/
├── day2/
├── day3/
├── day4/
├── day5/
├── day6/
├── day7/
└── day8/
    └── ticketing-design.md
```

The Day 8 files are being developed incrementally. The final assignment requires:

- `day8/ticketing-design.md` — TicketHub requirements, traffic estimates, API, data model, architecture, and trade-offs.
- `day8/reflection.md` — a 150–300 word reflection on the course, capstone feedback, and next learning goals.

## Day 8 — TicketHub system design

TicketHub is a proposed concert and event ticketing website. The main design challenge is handling a high-demand sale correctly when **200,000 people compete for 20,000 seats within 10 minutes**.

Current work is in [`day8/ticketing-design.md`](day8/ticketing-design.md). It is a **working draft**, not the final submission.

Topics already explored:

- Functional and non-functional requirements.
- Seat availability, temporary holds, payment-pending states and confirmed purchases.
- Fairness and virtual waiting-room policies.
- Normal traffic versus big-sale traffic.
- The difference between page views, API requests, backend operations and database transactions.
- Proposed REST API endpoints and HTTP methods.
- Initial data entities and relationships.
- Preventing double-booking with database transactions and constraints.
- A provisional architecture and initial trade-offs.

### Current traffic assumptions

The assignment provides 50,000 normal-day visitors viewing 10 pages each:

- 500,000 normal-day page views.
- About 5.79 page views per second as a 24-hour average.

For the popular sale, the current working assumptions are 3 page views per participant and 2 API requests per page:

- 200,000 participants × 3 pages = 600,000 page views.
- 600,000 page views ÷ 600 seconds = 1,000 average page views per second.
- 600,000 page views × 2 API requests = 1.2 million API requests.
- 1.2 million requests ÷ 600 seconds = 2,000 average API requests per second.

These are **assumptions for initial planning**, not measured facts or a peak capacity guarantee. The design draft records the limitations and questions still to resolve.

## Working locally

Open a terminal in the repository and inspect the current state before changing files:

```bash
git status
git branch --show-current
git log -5 --oneline
```

After reviewing your changes:

```bash
git diff
git add day8/ticketing-design.md README.md
git commit -m "Start Day 8 TicketHub design"
git push origin main
```

These commands assume you are working on `main` and that the working tree is otherwise understood. If you are on another branch or have unrelated changes, inspect `git status` and adapt before committing. Don't stage unrelated files blindly.

## Engineering approach

The working method for this repository is:

1. Understand the problem and its constraints.
2. Make assumptions explicit.
3. Design the smallest solution that satisfies the requirements.
4. Explain decisions and trade-offs.
5. Check edge cases and failure modes.
6. Document what is known, assumed and still unresolved.
7. Commit meaningful increments and reflect on what changed.

A diagram or technology choice is not justified just because it is common. Each component should solve a stated problem, and its costs and new failure modes should be understood.
