# BasicServicesLib使用说明

`BasicServicesLib`是一个`iOS`的项目基础组件库。包含了很多的便捷方法和函数；对部分UI组件进行扩展，很方便的实现界面开发；基于`AFN`实现了链式网络请求，利用请求池管理请求的管理周期，使用代理作为回调，避免代码块造成的内存泄露问题；简单的数据库设计方案等...

[TOC]

## 项目依赖库

    + Using AFNetworking(3.2.1)
    + Using FMDB(2.7.5)
    + Using MBProgressHUD(1.1.0)

## 演示项目

将仓库`clone`下来后，使用`Pod`安装即可使用。

## 功能说明及示例

在说明之前先感谢下代码中`Refer`标注的作者，感谢他们贡献的**干货**。

### 2.0 常用的宏定义及函数

“AppBase”中有两个文件：`Macros`和`Functions`，前者主要是日常开发中使用比较多的宏定义，强/弱引用是我根据[ReactiveCocoa 之 @weakify/@strongify](https://www.jianshu.com/p/9e18f28bf28d)实现的，亲测有效，如果出现其他什么问题请直接[issue](https://github.com/qiancaox/BasicServicesLib/issues)，在宏定义中还定义`kiPhoneXScreenBottomSafeAreaHeight`用于适配`iPhoneX`的安全区域，并且适配了横屏和竖屏两种情况。后者是常用的函数，使用`_CGRect`替代了`CGRectMake`等；还包括了诸如：`Array`/`Dictionary`/`String`串判空、`UIView`添加圆角和阴影、通知中心添加观察者和发送通知、方法交换和一些简单的数组操作等。

### 2.1 网络请求的封装

`Networking`将网络请求分为了三个部分：请求连接、请求参数、请求响应，同时增加了请求池来管理请求的生命周期，并且相同的请求，如果上一个还没有响应时，下一个请求来到了会自动取消上一个请求。

请求中增加了对关联性请求的支持：`URLSessionChainTask`实现了关联请求。使用如下：

```objective-c
[URLSessionTaskResponse setResponseErrorMessageKeyAddition:@"msg"];
URLSessionTaskURL *url0 = [[URLSessionTaskURL alloc] initWithBaseURL:@"***" relativeURL:@"rest/login/loginByName"];
URLSessionTaskURL *url1 = [[URLSessionTaskURL alloc] initWithBaseURL:@"***" relativeURL:@"rest/auth/getTokenByTicket"];

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

```

需要注意的是由于代码块的原因，AFN在网络请求发送后，如果请求没有结束在block中使用的对象（主要是控制器等）可能会等到网络请求结束后才能正常释放。所以我将代码块改为代理的回调，网络请求的生命周期和内部变量的生命周期互不影响。

另外，方法`- (void)sessionChainTask:(URLSessionChainTask *)chainTask prepareParamsFor:(URLSessionTask *)task atIndex:(NSInteger)index`用于组装数据，是在异步线程中进行回调的，所以有需要的话可以自行回调到主线程中进行。

### 2.2 简单的数据库设计

“简单”两个字用的毫不过分，因为它真的太简单了，表格设计就是`key-value`，其中值是将原始数据(`NSDictionary`)转化为字符串后进过一次`AES`加密后的字符串。与`sqlite`的交互是通过`FMDB`实现的，对于`order`类型表格的查询使用了事务完成，主要目的是增加查询的速度。

### 2.3 常用的分类

“Categories”中包含了很多的常用分类，我在分类命名时为了劲量准去的描述分类功能，都是将目的作为名字来命名分类的。这里我抽几个自认为比较典型的做下说明，其他的可以直接查看源码。

#### 2.3.0 UIKit+Foundation+Blocked

这里包含了3个文件，实现了`KVO、通知中心、UIControl`的block回调。当然是用起来还是比较简便的，但是务必在block中是用弱引用，否则会导致内存泄露。至于用还是不用，仁者见仁智者见智吧。

#### 2.3.1 UIAlertController

`UIAlertController`应该是开发中是用的比较多的弹出框了，传统的是用是初始化控制器，初始化action，将action加入控制器，用起来很不方便，所以我将其封装，只需要是用一个方法就可以完成上述步骤，开发者只需要将重心移动到回调的处理上即可：

```objective-c
UIAlertController *controller = [UIAlertController alertWithTitle:@"Alert" message:@"This is a test alert message!" actionHandler:^(UIAlertActionStyle style, NSInteger index) {
                
            } destructiveStyleButtonTitle:@"Destructive" cancelStyleButtonTitle:@"Cancel" defaultStyleButtonTitles:@"Default", nil];
[self.navigationController presentViewController:controller animated:YES completion:nil];
```

代码块回调时请注意弱引用。

#### 2.3.2 NSDictionary

这个分类起源于公司项目变动特别大，起初我们是用`MJExtension`将字典序列化为模型对象，但是结构体太不稳定了，可能刚把模型起起来，结构体就改变了，给我们造成了巨大的工作量。于是乎我们就不再是用模型了，而是去模型化。虽然直接是用字典不会造成模型改变带来的困扰，但是在取值时又变得十分被动。所以需要有这么一个东西来实现对字典的取值和设值操作，所以写了一个分类来完成：

```objective-c
NSDictionary *dict = @{ @"data" : @{
                                         @"list" : @[ @8.627, @2, @3 ]
                                         }
                          };
id value = [dict safetyValueForKeyAddition:@"data.list[0]"];
DEV_LOG(@"%@", value);
dict = [dict safetySetValue:@"nidayede" forKeyAddition:@"data.object.name"];
DEV_LOG(@"%@", dict);
dict = [dict safetySetValue:@{@"name":@"woshinibaba"} forKeyAddition:@"data.list[1]"];
DEV_LOG(@"%@", dict);
```

#### 2.3.3 UIView+CornerRadius

大部分时候，圆角的设值着实让我们头疼，如果一味的使用`layer.cornerRadius`的话会因为离屏渲染而造成性能损失。另外，“部分圆角”的需求也是比较常见的。现在你只需要一句代码即可实现：

```objective-c
[_redView setCorners:UICornerRadiusMake(10, 5, 6, 1)];
```

注意，这句劲量在View的Rect确认的情况下设置，支持四个不同的圆角值，并且不会使用离屏渲染而造成性能损失。

### 2.4 常用的组件

“Classes”是我在日常开发工作中总结的UI组件和功能性的库。使用上力争劲量让业务方方便得原则而开发，可能存在bug，如有发现请直接接[issue](https://github.com/qiancaox/BasicServicesLib/issues)，这里再次表示感谢。

#### 2.4.0 UIPlaceholderTextView

常用的`UITextField`不支持多行文字的输入，而`UITextView`虽然存在`placeholder`的属性（使用runtime抓取到的），然而却没有实现。所以`UIPlaceholderTextView`实现了带占位符的`UITextView`，占位符的位置是我根据光标的起始位置计算所得，目前看起来是没有问题的，使用如下：

```objective-c
_textView.placeholder = @"我是占位符";
```

占位符的默认颜色是`lightGrayColor`，支持自行修改。为了达到和`UITextField`一样的效果，我在初始化时给它添加了通知中心的观察者，当文字大于0时才会隐藏掉占位符。

#### 2.4.1 UIRelayoutButton

常用的`UIButton`都是水平布局的，而实际开发中，时常需要文字和图片垂直布局，`UIRelayoutButton`就是这样的一个解决方案，实现了文字和图片的布局的更改，目前支持四中样式：

```objective-c
typedef NS_ENUM(NSUInteger, UIRelayoutButtonStyle) {
    // image在上，label在下
    UIRelayoutButtonStyleTop,
    // image在左，label在右
    UIRelayoutButtonStyleLeft,
    // image在下，label在上
    UIRelayoutButtonStyleBottom,
    // image在右，label在左
    UIRelayoutButtonStyleRight
};
```

并且还支持设置文字和图片的间距。

#### 2.4.2 PresentedHUDBasicViewController

弹出视图的使用可谓是千奇百怪，然而他们都有一个共性是半透明黑底。通过继承于`PresentedHUDBasicViewController`的控制器，可以很方便的实现自定义的弹出控制器（而不是使用`UIView`了）。开发者只需要重新两个方法就可以实现弹入和弹出的动画：

```objective-c
/// Rewrite the following methods to achieve the animation of the pop-up box.
- (void)willPresentInView:(UIView *)toView duration:(NSTimeInterval)duration;
/// Rewrite the following methods to achieve the animation of the pop up box.
- (void)willDismissFromView:(UIView *)fromView duration:(NSTimeInterval)duration;
```

并且你也只需要考虑自己弹出视图的样式和业务，其余的转场动画都由基类实现。

#### 2.4.3 无视图的占位图 - NoDatasourceView

基于`UIView`的分类，只需要一句代码即可实现无数据或网络错误的占位图：

```objective-c
[self.tableView setMessage:@"网络错误，请稍后尝试" type:NoDatasourceTypeError];
```

并且在`1.1.6`的版本中修复了因为`UIScrollView`导致的占位图不在视图中间的问题。尽管底层实现是使用frame进行布局的，还是通过监听屏幕的旋转实现了类似自动布局的效果。

### 3.0 工具类的使用

项目在开发过程中，时常会有一些小的功能性的工具，方便直接调用。我目前使用的比较多的有：MBProgressHUD的工具、关于数字金额转化的工具以及时间戳转化的工具，后续有增加再加入到文件夹中。我会劲量的将工具类的作用单一化，方便后期维护。

## 感谢

我的基础库参考了很多博客，同时我也将参考的博客来源注释在代码中了，特别感谢这些作者分享的**干货**。另外，如果您在使用中有什么疑问，都可以通过[邮箱](qiancaoxiang@gmail.com)联系我，在此感谢大家对我的支持，同时也感谢大家动动手指头star一下。
