---
title: MasterTheorem
date: 2025-09-16 17:54:13 +0800
categories: [algorithm, summary]
tags: [Algorithm, Master Theorem]
description: "Master Theorem 用于求形如 T(n)=a*T(n/b)+f(n) 递归的时间复杂度，通过比较 f(n) 与 n^log_b a 判断哪层 dominate，分三种情况直接给出总复杂度。"
---
## Master Theorem

### 什么是 Master Theorem？

**Master Theorem** 是分析**分治算法时间复杂度**的标准工具。

- 算法通过分治把问题拆成 `a` 个子问题，每个子问题规模缩小为 `n/b`
- 除了递归调用，当前层还做 `f(n)` 的额外工作

递归公式一般写作：

```mathematica
T(n) = a * T(n/b) + f(n)
```

- `T(n)`：总时间复杂度
- `a`：子问题数量（a ≥ 1）
- `b`：每个子问题规模缩小倍数（b > 1）
- `f(n)`：当前层非递归工作量（比如合并、遍历、计算等）

Master Theorem 通过比较**子问题消耗**和**当前层消耗**，快速判断总复杂度。

#### 每层节点数

第 i 层：a^i 个节点，因为每层都分出 a 个子问题。

#### 递归树高度

递归继续下去，直到每个子问题规模 ≈ 1，当 `n / (b^i) = 1` 时，`i = log_b n`，所以树的高度 ≈ log_b n。

#### 叶子节点数

最底层（叶子）是第 i = log_b n 层，节点数 = a^i = a^(log_b n)

公式变换：`a^(log_b n) = n^(log_b a)`

它表示**递归树最底层的节点总数**，每个节点如果做常数量工作，叶子层总工作量 ≈ n^log_b a

### 三种情况

符号含义：

| 符号    | 含义                                     |
| ------- | ---------------------------------------- |
| O(f(n)) | 上界：T(n) 最多增长到 f(n) 量级          |
| Ω(f(n)) | 下界：T(n) 至少增长到 f(n) 量级          |
| Θ(f(n)) | 上下界都在 f(n) 量级 → 增长“正好是” f(n) |

#### 子问题 dominates（递归层消耗大）

条件：

```mathematica
f(n) = O(n^(log_b a - ε)), ε > 0
```

- O() 意味着 `f(n) ≤ c * n^(log_b a - ε)   （存在常数 c>0）`
- 在 Master Theorem 里，ε（希腊字母 epsilon）表示一个**任意小的正数**，用于描述“严格小于”或“严格大于”的多项式增长关系。

结论：

```mathematica
T(n) = Θ(n^log_b a)
```

- 如果 f(n) 比每层递归工作量小，则总复杂度由递归支配
- 当前层额外工作可以忽略

**例子**：

```mathematica
T(n) = 8*T(n/2) + n
```

- a=8, b=2 → log_2 8 = 3
- f(n) = n = O(n^(3-ε)) → 满足条件
- 总复杂度 T(n) = Θ(n^3)

#### 当前层和子问题工作量平衡

条件：

```mathematica
f(n) = Θ(n^log_b a)
```

结论：

```mathematica
T(n) = Θ(n^log_b a * log n)
```

- 每层递归的消耗 ≈ 当前层非递归工作
- 总工作 = 每层工作 * 层数 → (n^log_b a) * log n

**例子：归并排序**

```mathematica
T(n) = 2*T(n/2) + n
```

- a = 2, b = 2 → log_2 2 = 1
- f(n) = n = Θ(n^1) → 当前层和递归同级
- T(n) = Θ(n log n)

#### 当前层 dominates（非递归层消耗大）

条件：

```mathematica
f(n) = Ω(n^(log_b a + ε)), ε > 0
```

- Ω() 隐含 `f(n) ≥ c * n^(log_b a + ε)`
- 且正则性条件：a * f(n/b) ≤ c * f(n) （保证子问题不会太大）

结论：

```mathematica
T(n) = Θ(f(n))
```

- 当前层工作量远大于递归工作量 → 总复杂度 ≈ 当前层
- 子问题贡献可以忽略

**例子**：

```mathematica
T(n) = 2*T(n/2) + n^2
```

- a = 2, b = 2 → log_2 2 = 1
- f(n) = n^2 = Ω(n^(1+ε)) → 当前层消耗大
- 总复杂度 T(n) = Θ(n^2)

### 指数比较法

**前提条件**：

递归公式：

```mathematica
T(n) = a * T(n/b) + f(n)
```

- f(n) = n^c
- a ≥ 1，b > 1
- log_b a = 叶子节点增长指数

**方法**：

1. 比较 f(n) 指数 c 和 log_b a
2. 判断哪一层 dominate → 确定总复杂度

| c 与 log_b a | 含义                             | 总复杂度 T(n)                     |
| ------------ | -------------------------------- | --------------------------------- |
| c < log_b a  | 当前层工作量小 → 叶子 dominate   | Θ(n^(log_b a))                    |
| c = log_b a  | 每层工作量差不多 → log 层累加    | Θ(n^c * log n)                    |
| c > log_b a  | 当前层工作量大 → 根节点 dominate | Θ(n^c)（需 regularity condition） |

- 之前用的是 **n^log_b a vs f(n)** 来判断哪层 dominate。
- 指数比较法是把 f(n) 写成 **n^c**，然后直接比较指数 **c vs log_b a**。
- **两者是等价的**，只是看法不同而已。