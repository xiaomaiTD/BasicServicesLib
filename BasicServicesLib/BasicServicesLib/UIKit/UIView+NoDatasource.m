//
//  UIView+NoDatasource.m
//  BasicServicesLib
//
//  Created by Luckeyhill on 2019/3/4.
//  Copyright © 2019 Luckeyhill. All rights reserved.
//

#import "UIView+NoDatasource.h"
#import "NoDatasourceView.h"
#import <objc/runtime.h>
#import "NSBundle+BasicServicesLibResource.h"
#import "Macros.h"

static void exchange_method(Class cls, SEL selector1, SEL selector2)
{
    method_exchangeImplementations(class_getInstanceMethod(cls, selector1), class_getInstanceMethod(cls, selector2));
}

@interface NSBundle (NoDatasource)

+ (UIImage *)emptyErrorImage;

@end

@implementation NSBundle (NoDatasource)

+ (UIImage *)emptyErrorImage
{
    static UIImage *image = nil;
    if (image == nil)
    {
        NSString *imageNamed = NSStringFormat(@"%@", ScreenScale == 3.0 ? @"empty_error@3x":@"empty_error@2x");
        NSString *imagePath = [[self basicServicesLibBundle] pathForResource:imageNamed ofType:@"png"];
        image = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

@end


@implementation UIView (NoDatasource)

static char * const kNoDatasourceEmptyViewAssociateKey = "\0";
static char * const kNoDatasourceErrorViewAssociateKey = "\1";
static char * const kNoDatasourceEmptyViewShownAssociateKey = "\2";
static char * const kNoDatasourceErrorViewShownAssociateKey = "\3";

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exchange_method(self, @selector(setFrame:), @selector(_setFrame:));
    });
}

- (NoDatasourceView *)emtpyView
{
    NoDatasourceView *empty = objc_getAssociatedObject(self, kNoDatasourceEmptyViewAssociateKey);
    if (empty == nil)
    {
        empty = [NoDatasourceView showInView:self];
        [empty setImage:[NSBundle emptyErrorImage]];
        empty.hidden = YES;
        [self addSubview:empty];
        objc_setAssociatedObject(self, kNoDatasourceEmptyViewAssociateKey, empty, OBJC_ASSOCIATION_ASSIGN);
    }
    return empty;
}

- (NoDatasourceView *)errorView
{
    NoDatasourceView *error = objc_getAssociatedObject(self, kNoDatasourceErrorViewAssociateKey);
    if (error == nil)
    {
        error = [NoDatasourceView showInView:self];
        [error setImage:[NSBundle emptyErrorImage]];
        [error setRetryText:@"重新加载"];
        error.hidden = YES;
        [self addSubview:error];
        objc_setAssociatedObject(self, kNoDatasourceErrorViewAssociateKey, error, OBJC_ASSOCIATION_ASSIGN);
    }
    return error;
}

- (BOOL)isEmptyViewShown
{
    return [objc_getAssociatedObject(self, kNoDatasourceEmptyViewShownAssociateKey) boolValue];
}

