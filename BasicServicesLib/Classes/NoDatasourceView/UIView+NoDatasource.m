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

@interface NSBundle (NoDatasource)

+ (UIImage *)emptyErrorImage;

@end

@implementation NSBundle (NoDatasource)

+ (UIImage *)emptyErrorImage
{
    static UIImage *image = nil;
    if (image == nil)
    {
        NSString *imageNamed = NSStringFormat(@"%@", kScreenScale == 3.0 ? @"empty_error@3x":@"empty_error@2x");
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
static char * const kRetryBlockAssociateKey = "\4";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)animatingRotateWithInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [self setFrameNoDataSourceViewIfNeeded];
}
#pragma clang diagnostic pop

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
        [error setRetryAction:[self retryBlock]];
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
    objc_setAssociatedObject(self, kNoDatasourceEmptyViewShownAssociateKey, @(yesOrNo), OBJC_ASSOCIATION_COPY);
}

- (BOOL)isErrorViewShown
{
    return [objc_getAssociatedObject(self, kNoDatasourceErrorViewShownAssociateKey) boolValue];
}

- (void)setIsErrorViewShown:(BOOL)yesOrNo
{
    objc_setAssociatedObject(self, kNoDatasourceErrorViewShownAssociateKey, @(yesOrNo), OBJC_ASSOCIATION_COPY);
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

/*
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
*/

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
        [self setFrameNoDataSourceViewIfNeeded];
    }
    else if (type == NoDatasourceTypeError)
    {
        [self setIsErrorViewShown:YES];
        [[self errorView] setMessage:message];
        [[self errorView] setHidden:NO];
        if ([self isEmptyViewShown])
        {
            [[self emtpyView] setHidden:YES];
            [self setIsEmptyViewShown:NO];
        }
        [self setFrameNoDataSourceViewIfNeeded];
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

- (void)setFrameNoDataSourceViewIfNeeded
{
#define IS_SCROLLVIEW   [self isKindOfClass:[UIScrollView class]]
    
    if ([self isEmptyViewShown]) {
        if (IS_SCROLLVIEW)
        {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGFloat topInset = scrollView.contentInset.top;
            CGFloat boundsY = ABS(scrollView.bounds.origin.y);
            CGFloat heightOffset = topInset+boundsY;
            [[self errorView] setFrame:_CGRect(0, -heightOffset, self.bounds.size.width, self.bounds.size.height)];
        }
        else
        {
            [[self emtpyView] setFrame:self.bounds];
        }
    }
    
    if ([self isErrorViewShown]) {
        if (IS_SCROLLVIEW)
        {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGFloat topInset = scrollView.contentInset.top;
            CGFloat boundsY = ABS(scrollView.bounds.origin.y);
            CGFloat heightOffset = topInset+boundsY;
            [[self errorView] setFrame:_CGRect(0, -heightOffset, self.bounds.size.width, self.bounds.size.height)];
        }
        else
        {
            [[self errorView] setFrame:self.bounds];
        }
    }
}

- (void)setRetryBlockIfNeeded:(dispatch_block_t)block
{
    objc_setAssociatedObject(self, kRetryBlockAssociateKey, block, OBJC_ASSOCIATION_COPY);
}

- (dispatch_block_t)retryBlock
{
    return objc_getAssociatedObject(self, kRetryBlockAssociateKey);
}

@end

@interface UIViewController (NoDatasource)

@end

@implementation UIViewController (NoDatasource)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExchangeMethod(self, @selector(viewWillTransitionToSize:withTransitionCoordinator:), @selector(_viewWillTransitionToSize:withTransitionCoordinator:));
    });
}

- (void)_viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self _viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if ([self.view respondsToSelector:@selector(willRotateFromInterfaceOrientation:)]) {
        [self.view willRotateFromInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([self.view respondsToSelector:@selector(animatingRotateWithInterfaceOrientation:)]) {
            [self.view animatingRotateWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([self.view respondsToSelector:@selector(didRotateToInterfaceOrientation:)]) {
            [self.view didRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }
    }];
}

@end

/*
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
            ExchangeMethod(self, selector1, selector2);
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
            ExchangeMethod(self, selector1, selector2);
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
*/
