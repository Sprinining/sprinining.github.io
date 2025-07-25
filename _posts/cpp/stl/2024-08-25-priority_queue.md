---
title: priority_queue
date: 2024-08-25 04:29:31 +0800
categories: [cpp, stl]
tags: [CPP, CPP STL]
description: "priority_queue 是容器适配器，基于堆实现，按优先级访问元素，默认最大堆，常用于任务调度和图算法。"
---
## priority_queue

`std::priority_queue` 是 STL 提供的**容器适配器**，实现了一个**最大堆（默认）**或最小堆的数据结构，用于快速访问“优先级最高”的元素。

默认行为是：**堆顶元素最大（max heap）**。

### 底层原理

底层基于 **`vector` + `make_heap`/`push_heap`/`pop_heap` 算法**实现。

```cpp
template<
  class T,
  class Container = std::vector<T>,
  class Compare = std::less<typename Container::value_type>
> class priority_queue;
```

- 默认容器为 `vector<T>`。
- 默认比较器为 `std::less<T>` → 形成最大堆。
- 本质是对一个底层容器进行堆排序封装。

### 常用接口

| 函数         | 含义                         |
| ------------ | ---------------------------- |
| `push(x)`    | 插入元素，保持堆序性         |
| `pop()`      | 移除堆顶（优先级最高的元素） |
| `top()`      | 访问堆顶元素（不移除）       |
| `empty()`    | 是否为空                     |
| `size()`     | 当前元素个数                 |
| `emplace(x)` | 原地构造插入（C++11）        |

### 示例代码（最大堆）

```cpp
#include <queue>
#include <iostream>
using namespace std;

int main() {
    priority_queue<int> pq;

    pq.push(10);
    pq.push(5);
    pq.push(20);

    while (!pq.empty()) {
        cout << pq.top() << " ";  // 20 10 5
        pq.pop();
    }
}
```

### 自定义最小堆

使用 `std::greater<T>` 创建最小堆：

```cpp
priority_queue<int, vector<int>, greater<int>> minHeap;
```

### 自定义比较器

#### 函数指针（Function Pointer）

定义一个普通函数，实现两个元素比较逻辑，返回布尔值。

```cpp
bool cmp(int a, int b) {
    return a > b;  // 逆序
}

std::sort(vec.begin(), vec.end(), cmp);
```

- 简单直观，语法熟悉
- 适合轻量且不需要额外状态的比较逻辑
- 不能捕获外部状态（无闭包）
- 性能不如内联（函数调用开销）

#### 函数对象（仿函数 Functor）

定义一个重载了 `operator()` 的类或结构体。

```cpp
struct Cmp {
    bool operator()(int a, int b) const {
        return a > b;
    }
};

std::sort(vec.begin(), vec.end(), Cmp());
```

- 允许携带成员变量，实现带状态的比较器
- 可以内联，效率高于函数指针
- 在容器中作为模板参数时非常常用
- 语法比函数指针稍复杂

#### Lambda 表达式（C++11 及以上）

直接定义匿名函数，通常写在调用处。

```cpp
std::sort(vec.begin(), vec.end(), [](int a, int b) {
    return a > b;
});
```

- 简洁灵活
- 支持捕获外部变量，实现闭包
- 方便一次性使用，代码紧凑
- 不能作为类型直接传递（除非用 `auto` 或 `decltype`）
- 过度复杂的逻辑会影响可读性

#### 成员函数指针 + 绑定

不常用，一般借助 `std::bind` 或 `std::function` 绑定成员函数。

#### `std::function` 类型（类型擦除）

可以接收任何可调用对象，但有性能开销。

```cpp
std::function<bool(int, int)> cmp = [](int a, int b) { return a > b; };
std::sort(vec.begin(), vec.end(), cmp);
```

#### 详细示例对比

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
using namespace std;

// 函数指针
bool cmp_func(int a, int b) {
    return a > b;
}

// 仿函数
struct CmpFunctor {
    bool operator()(int a, int b) const {
        return a > b;
    }
};

