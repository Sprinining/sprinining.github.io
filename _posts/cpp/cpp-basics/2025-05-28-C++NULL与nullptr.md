---
title: C++NULL与nullptr
date: 2025-05-28 10:18:30 +0800
categories: [cpp, cpp basics]
tags: [CPP]
description: "NULL为宏定义0，类型不安全；nullptr为类型安全的空指针常量。"
---
## C++NULL与nullptr

在 C++ 中，`nullptr` 和 `NULL` 都表示空指针，但它们之间有一些关键区别，特别是在类型安全和现代 C++ 编程中的推荐使用方式上：

###   `nullptr`（C++11 引入）

- **类型：** `std::nullptr_t`，是一个专门用于表示空指针的类型。
- **类型安全：** 类型安全非常好，不会被误解为整数。
- **推荐使用：** 现代 C++（C++11 及以后）中，推荐使用 `nullptr`。

**示例：**

```cpp
void func(int);       // 重载1：接收int
void func(char*);     // 重载2：接收指针

func(nullptr); // 调用 func(char*)，类型清晰
```

### `NULL`

- **定义：** 通常被定义为 `0` 或 `((void*)0)`（依赖于编译器和平台）。
- **类型不明确：** 在 C++ 中是一个整数常量，可能导致函数重载歧义。
- **兼容性用途：** 多用于旧的 C/C++ 代码中。
- **不推荐：** 在 C++11 之后，应使用 `nullptr` 替代 `NULL`。

**示例（可能引起问题）：**

```cpp
void func(int);
void func(char*);

func(NULL); // 可能调用 func(int)，产生歧义
```

### 对比表

| 特性        | `nullptr`        | `NULL`            |
| ----------- | ---------------- | ----------------- |
| 类型        | `std::nullptr_t` | 通常是 `0`（int） |
| 类型安全    | ✅ 安全           | ❌ 可能不安全      |
| 推荐程度    | ✅ 推荐使用       | ❌ 避免使用        |
| C++版本需求 | C++11 及以上     | C++98/03 兼容     |
