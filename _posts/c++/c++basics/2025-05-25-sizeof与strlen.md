---
title: sizeof与strlen
date: 2025-05-25 23:32:20 +0800
categories: [c++, c++ basics]
tags: [C++]
description: 
---
## sizeof与strlen

### `sizeof`：**编译时操作符**

#### 作用：

用于获取类型或对象在**内存中所占的字节数**。

#### 用法：

```cpp
sizeof(类型名)    // 获取某个类型的字节大小
sizeof(变量名)    // 获取某个对象（变量、数组等）的大小
```

#### 特点：

- 是 **编译时决定** 的操作，结果是一个 `constexpr`。
- 返回值类型是 `size_t`。
- 与内容无关，仅与 **类型定义** 或 **数组大小** 有关。

#### 示例：

```cpp
#include <iostream>
using namespace std;

int main() {
    int x = 10;
    char str1[] = "hello";
    char* str2 = "hello";

    struct MyStruct {
        char a;   // 1 字节
        int b;    // 4 字节
        char c;   // 1 字节
    };

    MyStruct s;

    cout << "sizeof(x) = " << sizeof(x) << endl;           // 输出 4
    cout << "sizeof(str1) = " << sizeof(str1) << endl;     // 输出 6
    cout << "sizeof(str2) = " << sizeof(str2) << endl;     // 输出 8（在64位系统中）
    cout << "sizeof(MyStruct) = " << sizeof(MyStruct) << endl; // 输出 12（字节对齐）
}
```

结构体 `MyStruct` 的内存布局分析：

```cpp
struct MyStruct {
    char a;   // 占 1 字节，偏移 0
    padding   // 3 字节，对齐 int 到 4 字节边界
    int b;    // 占 4 字节，偏移 4
    char c;   // 占 1 字节，偏移 8
    padding   // 3 字节，使结构体总大小为 12（对齐到最大对齐单位）
};
```

总大小：

```txt
1 + 3（padding）+ 4 + 1 + 3（padding）= 12 字节
```

如果改为：

```cpp
struct MyStruct2 {
    int b;
    char a;
    char c;
};
```

此时：

- `b` 在偏移 0，占 4 字节；
- `a` 和 `c` 紧跟其后，占 1+1；
- padding 2 字节，使结构体对齐到 `4` 字节边界。

```cpp
sizeof(MyStruct2) == 8
```

### `strlen`：**运行时函数**

#### 作用：

用于计算 C 风格字符串的**实际长度**（不包括 `\0` 终止符）。

#### 用法：

```cpp
strlen(const char* str);  // 参数必须是以'\0'结尾的C字符串
```

#### 特点：

- 是运行时函数，遍历字符串直到遇到 `\0`。
- 返回值类型也是 `size_t`。
- 与内存大小无关，只与字符串的内容有关。
- 需要包含头文件：`#include <cstring>`

#### 示例：

```cpp
char str1[] = "hello";      // 长度是5，实际占6字节（包含'\0'）
char* str2 = "hello";

std::cout << strlen(str1);  // 输出5
std::cout << strlen(str2);  // 输出5
```

### 对比表格

| 项目          | `sizeof`               | `strlen`                          |
| ------------- | ---------------------- | --------------------------------- |
| 类型          | 编译时操作符           | 运行时函数                        |
| 返回值类型    | `size_t`               | `size_t`                          |
| 所测内容      | 类型或对象的**字节数** | 字符串的**实际长度（不含 '\0'）** |
| 与内容相关性  | 无关                   | 有关                              |
| 是否遍历内存  | 否                     | 是                                |
| 是否包含 `\0` | 包含（数组中）         | 不包含                            |
| 常用场景      | 内存分配、结构体计算   | 字符串处理                        |

### 易错点

| 错误思维                     | 正确理解                           |
| ---------------------------- | ---------------------------------- |
| `sizeof(str)` 就是字符串长度 | 错 ❌，可能只是指针大小（8 字节）   |
| `strlen` 可以用于任意类型    | 错 ❌，只能用于 `\0` 结尾的 `char*` |
| `sizeof` 返回的是元素个数    | 错 ❌，它返回的是**字节数**         |

> 例如：`sizeof(arr) / sizeof(arr[0])` 才是数组长度（元素个数）

