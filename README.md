# BasicServicesLib
iOS项目基础组件。包含了很多便捷方法和UI组件的扩展；包括简单得数据库设计和网络请求；支持关联性网络请求等等。
## 依赖库
- Using AFNetworking (3.2.1)
- Using FMDB (2.7.5)
- Using MBProgressHUD (1.1.0)

## Demo
项目下载下来后，使用Pod安装即可使用。
## 使用
> 
pod 'BasicServicesLib' 

## 项目功能
- 常用的宏定义  
在AppBase下的Macros.h文件中。主要包含了方法的简化和一些常用的预处理项目。
- 网络层  
在Networking下的所有文件。基于AFN的基础之上封装了网络请求，增加了请求池用于管理请求的生命周期。使用`URLSessionChainTask`支持关联性的网络请求。内部基于型号量实现了异步请求的同步效果。在网络层的封装中，将URL和Parameters抽成独立的类进行管理，有利于后期迭代优化和调试查错。
- 数据库  
在Database文件夹下。基于FMDB的二次封装，实现了简单得数据库设计（满足了我所使用的项目）。相对设计很简单，但是在存储时进行了AES的加密，取数据时进行解密，一定程度上增加了数据的安全性。
- 工具类  
	- 弹出框的工具类  
基于MBProgressHUD的封装。支持加载框、Toast、成功、失败的HUD。提供了简单得Api，实现了常用场景的所有需求。
	- 时间的工具类  
支持NSDate -> NSString、Timestamp -> NSString、NSString -> NSDate、NSString -> Timestamp常用转化。
	- 数字转化的工具类  
支持了数字转人民币、美元、千分位的转化。也支持数字转百分数的转化。
- UIKit组件扩展
	- UIPlaceholderTextView  
对UITextView的扩展，支持类占位符的显示及颜色。
	- UIRelayoutButton  
对UIButton布局的扩展，支持修改UIButton图片和Title的位置及间距。
	- PresentedHUDBasicViewController  
基于Modal方式的弹出控制器的基类。提供了弹出时自定义和弹入时自定义的方法。继承与该类的控制器可以实现类似于UIAlertController的效果。适用于大量的弹出界面。
	- NoDatasourceView  
对UIView的扩展，
- 延展  
常用的功能扩展，包括十六进制颜色、字符串加/解密、颜色转图片等一系列的积累工具。其中对字典的扩展使用与去模型化。通过路径组合，取到相应的值，而不再需要将字典转化成模型。