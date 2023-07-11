import Starscream
import Foundation

public class BmobChatAi: WebSocketDelegate {
    
    public init(){
        print("loadin WebSocketManager")
       
    }
    
    var socket: WebSocket?
    
    var urls:String!
    
    // 添加一个接收到 WebSocket 文本消息的闭包属性
    public var onReceiveMessage: ((String) -> Void)?
    
    // 添加一个错误处理的闭包属性
    public var onError: ((Error) -> Void)?
    
    
    var isConnected = false
    
  
    
    public func connect(_ to:String = "",SecretKey:String) {
        urls = to
        if to == ""{
            urls = "http://api.bmobcloud.com"
        }
        urls = urls.replacingOccurrences(of: "http", with: "ws")
        urls = urls+"/1/ai/"+SecretKey
        
        
        if let url = URL(string: urls) {
            
            var request = URLRequest(url: url);
            let pinner = FoundationSecurity(allowSelfSigned: true) // don't validate SSL certificates
            request.timeoutInterval = 5
            socket = WebSocket(request: request, certPinner: pinner)
            
            socket?.delegate = self
            
            socket?.connect()
            print(url)
            
        }else {
            onError?(WebSocketError.invalidURL)
        }
    }
    public func send(message: String) {
        guard let socket = socket else {
            onError?(WebSocketError.socketNotConnected)
            return
        }
        print(message)
        socket.write(string: message)
    }
    
    public func disconnect() {
        guard let socket = socket else {
            onError?(WebSocketError.socketNotConnected)
            return
        }
        
        socket.disconnect()
    }
    
    // WebSocketDelegate methods
    public func websocketDidConnect(socket: WebSocketClient) {
        // WebSocket 连接成功
        print("WebSocket 连接成功")
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        // WebSocket 断开连接
        if let error = error {
            print("WebSocket 断开连接：\(error)")
            onError?(error)
        } else {
            print("WebSocket 主动断开连接")
        }
    }
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
//        print("hhhhhh\(event)")
        
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let message):
            print("Received text: \(message)")
            var result:String
            // 将 JSON 数据转换为字典类型
            if let jsonData = message.data(using: .utf8),
               let dict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
               let choices = dict["choices"] as? [[String: Any]],
               let finish_reason = choices.first?["finish_reason"] as? String,
               let delta = choices.first?["delta"] as? [String: Any],
               let content = delta["content"] as? String {
                // 打印 content 字段的值
//                print(content)
                result = content
                if finish_reason == "stop" {
                    result = "done"
                }
            } else {
                // 解析 JSON 失败
                print("解析 JSON 失败")
                result = "解析 JSON 失败"
            }
            DispatchQueue.main.async {
                // 调用 onReceiveMessage 闭包属性
                self.onReceiveMessage?(result)
               
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            print("got an error: \(error)")
            isConnected = false
            handleError(error)
            onError?(WebSocketError.socketNotConnected)
            
        }
    }
    
    // Public method to expose didReceive method
    public func process(event: WebSocketEvent, client: WebSocket) {
        didReceive(event: event, client: client)
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}

// 添加一个WebSocketError枚举，用于标识WebSocket连接错误
public enum WebSocketError: Error {
    case invalidURL
    case socketNotConnected
}
