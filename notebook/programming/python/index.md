# python

I use python occasionally (mainly for quick scripts).

I also use python professionally (in a Data Science context, in a DataLake SaaS).

Here's a few things I learned/recommend:

- Find a good project/dependency management tool
  - `uv`, `poetry`, `hatch`, `conda/mamba`, etc...
- Follow a structure in projects (`src/`, etc...)
- Pin dependencies (and use something like renovate or dependabot).
- Find a good logging library if needed
  - `loguru`, `structlog`, etc...
- Use `pytest` as the test framework
  - use many of its sub-dependencies when needed
    - such as `pytest-env`, `pytest-mock`, etc...
    - fixtures are a great way to reduce code that sets up a test.
- Read up on decorators, list comprehension, and the walrus operator (`:=`).