int main() {
    vector<int> vec = {3, 1, 4, 1, 5};

    // 1. 函数指针
    sort(vec.begin(), vec.end(), cmp_func);
    for (int v : vec) cout << v << " ";  // 5 4 3 1 1
    cout << endl;

    // 2. 仿函数
    sort(vec.begin(), vec.end(), CmpFunctor());
    for (int v : vec) cout << v << " ";
    cout << endl;

    // 3. Lambda
    sort(vec.begin(), vec.end(), [](int a, int b) { return a > b; });
    for (int v : vec) cout << v << " ";
    cout << endl;

    // 4. std::function
    function<bool(int, int)> cmp_stdfunc = [](int a, int b) { return a > b; };
    sort(vec.begin(), vec.end(), cmp_stdfunc);
    for (int v : vec) cout << v << " ";
    cout << endl;

    return 0;
}
```

#### 带状态的比较器示例

```cpp
struct CmpWithThreshold {
    int threshold;
    CmpWithThreshold(int t) : threshold(t) {}

    bool operator()(int a, int b) const {
        if ((a < threshold) != (b < threshold))
            return a < threshold;  // 小于阈值排后面
        return a > b;             // 其他按降序
    }
};

int main() {
    vector<int> v = {1, 10, 5, 7, 3};
    sort(v.begin(), v.end(), CmpWithThreshold(6));
    for (auto x : v) cout << x << " ";
    // 输出：10 7 5 3 1
}
```

#### 总结

| 方法          | 是否支持状态 | 性能         | 语法简洁度 | 适用场景                 |
| ------------- | ------------ | ------------ | ---------- | ------------------------ |
| 函数指针      | 否           | 较差         | 简单       | 轻量无状态逻辑           |
| 仿函数        | 支持         | 好           | 中等       | 需要携带状态时首选       |
| Lambda        | 支持         | 好           | 非常简洁   | 快速定义，灵活捕获状态   |
| std::function | 支持         | 差（有开销） | 灵活       | 需要类型擦除，接口多样时 |

### 典型应用场景

- Dijkstra 最短路（存边权最小）
- Huffman 编码（合并最小频率节点）
- Top-K 问题（维护一个 K 大小的堆）
- 事件调度系统（按优先级处理任务）

### 示例：维护前 K 小的数（最小堆）

```cpp
priority_queue<int> maxHeap;
int k = 5;

for (int x : nums) {
    maxHeap.push(x);
    if (maxHeap.size() > k)
        maxHeap.pop();  // 始终保留 k 个最小元素
}
```

### 与其他容器对比

| 容器             | 行为模式   | 访问方式      | 支持遍历 | 底层结构      |
| ---------------- | ---------- | ------------- | -------- | ------------- |
| `stack`          | LIFO       | 只看顶        | ❌        | `deque`       |
| `queue`          | FIFO       | 看 front/back | ❌        | `deque`       |
| `priority_queue` | 优先级顺序 | 只看 top      | ❌        | `vector` + 堆 |

### 源码核心逻辑（简化）

```cpp
template <class T, class Container, class Compare>
class priority_queue {
protected:
    Container c;
    Compare comp;

public:
    void push(const T& x) {
        c.push_back(x);
        push_heap(c.begin(), c.end(), comp);  // 保持堆序
    }

    void pop() {
        pop_heap(c.begin(), c.end(), comp);  // 堆顶移到末尾
        c.pop_back();                        // 删除末尾元素
    }

