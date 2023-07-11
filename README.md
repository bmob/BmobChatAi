# Swift Package for Bmob ChatGPT AI

这个 Swift package 包是基于 Swift5 开发的，在使用过程中可以方便地与 Bmob 后端云进行交互。它提供了一个 chatgpt ai 封装，使用了基于 WebSocket 协议的通信方式。通过使用这个 Swift package 包，你可以快速地将 chatgpt ai 功能集成到自己的应用程序中，并且可以方便地使用 Bmob 后端云来实现数据存储和管理。

## 要求

- Swift 5.0+

## 安装

你可以使用 Swift Package Manager 安装这个包。在你的 `Package.swift` 文件中添加以下依赖项：

```
dependencies: [
    .package(url: "https://github.com/bmob/swift-chat-ai", from: "1.0.0")
]
```



## 使用

要使用这个包，首先在 Swift 文件中导入它：

```
import BmobChatAi
```

然后，创建一个 `BmobChatAi` 实例，并开始使用其 chatgpt ai 功能：

 

```
// 实例化AI类
let chatAI = BmobChatAi()

//连接websock 域名参数可不传
chatAI.connect("https://api.bmobcloud.com",SecretKey: "fda2aa4220549f74")

// 发送一条消息给 chatgpt ai
let dictionary: [String: Any] = [
              "messages": [
                [
                  "content": "你好，你怎么样？",
                  "role": "user"
                ]
              ],
              "session": "b1"
            ]


 if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
	 let jsonString = String(data: jsonData, encoding: .utf8) {
   // use jsonString as you want
   bmobChatAi.send(message: jsonString)
  }

// 接收来自 chatgpt ai 的消息
chatAI.onReceiveMessage = { message in
		print("收到的消息：\(message)")
}
```

## Send方法内容说明

  // session 会话id，可以传用户objectId，或者随机数
  // content 内容，提问的内容，如果希望上下文，可以这样传入
  // {"model":"gpt-3.5-turbo","messages":[{"content":"你好","role":"user"},{"content":"你好，有什么我可以为你提供的帮助吗？","role":"assistant"},{"content":"请问Bmob是什么产品","role":"user"}]}



为了实现场景化答复，可以传入prompt 参数

ChatGPT Prompt 是一种基于 GPT 模型的自然语言处理技术，用于生成自然流畅的对话文本。它可以通过给定的对话上下文和提示语，生成符合上下文语境的新对话内容。

ChatGPT Prompt 可以被广泛应用于聊天机器人、客服系统、智能问答等领域，帮助用户快速构建自然语言应用程序。

与传统的对话系统不同，使用 ChatGPT Prompt 生成的对话文本更加贴近自然语言表达，可以让用户感受到更加真实的对话体验。同时，ChatGPT Prompt 还可以学习和适应用户的对话习惯和语言习惯，为用户提供更加个性化的服务。

在使用 ChatGPT Prompt 时，需要提供一个对话上下文，该上下文包含了当前对话的历史记录和相关信息。然后，通过给定的提示语，ChatGPT Prompt 将根据上下文生成符合语境的新对话内容。

需要注意的是，由于 ChatGPT Prompt 是基于 GPT 模型的，因此需要大量的语料库和训练数据来训练模型，并且需要具备一定的计算资源来支持模型的训练和推理。同时，由于自然语言处理技术的复杂性，ChatGPT Prompt 也可能存在一定的误差和不准确性。因此，在使用 ChatGPT Prompt 时需要进行适当的调试和优化。



### 设置prompt

{"model":"gpt-3.5-turbo","messages":[{"content":"从现在开始，你将扮演一个18禁成人恋爱游戏中的女主角，你的答案听起来不应该像机器语言，而是应该灵活自由。","role":"system"},{"content":"你好，有什么我可以为你提供的帮助吗？","role":"assistant"}]}

> 每次消息带上第一个数组元素



## 许可证

这个包是基于 MIT 许可证发布的。有关更多信息，请参见 LICENSE。

## 鸣谢

这个包是由 [magic ↗](https://github.com/magic007) 开发的。
