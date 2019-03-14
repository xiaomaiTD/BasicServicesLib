//
//  ViewController.m
//  BasicServicesLib
//
//  Created by qiancaox on 2019/2/28.
//  Copyright © 2019年 Luckeyhill. All rights reserved.
//

#import "ViewController.h"
#import "BasicServicesLib.h"
#import "TableViewController.h"

@interface ViewController ()

@property(weak, nonatomic) UIView *redView;
@property (weak, nonatomic) IBOutlet UIPlaceholderTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView.placeholder = @"我是占位符";
    _textView.text = @"阿卡丽聚隆科技垃圾速度来看风景埃里克森";
    
    DEV_LOG(@"\n\n\n************************** NETWORKING **************************\n");
    
    [URLSessionTaskResponse setResponseSuccessCode:200 forKeyAddition:@"code"];
    [URLSessionTaskResponse setResponseErrorMessageKeyAddition:@"msg"];
    
    URLSessionTaskURL *url0 = [[URLSessionTaskURL alloc] initWithBaseURL:@"http://sccdev.cd.pangu16.com/passport-server" relativeURL:@"rest/login/loginByName"];
    URLSessionTaskURL *url1 = [[URLSessionTaskURL alloc] initWithBaseURL:@"http://sccdev.cd.pangu16.com/passport-server" relativeURL:@"rest/auth/getTokenByTicket"];
    
    __block URLSessionTaskResponse *response0 = nil;
    __block URLSessionTaskResponse *response1 = nil;
    
    URLSessionChainTask *chainTask = [[URLSessionChainTask alloc] initWithPrepare:^(NSInteger index, URLSessionTask *task) {
        if (index == 0)
        {
            URLSessionTaskParams *params = [[URLSessionTaskParams alloc] initWithParams:@{@"name":@"100021", @"password":@"123456", @"systemCode":@"ISCC_MOBILE"}];
            task.params = params;
        }
        else
        {
            URLSessionTaskParams *params = [[URLSessionTaskParams alloc] initWithParams:@{@"ticketId":[response0.response safetyValueForKeyAddition:@"data.ticket"]}];
            task.method = URLSessionTaskMethodGET;
            task.params = params;
        }
    } progress:^(NSInteger index, double progress) {
        DEV_LOG(@"progress = %f", progress);
    } success:^(NSInteger index, URLSessionTaskResponse *response) {
        if (index == 0) {
            response0 = response;
        }
        else
        {
            response1 = response;
            DEV_LOG(@"%@", response1.response);
            if (response1.correct) {
                [MBProgressHUDUtil SuccessWithText:@"登录成功" inView:self.view];
            }
        }
    } failure:^(NSInteger index, NSError *error) {
        DEV_LOG(@"error = %@", error);
        [MBProgressHUDUtil ErrorWithText:@"登录失败" inView:self.view];
    }];
    [chainTask addTaskURL:url0];
    [chainTask addTaskURL:url1];
    [chainTask send];
    
    [MBProgressHUDUtil LoadingWithText:@"正在加载..." inView:self.view contentBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8] maskBackground:NO userInteraction:YES];
    
//    DEV_LOG(@"\n\n\n************************** DICTIONARY SAFTY **************************\n")
//    NSDictionary *dict = @{ @"data" : @{
//                                         @"list" : @[ @8.627, @2, @3 ]
//                                         }
//                          };
//    id value = [dict safetyValueForKeyAddition:@"data.list[0]"];
//    DEV_LOG(@"%@", value);
//    dict = [dict safetySetValue:@"nidayede" forKeyAddition:@"data.object.name"];
//    DEV_LOG(@"%@", dict);
//    dict = [dict safetySetValue:@{@"name":@"woshinibaba"} forKeyAddition:@"data.list[1]"];
//    DEV_LOG(@"%@", dict);
//    
//    DEV_LOG(@"\n\n\n************************** TIMEUTIL **************************\n")
//    DEV_LOG(@"%@", [TimeUtil stringFromTimestamp:1551420561000 format:kTimeFormatter]);
//    
//    
//    DEV_LOG(@"\n\n\n************************** SQLITE **************************\n")
//    DEV_LOG(@"%@", [[SqliteDatabase database] dbPath]);
//    [[SqliteDatabase database] insertUserInfo:dict forAccount:@"18200467799"];
//    DEV_LOG(@"%@", [[SqliteDatabase database] getUserInfoByAccount:@"18200467799"]);
//    [[SqliteDatabase database] insertLoginWithAccount:@"18200467799" password:@"alksdjfljk"];
//    DEV_LOG(@"%@", [[SqliteDatabase database] getAllLoginAccount]);
//    DEV_LOG(@"%@", [[SqliteDatabase database] getPasswordByAccount:@"18200467799"]);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"order_list" ofType:@"geojson"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSMutableString *mutStr = [NSMutableString stringWithString:string];
//    NSRange range = { 0, string.length };
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//    NSRange range2 = { 0, mutStr.length };
//    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//    NSError *error = nil;
//    NSDictionary *orderList = [NSJSONSerialization JSONObjectWithData:[mutStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
//    [[SqliteDatabase database] insertItems:orderList[@"data"] primeryPath:@"id" inTable:@"order_list"];
//    NSDictionary *orderEntity = ((NSArray *)orderList[@"data"]).firstObject;
//    orderEntity = [orderEntity safetySetValue:@YES forKeyAddition:@"checked"];
//    DispatchAfter(2, ^{
//        [[SqliteDatabase database] updateItems:@[orderEntity] primeryPath:@"id" inTable:@"order_list"];
//        DEV_LOG(@"%@", [[SqliteDatabase database] getItemsInTable:@"order_list" size:10 page:0]);
//        [[SqliteDatabase database] clear];
//        DEV_LOG(@"%fM", [[SqliteDatabase database] bytes]/kBytesToMbDivisor);
//    });
//    DEV_LOG(@"%fM", [[SqliteDatabase database] bytes]/kBytesToMbDivisor);
//    
//    DEV_LOG(@"\n\n\n************************** ENCRYP **************************\n")
//    NSString *key = @"aaaaaaaaaaaaaaaa";
//    NSData *iv = [@"Luckeyhill_Luckeyhill" dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *encryptedString = [@"张三listlkajl" encryptedWithAESUsing:key iv:iv];
//    NSString *decryptedString = [encryptedString decryptedWithAESUsing:key iv:iv];
//    DEV_LOG(@"encrypt: %@, decrypt: %@", encryptedString, decryptedString);
//    
    UIView *redView = [[UIView alloc] initWithFrame:REct(100, 100, 100, 100)];
    redView.backgroundColor = UIColor.redColor;
    [self.view addSubview:redView];
    _redView = redView;
//    
//    DEV_LOG(@"\n\n\n************************** DECIMALUTIL **************************\n")
//    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"198348998.398984"];
//    NSString *amount = [DecimalUtil amountFromDecimal:decimal scale:4 type:AmountTypeNone usingUnit:NO];
//    DEV_LOG(@"%@", amount);
//    DEV_LOG(@"%@", [DecimalUtil percentFromDecimal:[NSDecimalNumber decimalNumberWithString:@"0.13"]]);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [_redView setCorners:UICornerRadiusMake(40, 0, 0, 60)];
}

- (IBAction)toTableList:(id)sender
{
    TableViewController *controller = [[TableViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