    const T& top() const { return c.front(); }
};
```

### 常见问题

| 考点                        | 解答                                              |
| --------------------------- | ------------------------------------------------- |
| 如何实现最小堆？            | 使用 `greater<T>` 作为第三模板参数                |
| 默认堆是大顶还是小顶？      | 默认是**大顶堆**                                  |
| priority_queue 支持遍历吗？ | ❌ 不提供迭代器，不能遍历                          |
| 支持修改中间元素吗？        | ❌ 不直接支持。需要自写堆或用 `make_heap` 重新构造 |
| 如何实现 top-K 问题？       | 用一个大小为 K 的堆                               |

| 容器             | 比较器传入             | 表现                   |
| ---------------- | ---------------------- | ---------------------- |
| `std::sort`      | `a < b`                | 升序排序               |
| `priority_queue` | `std::less`（`a < b`） | 最大堆，弹出顺序是降序 |

### priority_queue 定义完整列表

`priority_queue` 是基于底层容器（默认是 `vector`）和 heap 规则实现的，因此源码非常简洁。它本质上只是包装了底层容器的一层接口，这种通过修改接口形成新功能的方式称为 **适配器（adapter）**，因此 `priority_queue` 被归类为 **容器适配器**，而不是普通容器。

```cpp
template <class T, class Sequence = vector<T>,
          class Compare = less<typename Sequence::value_type> >
class priority_queue {
public:
    typedef typename Sequence::value_type value_type;           // 元素类型
    typedef typename Sequence::size_type size_type;             // 容器大小类型
    typedef typename Sequence::reference reference;             // 元素引用类型
    typedef typename Sequence::const_reference const_reference; // 元素常量引用类型

protected:
    Sequence c;     // 底层容器，默认是 vector<T>
    Compare comp;   // 元素比较器，默认是 less，形成最大堆（最大值优先）

public:
    // 默认构造函数，创建空 priority_queue
    priority_queue() : c() {}

    // 指定比较器的构造函数，创建空 priority_queue 并设置比较器
    explicit priority_queue(const Compare& x) : c(), comp(x) {}

    // 通过区间 [first, last) 构造 priority_queue，并根据 comp 构建 heap
    template <class InputIterator>
    priority_queue(InputIterator first, InputIterator last, const Compare& x)
        : c(first, last), comp(x) {
        make_heap(c.begin(), c.end(), comp); // 生成堆结构
    }

    // 通过区间 [first, last) 构造 priority_queue，使用默认比较器 comp
    template <class InputIterator>
    priority_queue(InputIterator first, InputIterator last)
        : c(first, last) {
        make_heap(c.begin(), c.end(), comp); // 生成堆结构
    }

    // 判断是否为空
    bool empty() const { return c.empty(); }

    // 返回元素个数
    size_type size() const { return c.size(); }

    // 访问堆顶元素（优先级最高的元素）
    const_reference top() const { return c.front(); }

    // 插入元素
    void push(const value_type& x) {
        __STL_TRY {
            c.push_back(x);                      // 先将元素加到底层容器末尾
            push_heap(c.begin(), c.end(), comp);// 调用泛型算法调整堆（上溯）
        }
        __STL_UNWIND(c.clear()); // 异常处理：若发生异常，清空容器
    }

    // 弹出堆顶元素
    void pop() {
        __STL_TRY {
            pop_heap(c.begin(), c.end(), comp); // 调用泛型算法调整堆（下溯），最大元素移到末尾
            c.pop_back();                       // 弹出底层容器末尾元素（真正移除最大值）
        }
        __STL_UNWIND(c.clear()); // 异常处理：若发生异常，清空容器
    }
};
```

- 这里的 `typename` 是必须的，用来告诉编译器 `Sequence::value_type` 是一个类型，而不是静态成员或其他东西。
  - `Sequence` 是模板参数，编译器在模板解析阶段不知道 `Sequence::value_type` 是类型还是变量。
  - `typename` 关键字明确指出后面跟的是“类型”，这样编译器才会正确处理。
- `priority_queue` 是基于底层容器（默认 `vector`）和比较器实现的容器适配器；
- 构造时调用 `make_heap` 建堆，`push` 时调用 `push_heap` 上溯插入元素，`pop` 时调用 `pop_heap` 下溯调整堆并弹出元素；
- `top()` 返回堆顶元素，即优先级最高的元素；
- 异常安全处理通过 `__STL_TRY` 和 `__STL_UNWIND` 保证。

### priority_queue 沒有迭代器

priority_queue 中只有堆顶元素（权值最高）能被访问和取出，其他元素不能直接访问，也没有迭代器提供遍历功能。
