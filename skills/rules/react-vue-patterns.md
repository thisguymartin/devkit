---
name: react-vue-patterns
description: >
  Review React and Vue.js component code for hook/pattern usage quality and architectural patterns.
  For React: useEffect, useCallback, useMemo, React.memo.
  For Vue: watch, watchEffect, computed, composables, Pinia stores, and Repository pattern.
  Use this skill whenever the user asks to review, audit, critique, or improve React/Vue code,
  or when they paste a component and ask "is this right?", "can this be simplified?",
  "review my hooks", "check my watchers", "is this composable well designed?" or similar.
---

# React & Vue.js Pattern Review Skill

This skill reviews React and Vue.js code and provides a verdict for every hook, watcher, or composable usage. It catches the most common anti-patterns: unnecessary effects, gratuitous memoization, breaking reactivity, and violations of separation of concerns.

---

## Part 1: React Hooks Review

### Decision Framework

Read `references/hooks-guidance.md` for the full decision framework and before/after examples. If that file doesn't exist, apply the following decision tree.

### Step 1: Inventory every hook call

Scan the code and list every instance of:
- `useEffect`
- `useCallback`
- `useMemo`
- `React.memo`
- `useRef` (when used as a memoization workaround)

### Step 2: For each hook, apply the decision tree

#### useEffect

Ask these questions in order. Stop at the first "yes":

1. **Is this resetting state when a prop changes?**
   → Remove it. Use the `key` prop on the component to force a remount instead.

2. **Is this adjusting state derived from props?**
   → Remove it. Compute during render, or use `useRef` to track the previous value and set state conditionally during render.

3. **Is this running logic that belongs in an event handler?**
   → Remove it. Move the logic into the event handler itself, or extract to a custom hook that exposes an imperative function.

4. **Is this synchronizing with an external system (API, timer, subscription, DOM measurement)?**
   → **Justified.** Confirm it has proper cleanup. Check for the stale-closure/cancelled-request pattern in async effects.

5. **Is this a fire-and-forget side effect (analytics, logging)?**
   → **Justified.** Confirm it doesn't set state unnecessarily.

If none of the above apply, it's likely unnecessary. Explain why and suggest removal.

#### useCallback / useMemo

Ask:

1. **Is the memoized value passed to a `React.memo` component or used in another hook's dependency array?**
   - No → **Unjustified.** Remove the wrapper; it's adding complexity for no benefit.
   - Yes → Continue.

2. **Are any of its dependencies non-primitive props (functions, objects, arrays from the parent)?**
   - Yes → The memoization is fragile. Consider the ref pattern (store the prop in a ref, read from the ref inside a stable callback) or question whether the memo boundary is worth it.
   - No → **Justified.**

3. **For `useMemo` specifically: is the computation actually expensive?**
   - A simple `.map()` or `.filter()` on a small array is not expensive. Remove the wrapper.
   - DOM layout calculations, large dataset transformations, or crypto operations are expensive. Keep it.

#### React.memo

Ask:

