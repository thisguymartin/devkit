---
name: engineering-principles
description: Applies core engineering principles, decision framework, and code standards. Use when making design decisions, reviewing code, or when the user asks about trade-offs or priorities.
---

# Engineering Principles

## Core Principles

- Solve the right problem first, then solve it well
- Correctness, safety, clarity -> then optimization
- Make assumptions explicit; challenge risky ones
- Design for failure, detection, recovery
- Simple, proven, boring solutions over novelty
- Communicate reasoning and trade-offs, not just answers
- Slow down for irreversible decisions

## Decision Framework

**MUST**
- Be correct before fast
- State assumptions and trade-offs
- Minimize complexity
- Explain reasoning

**SHOULD**
- Simplify the problem first
- Design for failure modes
- Use evidence over intuition
- Progress incrementally
- Minimize dependencies

**MAY**
- Add complexity only for clear value
- Use novel approaches with justification
- Defer decisions under high uncertainty

## Code Standards

- Readable > clever
- Explicit > implicit
- Testable always
- Deterministic behavior
- Isolated complexity
- Minimal dependencies

## Priority Order

1. Safety & Correctness
2. Understandability
3. Robustness
4. Maintainability
5. Performance
6. Novelty

## Mindset

Engineer for reality: misuse, incomplete info, changing requirements, maintenance by others.

## Mandatory Pre-Flight (Before Planning)

Verify:
1. Objective and success criteria are clear
2. Constraints are identified
3. System boundaries are defined
4. Key assumptions are listed
5. At least one failure mode is considered

If any item is unclear, pause and ask clarifying questions.

---

## SOLID Principles

Each principle with code smell signals and refactoring examples.

### S — Single Responsibility Principle (SRP)

A class/module should have one reason to change.

**Code Smell:** Class does data fetching, business logic, and UI rendering. Change in API breaks unrelated tests.

**Signal:** "This class has too many verbs in its name" (UserFetcherAndSerializerAndPresenter).

**Example:**
```typescript
// ❌ Violation: Multiple responsibilities
class UserManager {
  fetchUser(id: string) { /* API call */ }
  validateUser(user: User) { /* validation */ }
  sendEmail(user: User) { /* email logic */ }
}

// ✅ Compliant: Separated concerns
class UserFetcher { fetchUser(id: string) { ... } }
class UserValidator { validate(user: User) { ... } }
class UserNotifier { notify(user: User) { ... } }
```

### O — Open/Closed Principle (OCP)

Entities should be open for extension but closed for modification.

**Code Smell:** Adding a new payment type requires changing existing switch statements or if-else chains.

**Signal:** "Adding feature X requires editing file Y."

**Example:**
```typescript
// ❌ Violation: Must modify to add new payment type
function calculateDiscount(type: string, amount: number): number {
  if (type === 'premium') return amount * 0.2;
  if (type === 'standard') return amount * 0.1;
  return 0; // Must edit this for new types
}

// ✅ Compliant: Open for extension via strategy pattern
interface DiscountStrategy { calculate(amount: number): number }

class PremiumDiscount implements DiscountStrategy {
  calculate(amount: number) { return amount * 0.2 }
}

class StandardDiscount implements DiscountStrategy {
  calculate(amount: number) { return amount * 0.1 }
}

// Add new discount types without modifying existing code
```

### L — Liskov Substitution Principle (LSP)

Subtypes must be substitutable for their base types without altering correctness.

**Code Smell:** Base class methods do nothing or throw "not implemented" in child classes. Type checks (`instanceof`) scattered in code.

**Signal:** "We need to check what type this is before calling methods."

**Example:**
```typescript
// ❌ Violation: Subtype changes behavior unexpectedly
class Bird { fly() { ... } }
class Penguin extends Bird { fly() { throw new Error('Cannot fly') } }

// If code calls fly() on Bird, it breaks for Penguin
// Must add type checks everywhere

// ✅ Compliant: Separate interfaces for different behaviors
interface FlyingBird { fly(): void }
interface SwimmingBird { swim(): void }

class Eagle implements FlyingBird { fly() { ... } }
class Penguin implements SwimmingBird { swim() { ... } }
```

### I — Interface Segregation Principle (ISP)

Prefer small, specific interfaces over large, general ones.

**Code Smell:** Classes implement interfaces with methods they don't use. "Fat" interfaces force unnecessary dependencies.

