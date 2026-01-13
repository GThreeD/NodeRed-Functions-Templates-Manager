# TypeScript Support for Node-RED Function Nodes

This project extends the **functions-templates-manager** to allow developing **Node-RED Function Nodes using TypeScript**.

Node-RED itself still executes **JavaScript**.

---

## Prerequisite (required)

You **must** install the TypeScript node for Node-RED:

https://flows.nodered.org/node/node-red-contrib-ts

This adds a new **TypeScript** node to the Node-RED palette.

---

## 1. Add a TypeScript node in Node-RED

1. Open Node-RED
2. Add a **TypeScript** node (from `node-red-contrib-ts`)
3. Give it a name (for example `CalculatePower`)
4. Deploy the flow

You must use the **TypeScript node**, not a normal Function node.

---

## 2. Optional: Add Global Definitions in Node-RED

Inside the TypeScript node, you may already define global types:

```ts
// Global Definition
interface BaseMsg {
  payload: unknown;
  topic?: string;
}
// Global Definition End

return msg;
```

These markers are used for extraction.  
Editing is done later in VS Code.

---

## 3. Extract Node-RED flows to files


After deploying it creates:

```text
src/
 ├─ MyFlow/
 │   └─ CalculatePower.ts
 └─ __global__/
     └─ types.ts
```

- `CalculatePower.ts` contains the editable TypeScript logic  
- `__global__/types.ts` contains shared global type definitions  

---

## 4. TypeScript file pattern (important)

The expected structure of a `.ts` file is:

```ts
// Local Definition
<local definitions>
<like
// @param msg: SomeType
>
// Local Definition End

export default function FunctionName(msg: SomeType) {
    <code>
}
```

Rules:

- `export default function` is mandatory
- Arrow functions are not supported

---

## 5. Local Definition

Example:

```ts
// Local Definition
interface PowerMsg {
  voltage: number;
  current: number;
  payload?: number;
}
// Local Definition End
```

Behavior:

- Applies only to this function
- Removed from the function body during collect
- Written back into Node-RED as `// Local Definition`
- Never written to `__global__/types.ts`

---

## 6. Global Definition

Global types are stored in:

```text
src/__global__/types.ts
```

Example:

```ts
interface BaseMsg {
  payload: unknown;
  topic?: string;
}

type NodeId = string;
```

Behavior:

During **collect**:
```ts
// Global Definition
<global types>
// Global Definition End
```

During **extract**:
- Removed from nodes
- Written back to `__global__/types.ts`

Define once, use everywhere.

---

## 7. @param – typing the msg parameter

Syntax:

```ts
// @param msg: PowerMsg
```

Result:

```ts
export default function MyFunction(msg: PowerMsg) {
```

If `@param` is missing:

```ts
msg: any
```

Is used to overwrite the default during extraction

---

## 8. What Node-RED actually stores

```js
// Global Definition
<global types>
// Global Definition End

// Local Definition
<local types>
// Local Definition End

<plain JavaScript function body>
```
