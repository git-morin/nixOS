# Python

I use python occasionally. I've also had to use python professionally (in a Data Science context).

Here's a few things I learned/recommend:

- Find a good project/dependency management tool
  - `uv`, `poetry`, `hatch` etc...
- Pin dependencies (and use something alike to renovate or dependabot).
- Find a good logging library if needed
  - `loguru`, `structlog`, etc...
- Use `pytest` as the test framework
  - use many of its sub-dependencies when needed
    - such as `pytest-env`, `pytest-mock`, etc...
    - fixtures are a great way to reduce code that sets up a test.
- Read up on decorators, list comprehension, and the walrus operator (`:=`).


I also use python to do a quick `pulumi` set-up codebase, but I've recently started going to typescript instead...