**Signal:** "I only need method X but I have to implement A, B, C, D, E."

**Example:**
```typescript
// ❌ Violation: Fat interface forces unnecessary implementation
interface Machine {
  print(): void
  scan(): void
  fax(): void
}

class SimplePrinter implements Machine {
  scan() { throw new Error('No scanner') }  // Unused
  fax() { throw new Error('No fax') }      // Unused
}

// ✅ Compliant: Small, focused interfaces
interface Printer { print(): void }
interface Scanner { scan(): void }

class SimplePrinter implements Printer {
  print() { ... }
}
```

### D — Dependency Inversion Principle (DIP)

High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Code Smell:** Direct instantiation (`new SomeConcreteClass`) scattered throughout. Changing database implementation breaks business logic.

**Signal:** "I can't test this because it calls real services."

**Example:**
```typescript
// ❌ Violation: High-level depends on low-level concrete
class OrderService {
  private db = new PostgreSQLDatabase() // Tightly coupled

  save(order: Order) {
    this.db.save(order) // Can't swap for mock in tests
  }
}

// ✅ Compliant: Depend on abstraction
interface Database {
  save(entity: any): void
}

class OrderService {
  constructor(private db: Database) {} // Injected

  save(order: Order) {
    this.db.save(order) // Works with any Database impl
  }
}

// In production: new OrderService(new PostgreSQLDatabase())
// In tests: new OrderService(new MockDatabase())
```

---

## GoF Design Patterns

Organized by category with usage signals and TypeScript examples.

### Creational Patterns

Object creation mechanisms that decouple creation from usage.

| Pattern | When to Use | Code Smell Signal |
|---------|-------------|-------------------|
| **Singleton** | Exactly one instance needed (config, logger, cache) | "We need the SAME instance everywhere" |
| **Factory Method** | Subclasses decide which class to instantiate | "Different contexts need different object types" |
| **Abstract Factory** | Families of related objects that must be used together | "These objects always come in a set" |
| **Builder** | Complex object construction with many optional params | "Constructor has 10 parameters, most optional" |
| **Prototype** | Objects are similar but have slight differences | "Cloning is easier than creating from scratch" |

#### Singleton

```typescript
// ✅ TypeScript implementation with DI compatibility
class ConfigService {
  private static instance: ConfigService
  private config: Record<string, any> = {}

  private constructor() {}

  static getInstance(): ConfigService {
    if (!ConfigService.instance) {
      ConfigService.instance = new ConfigService()
    }
    return ConfigService.instance
  }

  get(key: string) { return this.config[key] }
}

// Usage: ConfigService.getInstance().get('apiUrl')
// Can be replaced in tests via DI
```

#### Factory Method

```typescript
interface Notification {
  send(message: string): void
}

class EmailNotification implements Notification {
  send(message: string) { /* email logic */ }
}

class SMSNotification implements Notification {
  send(message: string) { /* SMS logic */ }
}

// Factory decides which to create based on type
function createNotification(type: 'email' | 'sms'): Notification {
  return type === 'email' 
    ? new EmailNotification() 
    : new SMSNotification()
}
```

#### Builder

```typescript
class User {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly email: string,
    public readonly role: string,
    public readonly phone?: string,
    public readonly address?: string
  ) {}
}

// ✅ Builder handles complex construction
class UserBuilder {
  private user: Partial<User> = {}

  setId(id: string) { this.user.id = id; return this }
  setName(name: string) { this.user.name = name; return this }
  setEmail(email: string) { this.user.email = email; return this }
  setRole(role: string) { this.user.role = role; return this }
  setPhone(phone: string) { this.user.phone = phone; return this }
  setAddress(address: string) { this.user.address = address; return this }

  build(): User {
    if (!this.user.id || !this.user.name || !this.user.email) {
      throw new Error('Required fields missing')
    }
    return new User(
      this.user.id,
      this.user.name,
      this.user.email,
      this.user.role,
      this.user.phone,
      this.user.address
    )
  }
}

const user = new UserBuilder()
  .setId('1')
  .setName('John')
  .setEmail('john@example.com')
  .setRole('admin')
  .setPhone('123-456')
  .build()
```

### Structural Patterns

How objects and classes compose into larger structures.

