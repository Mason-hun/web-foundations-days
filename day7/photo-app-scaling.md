# SnapShare Scaling Plan

## 1. Assumptions

The following assumptions are used for the SnapShare system:

- There are 10,000,000 registered users.
- 10% of registered users are active each day.
- Each active user uploads 1 photo per day.
- Each active user views 50 feed pages per day.
- An average original photo is 2 MB.
- Each photo also has a 50 KB thumbnail.
- For rough calculations, 1 day is approximately 100,000 seconds.
- Peak traffic is estimated to be 5 times the average traffic.

### Daily Active Users

10,000,000 registered users × 10%

= **1,000,000 daily active users (DAU)**

---

## 2. Traffic and Storage Estimates

### Photo Uploads

Each active user uploads 1 photo per day:

1,000,000 users × 1 photo

= **1,000,000 photo uploads per day**

Using approximately 100,000 seconds per day:

1,000,000 ÷ 100,000

≈ **10 uploads per second on average**

Peak traffic at 5×:

10 × 5

≈ **50 uploads per second at peak**

### Feed Views

Each active user views 50 feed pages per day:

1,000,000 users × 50 feed views

= **50,000,000 feed views per day**

Using approximately 100,000 seconds per day:

50,000,000 ÷ 100,000

≈ **500 feed views per second on average**

Peak traffic at 5×:

500 × 5

≈ **2,500 feed views per second at peak**

### Photo Storage

Each photo requires:

- Original photo = 2 MB
- Thumbnail = 50 KB = 0.05 MB

Therefore:

2 MB + 0.05 MB

= **2.05 MB per photo**

Daily storage:

1,000,000 photos × 2.05 MB

= **2,050,000 MB per day**

≈ **2.05 TB per day**

Yearly storage:

2.05 TB × 365

≈ **748.25 TB per year**

Therefore, SnapShare generates approximately **748.25 TB of new photo and thumbnail storage per year**, before accounting for backups or additional replication.

---

## 3. Read-Heavy or Write-Heavy?

SnapShare is a **read-heavy system**.

The system handles approximately:

- 10 photo uploads per second on average
- 500 feed views per second on average

This means there are approximately **50 feed views for every photo upload**.

Because SnapShare is read-heavy, the architecture should focus on making feed requests fast and reducing pressure on the primary database. A cache can serve frequently requested feed data, read replicas can handle database read queries, and a CDN can deliver photos and thumbnails efficiently to users.

---

## 4. Why Photos Should Not Be Stored in the Database

Photos should not be stored directly inside the database because they are large binary files and SnapShare will generate approximately 748.25 TB of new media data each year. Storing this volume of media inside the database would increase database size, backup requirements, storage costs, and database workload.

Instead, original photos and thumbnails should be stored in **object storage**, which is designed for storing large amounts of files and can scale independently of the application database.

The database should store structured metadata about each photo, such as:

- Photo ID
- User ID
- Object storage key or URL
- Caption
- Creation timestamp
- Other photo metadata

This keeps structured application data separate from large media files.

---

## 5. SnapShare Architecture

```text
                              ┌──────────────┐
                              │     DNS      │
                              └──────┬───────┘
                                     │
                                     ▼
                              ┌──────────────┐
                              │     CDN      │
                              │              │
                              │ Photos and   │
                              │ thumbnails   │
                              └──────┬───────┘
                                     │
                              API requests
                                     │
                                     ▼
                           ┌──────────────────┐
                           │  Load Balancer   │
                           └────────┬─────────┘
                                    │
                     ┌──────────────┼──────────────┐
                     ▼              ▼              ▼
                ┌─────────┐   ┌─────────┐   ┌─────────┐
                │ App     │   │ App     │   │ App     │
                │ Server 1│   │ Server 2│   │ Server 3│
                └────┬────┘   └────┬────┘   └────┬────┘
                     │              │              │
                     └──────────────┼──────────────┘
                                    │
                 ┌──────────────────┼──────────────────┐
                 │                  │                  │
                 ▼                  ▼                  ▼
          ┌─────────────┐    ┌─────────────┐    ┌──────────────┐
          │    Cache    │    │   Primary   │    │    Object    │
          │   (Redis)   │    │  Database   │    │   Storage    │
          └─────────────┘    └──────┬──────┘    │              │
                                    │             │ Original     │
                                    │             │ photos and   │
                                    │             │ thumbnails   │
                                    ▼             └──────────────┘
                              ┌─────────────┐
                              │ Read Replica│
                              └─────────────┘

                          Thumbnail Processing
                                    │
                                    ▼
                              ┌─────────────┐
                              │    Queue    │
                              └──────┬──────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │   Worker    │
                              │  Thumbnail  │
                              │  Generator  │
                              └──────┬──────┘
                                     │
                                     ▼
                              Object Storage

```

