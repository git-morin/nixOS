# Java

I've used Java professionally, primarily in enterprise environments. Here are my notes:

## Build Tools

- Primarily used Maven over Gradle.
- If using Maven, consider using the Maven Wrapper (`mvnw`) for reproducibility.
- **Pin your dependencies**.

## Frameworks

- **Spring Boot** - The DI framework for Java

## Testing

- Use **JUnit 5** with **Mockito** for unit testing.
  - Do not mock POJOs, they should be constructed as usual during tests.
- Consider **Testcontainers** for integration tests with databases/services.

## Code Quality

- Use `@Nullable` annotations to catch null pointer issues.
- **Lombok** to help reduce boilerplate and redundant code.

## Java Versions

- I've sparingly programmed in Java 8.
- I've programmed most of the time in Java 17 and 21.