- (void)setIsEmptyViewShown:(BOOL)yesOrNo
{
    objc_setAssociatedObject(self, kNoDatasourceEmptyViewShownAssociateKey, @(yesOrNo), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isErrorViewShown
{
    return [objc_getAssociatedObject(self, kNoDatasourceErrorViewShownAssociateKey) boolValue];
}

- (void)setIsErrorViewShown:(BOOL)yesOrNo
{
    objc_setAssociatedObject(self, kNoDatasourceErrorViewShownAssociateKey, @(yesOrNo), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)_setFrame:(CGRect)frame
{
    [self _setFrame:frame];
    
    if ([self isEmptyViewShown]) {
        [[self emtpyView] setFrame:REct(0, 0, frame.size.width, frame.size.height)];
    }
    
    if ([self isErrorViewShown]) {
        [[self errorView] setFrame:REct(0, 0, frame.size.width, frame.size.height)];
    }
}

- (NSInteger)_datasourceCountIfListView
{
    NSInteger count = 0;
    
    if ([self isKindOfClass:[UITableView class]])
    {
        UITableView *table = (UITableView *)self;
        for (NSInteger section = 0; section < table.numberOfSections; section ++) {
            count += [table numberOfRowsInSection:section];
        }
    }
    else if ([self isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collection = (UICollectionView *)self;
        for (NSInteger section = 0; section < collection.numberOfSections; section ++) {
            count += [collection numberOfItemsInSection:section];
        }
    }
    
    return count;
}

- (void)_setShowEmptyIfListView
{
    if ([self _datasourceCountIfListView] == 0) {
        [self setMessage:@"未查找到相应数据" type:NoDatasourceTypeEmpty];
    }
    else
    {
        [self setHiddenNoDatasource];
    }
}

- (void)setMessage:(NSString *)message type:(NoDatasourceType)type
{
    if (type == NoDatasourceTypeEmpty)
    {
        [self setIsEmptyViewShown:YES];
        [[self emtpyView] setMessage:message];
        [[self emtpyView] setHidden:NO];
        if ([self isErrorViewShown])
        {
            [[self errorView] setHidden:YES];
            [self setIsErrorViewShown:NO];
        }
    }
    else
    {
        [self setIsErrorViewShown:YES];
        [[self errorView] setMessage:message];
        [[self errorView] setHidden:NO];
        if ([self isEmptyViewShown])
        {
            [[self emtpyView] setHidden:YES];
            [self setIsEmptyViewShown:NO];
        }
    }
}

- (void)setHiddenNoDatasource
{
    if ([self isErrorViewShown])
    {
        [[self errorView] setHidden:YES];
        [self setIsErrorViewShown:NO];
    }
    
    if ([self isEmptyViewShown])
    {
        [[self emtpyView] setHidden:YES];
        [self setIsEmptyViewShown:NO];
    }
}

@end


@implementation UITableView (NoDatasource)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(reloadData),
            @selector(insertSections:withRowAnimation:),
            @selector(deleteSections:withRowAnimation:),
            @selector(reloadSections:withRowAnimation:),
            @selector(insertRowsAtIndexPaths:withRowAnimation:),
            @selector(deleteRowsAtIndexPaths:withRowAnimation:),
            @selector(reloadRowsAtIndexPaths:withRowAnimation:),
        };
        
        for (NSUInteger idx = 0; idx < sizeof(selectors) / sizeof(SEL); ++ idx)
        {
            SEL selector1 = selectors[idx];
            SEL selector2 = NSSelectorFromString([@"_" stringByAppendingString:NSStringFromSelector(selector1)]);
            exchange_method(self, selector1, selector2);
        }
    });
}

- (void)_reloadData
{
    [self _reloadData];
    [self _setShowEmptyIfListView];
}

- (void)_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self _insertSections:sections withRowAnimation:animation];
    [self _setShowEmptyIfListView];
}

- (void)_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self _deleteSections:sections withRowAnimation:animation];
    [self _setShowEmptyIfListView];
}

- (void)_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self _reloadSections:sections withRowAnimation:animation];
    [self _setShowEmptyIfListView];
}

- (void)_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self _insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self _setShowEmptyIfListView];
}

- (void)_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self _deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self _setShowEmptyIfListView];
}

- (void)_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self _reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self _setShowEmptyIfListView];
}

@end


@implementation UICollectionView (NoDatasource)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(reloadData),
            @selector(insertSections:),
            @selector(deleteSections:),
            @selector(reloadSections:),
            @selector(insertItemsAtIndexPaths:),
            @selector(deleteItemsAtIndexPaths:),
            @selector(reloadItemsAtIndexPaths:),
        };
        
        for (NSUInteger idx = 0; idx < sizeof(selectors) / sizeof(SEL); ++ idx)
        {
            SEL selector1 = selectors[idx];
            SEL selector2 = NSSelectorFromString([@"_" stringByAppendingString:NSStringFromSelector(selector1)]);
            exchange_method(self, selector1, selector2);
        }
    });
}

- (void)_reloadData
{
    [self _reloadData];
    [self _setShowEmptyIfListView];
}

- (void)_insertSections:(NSIndexSet *)sections
{
    [self _insertSections:sections];
    [self _setShowEmptyIfListView];
}

- (void)_deleteSections:(NSIndexSet *)sections
{
    [self _deleteSections:sections];
    [self _setShowEmptyIfListView];
}

- (void)_reloadSections:(NSIndexSet *)sections
{
    [self _reloadSections:sections];
    [self _setShowEmptyIfListView];
}

- (void)_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self _insertItemsAtIndexPaths:indexPaths];
    [self _setShowEmptyIfListView];
}

- (void)_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self _deleteItemsAtIndexPaths:indexPaths];
    [self _setShowEmptyIfListView];
}

- (void)_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self _reloadItemsAtIndexPaths:indexPaths];
    [self _setShowEmptyIfListView];
}

@end