## 6. What Each Component Does
### DNS
DNS translates the SnapShare domain name into the network address used to reach the application.
### CDN
The CDN serves photos and thumbnails from locations closer to users, reducing latency and the load on the origin infrastructure.
### Load Balancer
The load balancer distributes incoming requests across healthy application servers so that traffic is shared and individual server failures do not bring down the entire application.
### App Servers
Application servers run SnapShare's backend logic and handle requests such as authentication, feed retrieval, photo uploads, and metadata operations.
### Cache
The cache stores frequently requested feed data in fast memory so repeated requests can be served without querying the database every time.
### Primary Database
The primary database stores structured application data such as users, photo metadata, captions, follows, and other records while handling write operations.
### Read Replica
The read replica receives replicated data from the primary database and handles read queries, reducing read pressure on the primary database.
### Object Storage
Object storage stores the large original photos and thumbnails separately from the database and can scale to hundreds of terabytes of media.
### Message Queue
The message queue stores background thumbnail-generation jobs so that image processing does not block the user's upload request.
### Worker
The worker consumes thumbnail-generation jobs from the queue, creates thumbnails from the original photos, and stores the resulting thumbnails in object storage.

## 7. Photo Upload Flow
When a user uploads a photo, the process works as follows:
1. The user selects a photo in the SnapShare application.
2. The upload request is sent to the backend through the load balancer.
3. The load balancer forwards the request to a healthy application server.
4. The application server authenticates the user and validates the uploaded file.
5. The original photo is stored in object storage.
6. The application creates a photo record in the primary database containing metadata such as the user ID, object-storage key, caption, and creation time.
7. The application adds a thumbnail-generation job to the message queue.
8. The application can return a successful upload response without waiting for thumbnail generation to finish.
9. A background worker retrieves the job from the queue.
10. The worker processes the original photo and creates the thumbnail.
11. The worker stores the thumbnail in object storage.
12. The CDN can then serve the photo and thumbnail efficiently to users viewing the content.
Using a queue and worker makes thumbnail generation asynchronous, so image processing does not unnecessarily increase the latency of the upload request.

## 8. Trade-offs
### Performance vs Freshness
Caching feed data improves response time and reduces database load, but cached information can become stale. SnapShare must therefore decide how long feed data should remain cached and when cached data should be invalidated.
### Simplicity vs Scalability
A single server and database would be simpler and cheaper to operate, but they would become bottlenecks and single points of failure as traffic grows. Multiple application servers, caching, replicas, and background workers improve scalability but introduce additional infrastructure and operational complexity.
### Consistency vs Availability
Read replicas improve read capacity and can increase availability, but replication can introduce a small amount of lag. A user may therefore briefly receive slightly older feed data from a replica.
### Cost vs Performance
CDNs, caches, read replicas, and object storage improve performance and scalability, but they increase infrastructure costs. SnapShare should use these components where their performance and scalability benefits justify the additional cost.

## Conclusion
SnapShare is a strongly read-heavy system with approximately 500 average feed views per second compared with approximately 10 average photo uploads per second. The system therefore benefits from caching, read replicas, and a CDN to handle its large read workload efficiently.
The approximately 748.25 TB of new media generated each year also makes object storage a better choice for the actual photo files, while the database should store structured photo metadata.
The architecture uses a load balancer and multiple application servers for scalability and availability, while a message queue and background worker allow thumbnail generation to happen asynchronously without making users wait for image processing.                           