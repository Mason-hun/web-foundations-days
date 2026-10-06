# Library Books API

This API manages books in a library system. It follows REST conventions and uses the `books` resource.

## Endpoints

### 1. List all books

- **Method:** GET
- **Path:** `/books`
- **Description:** Returns a list of all books.
- **Success status:** `200 OK`

Example request:

```http
GET /books

```

2. Get one book
- Method: GET
- Path: /books/{id}
- Description: Returns a single book using its ID.
- Success status: 200 OK
Example request
GET /books/42

3. Create a book
- Method: POST
- Path: /books
- Description: Creates a new book.
- Success status: 201 Created
Example request body
{
  "title": "The Alchemist",
  "author": "Paulo Coelho",
  "year": 1988
}

4. Update a book
- Method: PATCH
- Path: /books/{id}
- Description: Updates one or more fields of an existing book.
- Success status: 200 OK
Example request
PATCH /books/42

Example request body
{
  "title": "The Alchemist - Updated Edition"
}

5. Delete a book
- Method: DELETE
- Path: /books/{id}
- Description: Deletes a book using its ID.
- Success status: 204 No Content
Example request
DELETE /books/42

6. List books by author
- Method: GET
- Path: /books?author=Paulo%20Coelho
- Description: Returns books written by the specified author.
- Success status: 200 OK
Example request
GET /books?author=Paulo%20Coelho

Error Codes
400 Bad Request
The request is invalid or contains missing or incorrect data.
Example
POST /books

For example, the request is missing the required title or author.
404 Not Found
The requested resource does not exist.
Example
GET /books/9999

For example, book 9999 does not exist.

**That's your `library-api.md`.**

You don't run any of those requests.

---

# Part B — What you do in the browser

Everything starting from:

> **Test it**

is **not part of `library-api.md`.**

It's instructions for testing your actual:

```text