---
title: 提交拉取请求
linkTitle: 提交拉取请求
description: 对 Drycc 项目的提议更改通过 GitHub 拉取请求进行。
weight: 5
---

## 设计文档

在打开拉取请求之前，如果贡献是实质性的，请确保您的更改也引用了设计文档。有关更多信息，请参阅 [Design Documents](design-documents.md)。

## 单一问题

当拉取请求不聚焦时，很难就其优点达成一致。在修复问题或实现新功能时，抵制重构附近代码或修复您注意到的潜在 bug 的诱惑。相反，打开单独的问题或拉取请求。将关注点分开允许拉取请求更快地被测试、审查和合并。

使用 `git` 将拉取请求中的提交或提交压缩并变基为逻辑工作单元。在同一提交中包含测试和文档更改，以便恢复会删除该功能或修复的所有痕迹。

大多数拉取请求将引用 GitHub 问题。在 PR 描述中 - 而不是在提交本身中 - 包含一行如 "closes #1234"。当您的 PR 被合并时，引用的 issue 将自动关闭。


## 包含测试

如果您显著更改或添加影响更广泛的 Drycc Workflow PaaS 的组件功能，您应该提交补充 PR 来修改或修改端到端集成测试。这些集成测试可以在 [drycc/workflow-e2e][workflow-e2e] 仓库中找到。

有关更多信息，请参阅 [testing](testing.md)。


## 包含文档

对任何可能影响用户体验的 Drycc Workflow 组件的更改也需要更改或添加到相关文档。对于大多数 Drycc 组件，这涉及更新组件自己的文档。在某些情况下，当组件紧密集成到 [drycc/workflow][workflow] 中时，其文档也必须更新。

## 跨仓库提交