| Pattern | When to Use | Code Smell Signal |
|---------|-------------|-------------------|
| **Adapter** | Wrap existing interface to match expected interface | "This API doesn't match what I need" |
| **Bridge** | Separate abstraction from implementation | "Changes in implementation affect multiple clients" |
| **Composite** | Tree structures where individual and composite treated same | "Need to treat group and individual items the same" |
| **Decorator** | Add behavior dynamically without subclassing | "Need more features but can't modify class" |
| **Facade** | Simple interface to complex subsystem | "This system has too many steps to do X" |
| **Flyweight** | Many similar objects consume too much memory | "Creating thousands of similar objects" |
| **Proxy** | Control access to object | "Need to add logic before/after accessing this" |

#### Adapter

```typescript
// External API returns different shape
class ExternalUser {
  constructor(public user_id: string, public full_name: string) {}
}

// We expect this interface
interface User {
  id: string
  name: string
}

// ✅ Adapter converts between interfaces
class UserAdapter {
  static toUser(external: ExternalUser): User {
    return {
      id: external.user_id,
      name: external.full_name
    }
  }
}

const external = new ExternalUser('123', 'John Doe')
const user = UserAdapter.toUser(external)
```

#### Composite

```typescript
interface FileSystemItem {
  getSize(): number
  print(indent: string): void
}

class File implements FileSystemItem {
  constructor(public name: string, public size: number) {}
  getSize() { return this.size }
  print(indent: string) { console.log(`${indent}📄 ${this.name} (${this.size}KB)`) }
}

class Folder implements FileSystemItem {
  private children: FileSystemItem[] = []

  add(item: FileSystemItem) { this.children.push(item) }
  getSize() { return this.children.reduce((sum, c) => sum + c.getSize(), 0) }
  print(indent: string) {
    console.log(`${indent}📁 ${this.constructor.name}`)
    this.children.forEach(c => c.print(indent + '  '))
  }
}

// ✅ Treat individual files and folders the same way
const root = new Folder()
root.add(new File('a.txt', 100))
const sub = new Folder()
sub.add(new File('b.txt', 200))
root.add(sub)
root.getSize() // 300
```

#### Decorator

```typescript
interface Coffee {
  cost(): number
  description(): string
}

class SimpleCoffee implements Coffee {
  cost() { return 5 }
  description() { return 'Coffee' }
}

// ✅ Add features without subclassing
class MilkDecorator implements Coffee {
  constructor(private coffee: Coffee) {}
  cost() { return this.coffee.cost() + 1.5 }
  description() { return this.coffee.description() + ', Milk' }
}

class SugarDecorator implements Coffee {
  constructor(private coffee: Coffee) {}
  cost() { return this.coffee.cost() + 0.5 }
  description() { return this.coffee.description() + ', Sugar' }
}

let coffee = new SimpleCoffee()
coffee = new MilkDecorator(coffee)
coffee = new SugarDecorator(coffee)
coffee.description() // "Coffee, Milk, Sugar"
coffee.cost() // 7
```

### Behavioral Patterns

How objects communicate and distribute responsibility.

| Pattern | When to Use | Code Smell Signal |
|---------|-------------|-------------------|
| **Observer** | One-to-many dependency, notify when state changes | "When X changes, Y, Z, and W should update" |
| **Strategy** | Switch between algorithms at runtime | "Different situations need different algorithms" |
| **Command** | Encapsulate request as object, queue, or undo | "Need to log, undo, or replay operations" |
| **State** | Object behavior changes based on internal state | "Lots of if-else on internal state variable" |
| **Template Method** | Define skeleton, let subclasses fill steps | "Same algorithm, different implementation details" |
| **Chain of Responsibility** | Multiple handlers, first one handles wins | "Pass request to chain until someone handles it" |
| **Iterator** | Traverse collection without exposing internals | "Need to step through items one by one" |
| **Mediator** | Central point that coordinates object communication | "Components know too much about each other" |
| **Visitor** | Operations on elements of different types | "Need to add operation without changing element classes" |

#### Observer

```typescript
interface Observer {
  update(data: any): void
}

class Subject {
  private observers: Observer[] = []

  subscribe(observer: Observer) {
    this.observers.push(observer)
  }

  unsubscribe(observer: Observer) {
    this.observers = this.observers.filter(o => o !== observer)
  }

  notify(data: any) {
    this.observers.forEach(o => o.update(data))
  }
}

// Usage
class PriceDisplay implements Observer {
  update(price: number) { console.log(`Price: $${price}`) }
}

class PriceHistory implements Observer {
  update(price: number) { /* save to history */ }
}

const prices = new Subject()
prices.subscribe(new PriceDisplay())
prices.subscribe(new PriceHistory())
prices.notify(100) // Both observers update
```