1. **Does this component re-render frequently with the same props?** (Evidence: it's inside a list, or its parent re-renders on every keystroke, etc.)
   - No → Remove it. The overhead of shallow comparison isn't worth it.
   - Yes → Continue.

2. **Can all its props be kept referentially stable?** (No inline functions, no object/array literals in the parent.)
   - No → The memo boundary is broken. Fix the parent's prop stability first, or remove the memo.
   - Yes → **Justified.**

3. **Would component composition solve this instead?** (Splitting the frequently-updating part into its own component so the expensive part doesn't re-render.)
   - Yes → Prefer composition. It's simpler and doesn't require coordinating prop stability.

### Step 3: Present the review

For each hook call, give a one-line verdict:

- **✅ Justified** — explain briefly why (e.g., "syncs with a WebSocket subscription, has proper cleanup")
- **⚠️ Fragile** — it might work but is brittle (e.g., "memoization depends on an inline callback from the parent — will break on every render")
- **❌ Unjustified** — explain why and show the refactored alternative

After the per-hook verdicts, provide the refactored code if any changes were suggested. Keep the refactored version complete — don't just show snippets.

---

## Part 2: Vue.js Patterns Review

Vue.js patterns follow a different mental model than React. The emphasis is on **reactivity system integrity**, **composable extraction**, and **Pinia store architecture**.

### Step 1: Inventory Vue-specific patterns

Scan the code and list every instance of:
- `watch`, `watchEffect`
- `computed`
- `ref`, `reactive`
- `provide` / `inject`
- `defineProps`, `defineEmits`, `defineExpose`
- Composables (functions starting with `use`)
- Pinia store definitions (`defineStore`)
- Repository pattern implementations

### Step 2: Decision Tree for Vue Patterns

#### Computed vs Watch

1. **Is this deriving state from other reactive state?**
   → Use `computed()`. If you used `watch` or `watchEffect` to update a reactive variable, it's **❌ Unjustified**.
   
   ```typescript
   // ❌ Unjustified: Watcher for derived state
   const firstName = ref('')
   const lastName = ref('')
   const fullName = ref('')
   
   watch([firstName, lastName], () => {
     fullName.value = `${firstName.value} ${lastName.value}`
   }, { immediate: true })
   
   // ✅ Justified: Computed for derived state
   const fullName = computed(() => `${firstName.value} ${lastName.value}`)
   ```

2. **Is this side-effect logic (API calls, localStorage, DOM manipulation)?**
   → Use `watch` or `watchEffect`. This is **✅ Justified**.

   ```typescript
   // ✅ Justified: Side effect (saving to localStorage)
   const theme = ref('dark')
   
   watch(theme, (newTheme) => {
     localStorage.setItem('theme', newTheme)
     document.documentElement.setAttribute('data-theme', newTheme)
   })
   ```

#### Reactive Object Integrity

1. **Are you destructuring a `reactive` object?**
   → **❌ Unjustified** if you lose reactivity. Use `toRefs()` or keep the object intact.
   
   ```typescript
   // ❌ Unjustified: Destructuring breaks reactivity
   const user = reactive({ name: 'John', age: 30 })
   const { name, age } = user // name and age are plain values now
   
   // ✅ Justified: Using toRefs preserves reactivity
   const { name, age } = toRefs(user)
   ```

2. **Are you passing a reactive object to a composable that mutates it?**
   → Consider passing a getter/setter pair instead to maintain clear data flow.

#### Composables (The Vue Equivalent of Custom Hooks)

1. **Does this composable handle multiple responsibilities?**
   → **❌ Unjustified**. Split into smaller composables following SRP.
   
   ```typescript
   // ❌ Unjustified: Fat composable doing too much
   export function useUserProfile(userId: string) {
     // User data fetching
     // Profile editing
     // Activity logging
     // Settings management
   }
   
   // ✅ Justified: Separated concerns
   export function useUser(userId: string) { /* fetching */ }
   export function useUserProfileEditor(user: Ref<User>) { /* editing */ }
   export function useUserActivity(userId: string) { /* activity */ }
   ```

2. **Does this composable expose reactive state correctly?**
   → Return `ref`/`reactive` values, not raw objects. Ensure consumers can react to changes.

3. **Is this composable's state global or local?**
   → Use Pinia for global state. Use composables with `ref()` for local component state.

#### Pinia Store Patterns

1. **Is state duplicated across multiple stores?**
   → **⚠️ Fragile**. Merge into a single store or create a shared composable for cross-cutting concerns.

2. **Are you using the Setup Store syntax?**
   → Preferred for TypeScript and Composition API. Ensure all state is returned from the setup function.
   
   ```typescript
   // ✅ Justified: Setup Store syntax
   export const useUserStore = defineStore('user', () => {
     const user = ref<User | null>(null)
     const isLoading = ref(false)
     
     async function fetchUser(id: string) {
       isLoading.value = true
       user.value = await userApi.get(id)
       isLoading.value = false
     }
     
     return { user, isLoading, fetchUser }
   })
   ```

3. **Are actions properly typed?**
   → Ensure all actions return typed values or `void`. Use async/await for API calls.

#### Repository Pattern in Vue

Use the Repository pattern to abstract data access. This separates API logic from components and stores.

1. **Are API calls made directly in components?**
   → **❌ Unjustified**. Extract to a repository class or composable.
   
   ```typescript
   // ❌ Unjustified: API call in component
   async function loadUsers() {
     const response = await fetch('/api/users')
     users.value = await response.json()
   }
   
   // ✅ Justified: Repository pattern
   // repositories/userRepository.ts
   export class UserRepository {
     async getAll(): Promise<User[]> {
       const response = await fetch('/api/users')
       return response.json()
     }
     
     async getById(id: string): Promise<User> {
       const response = await fetch(`/api/users/${id}`)
       return response.json()
     }
   }
   
   // In store or composable
   const userRepo = new UserRepository()
   const users = await userRepo.getAll()
   ```

2. **Is the repository interface consistent?**
   → Define a base interface for CRUD operations. Extend for specific needs.

---

## Part 3: Enterprise Patterns

### Repository Pattern (Cross-Framework)

The Repository pattern creates an abstraction layer between data sources (APIs, databases) and the UI layer.

**When to use:**
- Multiple data sources (REST API, GraphQL, localStorage)
- Need for easy testing (mock repository)
- Complex query logic that shouldn't live in components

**Structure:**
```typescript
// Base repository interface
interface IRepository<T, TId> {
  getAll(): Promise<T[]>
  getById(id: TId): Promise<T | null>
  create(entity: Omit<T, 'id'>): Promise<T>
  update(id: TId, entity: Partial<T>): Promise<T>
  delete(id: TId): Promise<void>
}

// Concrete implementation
class UserRepository implements IRepository<User, string> {
  private apiClient: ApiClient
  
  constructor(apiClient: ApiClient) {
    this.apiClient = apiClient
  }
  
  async getAll(): Promise<User[]> {
    return this.apiClient.get('/users')
  }
  
  async getById(id: string): Promise<User | null> {
    return this.apiClient.get(`/users/${id}`)
  }
  
  async create(user: CreateUserDto): Promise<User> {
    return this.apiClient.post('/users', user)
  }
  
  async update(id: string, user: UpdateUserDto): Promise<User> {
    return this.apiClient.put(`/users/${id}`, user)
  }
  
  async delete(id: string): Promise<void> {
    return this.apiClient.delete(`/users/${id}`)
  }
}
```

**Integration with Pinia:**
```typescript
// stores/userStore.ts
export const useUserStore = defineStore('user', () => {
  const userRepo = new UserRepository(apiClient)
  
  async function loadUsers() {
    users.value = await userRepo.getAll()
  }
  
  return { users, loadUsers }
})
```

### Dependency Injection (DI) Pattern

For Vue, use Provide/Inject or a DI container for shared services.

```typescript
// Provide a repository instance at app root
import { provide, inject } from 'vue'

const UserRepositoryKey = Symbol('UserRepository')

// In main.ts or App.vue
provide(UserRepositoryKey, new UserRepository())

// In any component
const userRepo = inject<UserRepository>(UserRepositoryKey)
```

### Service Layer Pattern

Combine repositories into services for complex business logic.

```typescript
// services/userService.ts
export class UserService {
  constructor(
    private userRepo: UserRepository,
    private notificationService: NotificationService
  ) {}
  
  async activateUser(userId: string) {
    const user = await this.userRepo.getById(userId)
    if (!user) throw new Error('User not found')
    
    await this.userRepo.update(userId, { status: 'active' })
    await this.notificationService.send(user.email, 'Your account is now active')
  }
}
```

---

## Presentation Guidelines

### For React Reviews

For each hook call, provide:
- **✅ Justified** — Brief explanation with the valid use case
- **⚠️ Fragile** — Explanation of why it's brittle and what could break
- **❌ Unjustified** — Clear explanation + refactored code alternative

### For Vue Reviews

For each pattern, provide:
- **✅ Justified** — Explanation of why it follows Vue best practices
- **⚠️ Fragile** — Explanation of reactivity risks or maintenance concerns
- **❌ Unjustified** — Explanation + correct alternative using Vue idioms

### Refactoring Output

Provide complete, runnable refactored code. Don't show snippets — show the full component, composable, or store after refactoring.

### Tone

Be direct but not preachy. Frame suggestions as "here's a simpler way" rather than "this is wrong." When a pattern IS justified, say so clearly — the goal is to eliminate unnecessary complexity, not all patterns.