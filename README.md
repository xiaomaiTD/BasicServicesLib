

# BasicServicesLib

iOS项目基础组件。包含了很多便捷方法和UI组件的扩展；包括简单得数据库设计和网络请求；支持关联性网络请求等等。

## 依赖库

- Using AFNetworking (3.2.1)

- Using FMDB (2.7.5)

- Using MBProgressHUD (1.1.0)

## Demo

项目下载下来后，使用Pod安装即可使用。

## 使用

>pod 'BasicServicesLib' 

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

- 常用组件扩展

  - UIPlaceholderTextView

    对UITextView的扩展，支持类占位符的显示及颜色。

  - UIRelayoutButton

    对UIButton布局的扩展，支持修改UIButton图片和Title的位置及间距。

  - PresentedHUDBasicViewController

    基于Modal方式的弹出控制器的基类。提供了弹出时自定义和弹入时自定义的方法。继承与该类的控制器可以实现类似于UIAlertController的效果。适用于大量的弹出界面。

  - NoDatasourceView

    对UIView的扩展，支持无数据时的占位视图。

- 延展

  常用的功能扩展，包括十六进制颜色、字符串加/解密、颜色转图片等一系列的积累工具。其中对字典的扩展使用与去模型化。通过路径组合，取到相应的值，而不再需要将字典转化成模型。

## 部分用例

