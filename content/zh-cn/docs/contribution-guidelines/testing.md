---
title: 测试 Drycc
linkTitle: 测试
description: 每个 Drycc 组件都是这样一个生态系统中的一员 - 其中许多组件相互集成 - 这使得彻底测试每个组件成为至关重要的事情。
weight: 4
---

每个 Drycc 组件都包含自己的风格检查套件、[单元测试][] 和黑盒类型的 [功能测试][]。

[集成测试][] 验证 Drycc 组件作为一个系统的行为，并由 [drycc/workflow-e2e][workflow-e2e] 项目单独提供。

所有 Drycc 组件的 GitHub 拉取请求都由 [Travis CI][travis] [持续集成][] 系统自动测试。贡献者在提议对 Drycc 代码库进行任何更改之前，应该在本地运行相同的测试。

## 设置环境

成功执行任何 Drycc 组件的单元测试和功能测试需要首先设置 [开发环境][dev-environment]。

## 运行测试

每个组件的风格检查、单元测试和功能测试都可以通过 make 目标执行：

要执行风格检查：

```
$ make test-style
```

要执行单元测试：

```
$ make test-unit
```

要执行功能测试：

```
$ make test-functional
```

要一次性执行风格检查、单元测试和功能测试：

```
$ make test
```

要执行集成测试，请参考 [drycc/workflow-e2e][workflow-e2e] 文档。

[unit tests]: http://en.wikipedia.org/wiki/Unit_testing
[functional tests]: http://en.wikipedia.org/wiki/Functional_testing
[integration tests]: http://en.wikipedia.org/wiki/Integration_testing
[workflow-e2e]: https://github.com/drycc/workflow-e2e
[travis]: https://travis-ci.org/drycc
[continuous integration]: http://en.wikipedia.org/wiki/Continuous_integration
[dev-environment]: development-environment.md
