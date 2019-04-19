//
//  TableViewController.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/4.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "TableViewController.h"
#import "BasicServicesLib.h"
#import <AFNetworking/AFNetworking.h>

@interface TableViewController () <URLSessionChainTaskDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) __block URLSessionTaskResponse *response0;
@property(strong, nonatomic) __block URLSessionTaskResponse *response1;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    [URLSessionTaskResponse setResponseSuccessCode:200 forKeyAddition:@"code"];
    [URLSessionTaskResponse setResponseErrorMessageKeyAddition:@"msg"];

    URLSessionTaskURL *url0 = [[URLSessionTaskURL alloc] initWithBaseURL:@"***" relativeURL:@"rest/login/loginByName"];
    URLSessionTaskURL *url1 = [[URLSessionTaskURL alloc] initWithBaseURL:@"***" relativeURL:@"rest/auth/getTokenByTicket"];

    URLSessionChainTask *chainTask = [[URLSessionChainTask alloc] initWithDelegate:self];
    [chainTask addTaskURL:url0];
    [chainTask addTaskURL:url1];
    [chainTask send];
    
    [MBProgressHUDUtil LoadingWithText:@"正在加载..." inView:self.view contentBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9] maskBackground:NO userInteraction:YES];
    
    UIButton *button = [[UIButton alloc] initWithFrame:_CGRect(100, 100, 100, 40)];
    button.backgroundColor = [UIColor redColor];
    ViewShadow(button, [UIColor blueColor], 0.3, 3, CGSizeZero);
    [self.view addSubview:button];
    @weakify(self)
    [button addBlockForControlEvents:UIControlEventTouchUpInside responder:^(UIControl *sender) {
        @strongify(self)
        NSLog(@"self = %@, sender = %@", self, sender);
    }];
    
    [NotificationCenter addBlockWithName:@"name" object:nil identifier:@"identifier" responder:^(NSNotification *sender) {
        @strongify(self)
        NSLog(@"self = %@, sender.userInfo = %@", self, sender.userInfo);
    }];
    
    [_tableView setRetryBlockIfNeeded:^{
        @strongify(self)
        
        UIAlertController *controller = [UIAlertController alertWithTitle:@"Alert" message:@"This is a test alert message!" actionHandler:^(UIAlertActionStyle style, NSInteger index) {
            
        } destructiveStyleButtonTitle:@"Destructive" cancelStyleButtonTitle:@"Cancel" defaultStyleButtonTitles:@"Default", nil];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
        
    }];
}

- (void)dealloc
{
    [NotificationCenter removeBlockWithName:@"name" identifier:@"identifier"];
    NSLog(@"TableViewController have dealloced.");
}

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
    [self.tableView setMessage:@"网络错误，请稍后尝试" type:NoDatasourceTypeError];
}

@end
