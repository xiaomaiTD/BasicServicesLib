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
@property(weak, nonatomic) IBOutlet UIPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UIRelayoutButton *showTableViewControllerButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView.placeholder = @"我是占位符";
    _textView.text = @"阿卡丽聚隆科技垃圾速度来看风景埃里克森";
    
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

    DEV_LOG(@"%@", [TimeUtil stringFromTimestamp:1551420561000 format:kTimeFormatter]);
    
    DEV_LOG(@"%@", [[SqliteDatabase database] dbPath]);
    [[SqliteDatabase database] insertUserInfo:dict forAccount:@"18200467799"];
    DEV_LOG(@"%@", [[SqliteDatabase database] getUserInfoByAccount:@"18200467799"]);
    [[SqliteDatabase database] insertLoginWithAccount:@"18200467799" password:@"alksdjfljk"];
    DEV_LOG(@"%@", [[SqliteDatabase database] getAllLoginAccount]);
    DEV_LOG(@"%@", [[SqliteDatabase database] getPasswordByAccount:@"18200467799"]);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"order_list" ofType:@"geojson"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:string];
    NSRange range = { 0, string.length };
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = { 0, mutStr.length };
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSError *error = nil;
    NSDictionary *orderList = [NSJSONSerialization JSONObjectWithData:[mutStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    [[SqliteDatabase database] insertItems:orderList[@"data"] primeryPath:@"id" inTable:@"order_list"];
    NSDictionary *orderEntity = ((NSArray *)orderList[@"data"]).firstObject;
    orderEntity = [orderEntity safetySetValue:@YES forKeyAddition:@"checked"];
    DispatchAfter(2, ^{
        NotificationCenterPost(@"name", nil, @{@"haha":@"asdf"});
        [[SqliteDatabase database] updateItems:@[orderEntity] primeryPath:@"id" inTable:@"order_list"];
        DEV_LOG(@"%@", [[SqliteDatabase database] getItemsInTable:@"order_list" size:10 page:0]);
        [[SqliteDatabase database] clear];
        DEV_LOG(@"%fM", [[SqliteDatabase database] bytes]/kBytesToMbDivisor);
    });
    DEV_LOG(@"%fM", [[SqliteDatabase database] bytes]/kBytesToMbDivisor);

    NSString *key = @"aaaaaaaaaaaaaaaa";
    NSData *iv = [@"Luckeyhill_Luckeyhill" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encryptedString = [@"张三listlkajl" encryptedWithAESUsing:key iv:iv];
    NSString *decryptedString = [encryptedString decryptedWithAESUsing:key iv:iv];
    DEV_LOG(@"encrypt: %@, decrypt: %@", encryptedString, decryptedString);

    UIView *redView = [[UIView alloc] initWithFrame:_CGRect(100, 100, 100, 100)];
    redView.backgroundColor = UIColor.redColor;
    [self.view addSubview:redView];
    _redView = redView;
    ViewBorderRadius(redView, 10, 1, UIColor.blackColor);

    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:@"198348998.398984"];
    NSString *amount = [DecimalUtil amountFromDecimal:decimal scale:4 type:AmountTypeNone usingUnit:NO];
    DEV_LOG(@"%@", amount);
    DEV_LOG(@"%@", [DecimalUtil percentFromDecimal:[NSDecimalNumber decimalNumberWithString:@"0.13"]]);
    
    @weakify(self)
    [self.showTableViewControllerButton addBlockForControlEvents:UIControlEventTouchUpInside responder:^(UIControl *sender) {
        @strongify(self)
        [self performSegueWithIdentifier:@"ShowTableViewController" sender:nil];
    }];
}

- (IBAction)showDatePicker:(id)sender
{
    
}

@end
