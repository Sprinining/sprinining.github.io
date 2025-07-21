---
# the default layout is 'page'
icon: fas fa-info-circle
order: 4
---

```cpp
#include <iostream>
#include <string>

class Learner {
public:
    void learn(const std::string& concept) {
        std::cout << "What is " << concept << "?" << std::endl;
        std::cout << "Why is it important?" << std::endl;
        std::cout << "Why should I learn it?" << std::endl;
        std::cout << "When will I use it?" << std::endl;
        std::cout << "How does it work?" << std::endl;
        std::cout << std::endl;
    }
};
```