如果拉取请求是涉及其他 Workflow 仓库中的一个或多个额外提交的更大工作的部分，则这些提交可以在最后提交的 PR 中引用。下游 [e2e 测试作业](https://ci.drycc.info/job/workflow-e2e-pr/) 将为测试运行器提供每个引用的提交（从提供的 PR issue 编号派生），以便它可以为要测试的生成的 Workflow chart 包含必要的容器镜像。

例如，考虑在 [drycc/controller](https://github.com/drycc/controller) 和 [drycc/workflow-e2e](https://github.com/drycc/workflow-e2e) 中的配对提交。`drycc/workflow-e2e` 中第一个 PR 的提交主体将如下所示：

```
feat(foo_test): add e2e test for feature foo

[skip e2e] test for controller#42
```
为这个提交添加 `[skip e2e]` 会放弃 e2e 测试。除了最终 PR 之外的任何其他必需 PR 应该首先提交，以便它们的相应构建和镜像推送作业运行。

最后，应该使用所需的 PR 编号创建 `drycc/controller` 中的最终 PR，以 `[Rr]equires <repoName>#<pullRequestNumber>` 的形式列出，以供下游 e2e 运行使用。

```
feat(foo): add feature foo

Requires workflow-e2e#42
```

## 代码标准

Drycc 组件使用 [Go][] 和 [Python][] 实现。对于两种语言，我们同意 [The Zen of Python][zen]，它强调简单胜过聪明。可读性很重要。

Go 代码应该始终使用默认设置通过 `gofmt` 运行。代码行最多可以长达 99 个字符。所有导出的函数都需要文档字符串和测试。第三方 go 包的使用应该最小化，但这样做时，此类依赖应该通过 [glide][] 工具管理。

Python 代码应该始终遵守 [PEP8][]，Python 代码风格指南，但例外是代码行最多可以长达 99 个字符。所有公共方法都需要文档字符串和测试，尽管 Drycc 使用的 [flake8][] 工具不强制执行此项。

## 提交风格

我们遵循从 CoreOS 借来的提交消息约定，他们从 AngularJS 借来的。这是提交的示例：

```
feat(scripts/test-cluster): add a cluster test command

this uses tmux to setup a test cluster that you can easily kill and
start for debugging.
```

要使其更正式，它看起来像这样：

```
{type}({scope}): {subject}
<BLANK LINE>
{body}
<BLANK LINE>
{footer}
```

允许的 `{types}` 如下：

* `feat` -> 功能
* `fix` -> bug 修复
* `docs` -> 文档
* `style` -> 格式化
* `ref` -> 重构代码
* `test` -> 添加缺失的测试
* `chore` -> 维护

`{scope}` 可以是指定提交更改位置的任何内容。

`{subject}` 需要是祈使式、现在时动词："change"，而不是 "changed" 也不是 "changes"。第一个字母不应大写，并且末尾没有点 (.)。

就像 `{subject}` 一样，消息 `{body}` 需要是现在时，包括更改的动机，以及与之前行为的对比。段落中的第一个字母必须大写。

所有破坏性更改需要在 `{footer}` 中提及，更改的描述、更改背后的理由以及所需的任何迁移说明。

提交消息的任何行都不能超过 72 个字符，主题行限制为 50 个字符。这允许消息在 GitHub 以及各种 git 工具中更容易阅读。

## 合并批准

任何代码更改 - 除了简单的拼写错误修复或单行文档更改 - 需要至少两个 [Drycc 维护者][maintainers] 接受它。维护者使用 "**LGTM1**" 和 "**LGTM2**"（Looks Good To Me）标签标记拉取请求以表示接受。

在至少一个核心维护者以 LGTM 签字之前，不能合并任何拉取请求。另一个 LGTM 可以来自核心维护者或贡献维护者。

如果 PR 来自 Drycc 维护者，那么他或她应该是关闭它的人。这保持了提交流的清洁，并让维护者在决定是否合并更改之前重新审视 PR。

一个例外是当需要紧急恢复错误提交时。如果必要，仅恢复先前提交的 PR 可以不等待 LGTM 批准而合并。

[go]: http://golang.org/
[glide]: https://github.com/Masterminds/glide
[flake8]: https://pypi.python.org/pypi/flake8/
[maintainers]: maintainers.md
[pep8]: http://www.python.org/dev/peps/pep-0008/
[python]: http://www.python.org/
[zen]: http://www.python.org/dev/peps/pep-0020/
[workflow]: https://github.com/drycc/workflow
[workflow-e2e]: https://github.com/drycc/workflow-e2e

## Design Document

Before opening a pull request, ensure your change also references a design document if the contribution is substantial. For more information, see [Design Documents](design-documents.md).

## Single Issue

It's hard to reach agreement on the merit of a PR when it isn't focused. When fixing an issue or implementing a new feature, resist the temptation to refactor nearby code or to fix that potential bug you noticed. Instead, open a separate issue or pull request. Keeping concerns separated allows pull requests to be tested, reviewed, and merged more quickly.

Squash and rebase the commit or commits in your pull request into logical units of work with `git`. Include tests and documentation changes in the same commit, so that a revert would remove all traces of the feature or fix.

Most pull requests will reference a GitHub issue. In the PR description - not in the commit itself - include a line such as "closes #1234". The issue referenced will automatically be closed when your PR is merged.


## Include Tests

If you significantly alter or add functionality to a component that impacts the broader Drycc Workflow PaaS, you should submit a complementary PR to modify or amend end-to-end integration tests.  These integration tests can be found in the [drycc/workflow-e2e][workflow-e2e] repository.

See [testing](testing.md) for more information.


## Include Docs

Changes to any Drycc Workflow component that could affect a user's experience also require a change or addition to the relevant documentation. For most Drycc components, this involves updating the component's _own_ documentation. In some cases where a component is tightly integrated into [drycc/workflow][workflow], its documentation must also be updated.

## Cross-repo commits

If a pull request is part of a larger piece of work involving one or more additional commits in other Workflow repositories, these commits can be referenced in the last PR to be submitted.  The downstream [e2e test job](https://ci.drycc.info/job/workflow-e2e-pr/) will then supply every referenced commit (derived from PR issue number supplied) to the test runner so it can source the necessary Container images for inclusion in the generated Workflow chart to be tested.

For example, consider paired commits in [drycc/controller](https://github.com/drycc/controller) and [drycc/workflow-e2e](https://github.com/drycc/workflow-e2e).  The commit body for the first PR in `drycc/workflow-e2e` would look like:

```
feat(foo_test): add e2e test for feature foo

[skip e2e] test for controller#42
```
Adding `[skip e2e]` forgoes the e2e tests on this commit. This and any other required PRs aside from the final PR should be submitted first, so that their respective build and image push jobs run.

Lastly, the final PR in `drycc/controller` should be created with the required PR number(s) listed, in the form of `[Rr]equires <repoName>#<pullRequestNumber>`, for use by the downstream e2e run.

```
feat(foo): add feature foo

Requires workflow-e2e#42
```

## Code Standards

Drycc components are implemented in [Go][] and [Python][]. For both languages, we agree with [The Zen of Python][zen], which emphasizes simple over clever. Readability counts.

Go code should always be run through `gofmt` on the default settings. Lines of code may be up to 99 characters long. Documentation strings and tests are required for all exported functions. Use of third-party go packages should be minimal, but when doing so, such dependencies should be managed via the [glide][] tool.

Python code should always adhere to [PEP8][], the python code style guide, with the exception that lines of code may be up to 99 characters long. Docstrings and tests are required for all public methods, although the [flake8][] tool used by Drycc does not enforce this.

## Commit Style

We follow a convention for commit messages borrowed from CoreOS, who borrowed theirs
from AngularJS. This is an example of a commit:

```
feat(scripts/test-cluster): add a cluster test command

this uses tmux to setup a test cluster that you can easily kill and
start for debugging.
```

To make it more formal, it looks something like this:

```
{type}({scope}): {subject}
<BLANK LINE>
{body}
<BLANK LINE>
{footer}
```

The allowed `{types}` are as follows:

* `feat` -> feature
* `fix` -> bug fix
* `docs` -> documentation
* `style` -> formatting
* `ref` -> refactoring code
* `test` -> adding missing tests
* `chore` -> maintenance

The `{scope}` can be anything specifying the location(s) of the commit change(s).

The `{subject}` needs to be an imperative, present tense verb: “change”, not “changed” nor
“changes”. The first letter should not be capitalized, and there is no dot (.) at the end.

Just like the `{subject}`, the message `{body}` needs to be in the present tense, and includes
the motivation for the change, as well as a contrast with the previous behavior. The first
letter in a paragraph must be capitalized.

All breaking changes need to be mentioned in the `{footer}` with the description of the
change, the justification behind the change and any migration notes required.

Any line of the commit message cannot be longer than 72 characters, with the subject line
limited to 50 characters. This allows the message to be easier to read on GitHub as well
as in various git tools.

## Merge Approval

Any code change - other than a simple typo fix or one-line documentation change - requires at least two [Drycc maintainers][maintainers] to accept it.  Maintainers tag pull requests with "**LGTM1**" and "**LGTM2**" (Looks Good To Me) labels to indicate acceptance.

No pull requests can be merged until at least one core maintainer signs off with an LGTM. The other LGTM can come from either a core maintainer or contributing maintainer.

If the PR is from a Drycc maintainer, then he or she should be the one to close it. This keeps the commit stream clean and gives the maintainer the benefit of revisiting the PR before deciding whether or not to merge the changes.

An exception to this is when an errant commit needs to be reverted urgently. If necessary, a PR that only reverts a previous commit can be merged without waiting for LGTM approval.

[go]: http://golang.org/
[glide]: https://github.com/Masterminds/glide
[flake8]: https://pypi.python.org/pypi/flake8/
[maintainers]: maintainers.md
[pep8]: http://www.python.org/dev/peps/pep-0008/
[python]: http://www.python.org/
[zen]: http://www.python.org/dev/peps/pep-0020/
[workflow]: https://github.com/drycc/workflow
[workflow-e2e]: https://github.com/drycc/workflow-e2e