#### Strategy

```typescript
interface SortStrategy {
  sort(data: number[]): number[]
}

class QuickSort implements SortStrategy {
  sort(data: number[]): number[] { /* quick sort impl */ }
}

class MergeSort implements SortStrategy {
  sort(data: number[]): number[] { /* merge sort impl */ }
}

class Sorter {
  constructor(private strategy: SortStrategy) {}

  sort(data: number[]) {
    return this.strategy.sort(data)
  }

  setStrategy(strategy: SortStrategy) {
    this.strategy = strategy // Change at runtime
  }
}
```

#### Command

```typescript
interface Command {
  execute(): void
  undo(): void
}

class AddCommand implements Command {
  constructor(private receiver: Receiver, private value: number) {}
  execute() { this.receiver.add(this.value) }
  undo() { this.receiver.subtract(this.value) }
}

class CommandManager {
  private history: Command[] = []

  execute(command: Command) {
    command.execute()
    this.history.push(command)
  }

  undo() {
    const cmd = this.history.pop()
    cmd?.undo()
  }
}

// ✅ Supports undo, logging, queuing
```

---

## Pattern Selection Decision Tree

Use this to find the right pattern:

```
Need to create objects?
├── Exactly one instance → Singleton
├── Complex construction → Builder
├── Family of related objects → Abstract Factory
├── Subclass decides type → Factory Method
└── Copy existing object → Prototype

Need to structure classes/objects?
├── Different interface needed → Adapter
├── Separate abstraction/implementation → Bridge
├── Tree of objects → Composite
├── Add behavior at runtime → Decorator
├── Simplify complex system → Facade
├── Share common state → Flyweight
└── Control access → Proxy

Need to manage behavior?
├── Notify dependents on change → Observer
├── Switch algorithms at runtime → Strategy
├── Encapsulate request → Command
├── Behavior based on state → State
├── Define skeleton, let others fill → Template Method
├── Chain of handlers → Chain of Responsibility
├── Traverse without exposing internals → Iterator
├── Central communication hub → Mediator
└── Add operations without changing classes → Visitor
```

---

## Anti-Patterns to Avoid

Named problems with symptoms and solutions.

| Anti-Pattern | Symptom | Solution |
|-------------|---------|----------|
| **God Object** | One class does everything | Apply SRP, split into focused classes |
| **Shotgun Surgery** | One change requires edits in many places | Move related behavior together |
| **Spaghetti Code** | Complex nested if-else, goto jumps | Refactor to linear flow, use patterns |
| **Magic Numbers** | Hardcoded numbers throughout code | Extract to named constants |
| **Feature Envy** | Class uses many methods of another class | Move the envy method to the target class |
| **Primitive Obsession** | Using primitives for domain concepts | Create value objects |
| **Data Clumps** | Same group of parameters repeated | Extract to parameter object |
| **Parallel Inheritance** | New subclass for each new subclass | Use composition |
| **Lazy Class** | Class does too little | Remove or merge |
| **Speculative Generality** | "Just in case" code | Implement when actually needed |

---

## Pattern Quick Reference: Framework Mapping

| GoF Pattern | Vue Usage | React Usage |
|-------------|-----------|-------------|
| Observer | `provide`/`inject`, Pinia store updates | `useEffect` subscriptions, Context |
| Strategy | `computed` with different algorithm implementations | Different handler functions passed as props |
| Factory | `createRouter`, `createStore` from Vue Router/Pinia | `createContext` providers |
| Composite | Recursive component tree (`FolderComponent`) | Recursive component for tree views |
| Decorator | `computed` wrapping base computed | HOC (Higher-Order Component) |
| Proxy | `reactive` with `get`/`set` traps | Custom hooks wrapping state access |
| Adapter | Wrapper composable for external API | Wrapper component for third-party lib |
| Command | Pinia actions (can be queued/undone) | useReducer with action objects |
| Singleton | Pinia store instance | React Context (single instance) |
| Facade | Composable simplifying complex subsystem | Custom hook wrapping complex logic |
