# Day 8 Reflection

The most difficult concept for me was preventing two users from buying the same seat at nearly the same time. A frontend availability check is not enough because two requests can reach the server before either sees the other's change. I worked through this by treating the database as the source of truth, using a short transaction with a row lock or atomic conditional update, and defining explicit seat and payment states. I also learned that a payment timeout is not necessarily a failed payment, so releasing a seat requires care and reconciliation.

For the capstone, the area I would improve is validation and handling of edge cases. I would use the feedback I received to prioritize concrete changes, then test invalid input, repeated actions, failure states, and overlapping actions. This would help me verify that the changes address real problems and make the system more reliable, rather than relying on visual polish alone.

Next, I want to learn more about SQL transactions, isolation levels, database constraints, and automated tests for concurrent requests. I also want to practise load testing and interpreting latency and error-rate metrics. This assignment helped me see that system design is not just choosing components; it is defining guarantees, making assumptions visible, and explaining how the system behaves when things go wrong.