- 关联性的网络请求

  ~~例如登录时，我们的逻辑是先用账号密码获取token值，再用token值获取ticket值，ticket和token都将作为后续网络请求的参数存入到header中。通常这种网络请求都会存在block嵌套的操作。由于block嵌套存在各种弊端，这里我将AFN利用型号量实现了异步任务的同步操作。使用如下:  

  ~~```objective-c
  ~~[URLSessionTaskResponse setResponseSuccessCode:200 forKeyAddition:@"code"];
  ~~[URLSessionTaskResponse setResponseErrorMessageKeyAddition:@"msg"];    
  
  ~~URLSessionTaskURL *url0 = [[URLSessionTaskURL alloc] initWithBaseURL:@"url0" relativeURL:@"rest/login/loginByName"];
  ~~URLSessionTaskURL *url1 = [[URLSessionTaskURL alloc] initWithBaseURL:@"url1" relativeURL:@"rest/auth/getTokenByTicket"];
      
  ~~__block URLSessionTaskResponse *response0 = nil;
  
  ~~__block URLSessionTaskResponse *response1 = nil;
  
  ~~URLSessionChainTask *chainTask = [[URLSessionChainTask alloc] initWithPrepare:^(NSInteger index, URLSessionTask *task) {
    ~~if (index == 0)
    ~~{
      ~~URLSessionTaskParams *params = [[URLSessionTaskParams alloc] initWithParams:@{@"name":@"100021", @"password":@"123456", @"systemCode":@"ISCC_MOBILE"}];
      ~~task.params = params;
    ~~}
    ~~else
    ~~{
      ~~URLSessionTaskParams *params = [[URLSessionTaskParams alloc] initWithParams:@{@"ticketId":[response0.response safetyValueForKeyAddition:@"data.ticket"]}];
      ~~task.method = URLSessionTaskMethodGET;
      ~~task.params = params;
    ~~}
  ~~} progress:^(NSInteger index, double progress) {
    ~~DEV_LOG(@"progress = %f", progress);
  ~~} success:^(NSInteger index, URLSessionTaskResponse *response) {
    ~~if (index == 0) {
      ~~response0 = response;
    ~~}
    ~~else
    ~~{
      ~~response1 = response;
      ~~DEV_LOG(@"%@", response1.response);
      ~~if (response1.correct) {
        ~~[MBProgressHUDUtil SuccessWithText:@"登录成功" inView:self.view];
      ~~}
    ~~}
  ~~} failure:^(NSInteger index, NSError *error) {
    ~~DEV_LOG(@"error = %@", error);
    ~~[MBProgressHUDUtil ErrorWithText:@"登录失败" inView:self.view];
  ~~}];
  
  ~~[chainTask addTaskURL:url0];
  ~~[chainTask addTaskURL:url1];
  ~~[chainTask send];
  
  ~~[MBProgressHUDUtil LoadingWithText:@"正在加载..." inView:self.view contentBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8] maskBackground:NO userInteraction:YES];
  ~~```

  ~~这里需要注意的是prepare代码块是在异步线程回调。

  修改：由于Block的原因会导致网络请求发送后，视图或控制器无法正常释放，必须等请求回调后才能释放。目前将其修改为代理模式。示例如下：

  ```objective-c
  [URLSessionTaskResponse setResponseErrorMessageKeyAddition:@"msg"];
  URLSessionTaskURL *url0 = [[URLSessionTaskURL alloc] initWithBaseURL:@"http://sccdev.cd.pangu16.com/passport-server" relativeURL:@"rest/login/loginByName"];
  URLSessionTaskURL *url1 = [[URLSessionTaskURL alloc] initWithBaseURL:@"http://sccdev.cd.pangu16.com/passport-server" relativeURL:@"rest/auth/getTokenByTicket"];
  
  URLSessionChainTask *chainTask = [[URLSessionChainTask alloc] initWithDelegate:self];
  [chainTask addTaskURL:url0];
  [chainTask addTaskURL:url1];
  [chainTask send];
  
  [MBProgressHUDUtil LoadingWithText:@"正在加载..." inView:self.view contentBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8] maskBackground:NO userInteraction:YES];
  
  #pragma mark - <URLSessionChainTaskDelegate>
  
  - (void)sessionChainTask:(URLSessionChainTask *)task requestDidSuccessThrowResponse:(URLSessionTaskResponse *)response atIndex:(NSInteger)index
  {
      if (index == 0) {
          self.response0 = response;
      }
      else
      {
          self.response1 = response;
          if (self.response1.correct) {
              [MBProgressHUDUtil SuccessWithText:@"登录成功" inView:self.view];
          }
      }
  }
  
  - (void)sessionChainTask:(URLSessionChainTask *)chainTask prepareParamsFor:(URLSessionTask *)task atIndex:(NSInteger)index
  {
      if (index == 0)
      {
          URLSessionTaskParams *params = [[URLSessionTaskParams alloc] initWithParams:@{@"name":@"100021", @"password":@"123456", @"systemCode":@"ISCC_MOBILE"}];
          task.params = params;
      }
      else
      {
          URLSessionTaskParams *params = [[URLSessionTaskParams alloc] initWithParams:@{@"ticketId":[self.response0.response safetyValueForKeyAddition:@"data.ticket"]}];
          task.method = URLSessionTaskMethodGET;
          task.params = params;
      }
  }
  
  - (void)sessionChainTask:(URLSessionChainTask *)task requestDidFailedThrowError:(NSError *)error atIndex:(NSInteger)index
  {
      [MBProgressHUDUtil ErrorWithText:@"登录失败" inView:self.view];
      [self.view setMessage:@"网络错误，请稍后尝试" type:NoDatasourceTypeError];
  }
  
  @end
  ```

- 视图的部分圆角

  该方法需要在视图或控制器的`layoutSubviews`中调用：

  ```objective-c
  [_redView setCorners:UICornerRadiusMake(40, 0, 0, 60)];
  ```

- 支持placeholder的TextView

  `UIPlaceholderTextView`是一个支持placeholder的TextView，并且支持修改占位符的颜色：  

  ```objective-c
  _textView.placeholder = @"我是占位符";
  ```

- 无数据时的占位图

  在网络请求无数据时，一般会有一个占位图显示：  

  ```objective-c
  [self.view setMessage:@"暂无数据" type:NoDatasourceTypeEmpty];
  ```
