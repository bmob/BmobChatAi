import XCTest
import Starscream
@testable import swift_chat_ai
 
var bmobChatAi = BmobChatAi()

final class swift_chat_aiTests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        bmobChatAi.connect("https://api.bmobcloud.com",SecretKey: "fda2aa4220549f74")
        
 
        
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print("进入测试")
       
        
        XCTAssertEqual("Hello, World!", "Hello, World!")
        
        
        
    }
    func testbmobChatAi() {
        let expectation = XCTestExpectation(description: "等待异步操作完成")
        
        print("xxx")
        XCTAssertEqual("Hello, World!", "Hello, World!")
        print("xxx222")
        
        
        bmobChatAi.onReceiveMessage = { message in
            print("接收到 WebSocket 文本消息：\(message)")
            // 在这里进行接收到 WebSocket 文本消息后的处理
            
            // 完成期望
//            expectation.fulfill()
        }
        
        bmobChatAi.onError = { error in
            print("WebSocket 出现错误：\(error.localizedDescription)")
            // 完成期望
//            expectation.fulfill()
        }
        
//        bmobChatAi.setPrompt(message: "用女性的形象回应")
        
        // 异步操作
        DispatchQueue.global().async {
            // 模拟异步操作需要 2 秒钟的时间
            sleep(1)
            
            print("进入测试333")
            // 在这里编写需要延时执行的代码块
//            bmobChatAi.send(message: "ping")
//            let data = {"messages":[{"content":"hi","role":"user"}],"session":"b1"}
            
            let dictionary: [String: Any] = [
              "messages": [
                [
                  "content": "hi",
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
            
            
        }
        
        
  
        // 等待期望完成
        wait(for: [expectation], timeout: 10.0)
        
        expectation.fulfill()
    }
    
    
}
