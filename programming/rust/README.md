# Rust

## Resources

- [Rust Programming Language](https://www.rust-lang.org/)
- [Rustlings hands on course](https://github.com/rust-lang/rustlings/)
- [Rust Standard Library](https://doc.rust-lang.org/std/index.html)

A full set of documentation and web-books is available at [Learn Rust](https://www.rust-lang.org/learn) ; the main resources in the form of *books* are listed below following their order of importance in the beginner learning path:

- [Rust Book](https://doc.rust-lang.org/book/)
- [Rust By Example](https://doc.rust-lang.org/rust-by-example/)
- [The Cargo Book](https://doc.rust-lang.org/cargo/index.html)

## Beginner cheat-sheet

### Compilation and Cargo

Create `hello.rs` with the following and compile with `rustc hello.rs`:

```rust
// Comments are just like in C!
/*
	Multiline also work, but I don't like it!
*/
fn main() {
	println!("Hello, world!");
}
```

Create a new project with `cargo new hello-cargo`; enter the folder and `cargo run`. Alternatively create the folder manually, enter it and `cargo init`.

### Data types

- Primitives
- Compounds
- Collections

### Functions and ownership

- Definition
- Ownership
- Borrowing
- References

### Variables and mutability

- Declaration
- Mutability
- Constants
- Shadowing

### Control flow

- Conditionals
- Loops

### Structures and enumerations

### Error handling

- Results
- Options

