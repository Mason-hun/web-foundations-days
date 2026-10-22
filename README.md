# Web Foundations Days

Assignments and design exercises for the **1 Million Devs for Africa — Software Engineering** program, Module 3: Web Development.

This repository records both the work and the reasoning behind it. The goal is to practise building, testing, explaining, and improving software—not only finishing assignments.

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
    ├── ticketing-design.md
    └── reflection.md
```

## Day 8 — TicketHub system design

TicketHub is a proposed concert and event ticketing system. The central challenge is handling a high-demand sale correctly when **200,000 people compete for 20,000 seats within 10 minutes**.

Deliverables:

- [`day8/ticketing-design.md`](day8/ticketing-design.md) — requirements, traffic estimates, API proposal, relational data model, architecture, trade-offs, double-booking prevention, and validation plan.
- [`day8/reflection.md`](day8/reflection.md) — reflection on the most difficult concept, a capstone improvement, and next learning goals.

### Traffic estimates

The assignment states 50,000 normal-day visitors and 10 pages per visitor:

- 50,000 × 10 = **500,000 page views/day**.
- 500,000 ÷ 86,400 ≈ **5.79 page views/second** as a 24-hour average.

For the popular sale, the design uses explicit working assumptions of 3 page views per participant and 2 API requests per page:

- 200,000 × 3 = **600,000 page views** in 10 minutes.
- 600,000 ÷ 600 = **1,000 average page views/second**.
- 600,000 × 2 = **1.2 million API requests**.
- 1.2 million ÷ 600 = **2,000 average API requests/second**.

These are planning estimates, not measured peak rates or a capacity guarantee. Actual bursts, page behavior, retries, and checkout operations must be measured and load-tested.

### Core correctness decision

The frontend can display availability, but only the backend/database can authoritatively allocate a seat. The design uses a short atomic transaction or row lock for holds, explicit payment states, idempotent processing, and reconciliation for uncertain or delayed payment outcomes. Email delivery is not the source of truth for a purchase.

## Working locally

Inspect your branch and working tree before making changes:

```bash
git status -sb
git branch --show-current
git log -5 --oneline
```

After reviewing your changes, stage only the files intended for the commit:

```bash
git diff
git add day8/ticketing-design.md day8/reflection.md README.md
git commit -m "Complete Day 8 TicketHub assignment"
git push origin main
```

These commands assume you are working on `main` and have reviewed any unrelated changes first. Do not stage unrelated files blindly.

## Engineering approach

1. Understand the problem and constraints.
2. Make assumptions explicit.
3. Design the smallest solution that meets the requirements.
4. Explain decisions and trade-offs.
5. Check edge cases and failure modes.
6. Separate known facts, assumptions, and unresolved questions.
7. Validate, document, commit, and reflect.

A component is not justified simply because it is common. Each component should solve a stated problem, and its costs and failure modes should be understood.
