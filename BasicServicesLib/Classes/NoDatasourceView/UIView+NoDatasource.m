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

@interface UIView ()

@property(weak, nonatomic) NoDatasourceView *emptyView;
@property(weak, nonatomic) NoDatasourceView *errorView;

@property(assign, nonatomic) BOOL isEmptyViewShown;
@property(assign, nonatomic) BOOL isErrorViewShown;
@property(assign, nonatomic) BOOL shouldResponedRotate;

- (void)_willRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)_animatingRotateWithInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)_didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

- (NSArray<UIView*> *)_shouldResponedRotateSubviews;

@end

@implementation UIView (NoDatasource)

static char * const kNoDatasourceEmptyViewAssociateKey = "\0";
static char * const kNoDatasourceErrorViewAssociateKey = "\1";
static char * const kNoDatasourceEmptyViewShownAssociateKey = "\2";
static char * const kNoDatasourceErrorViewShownAssociateKey = "\3";
static char * const kRetryBlockAssociateKey = "\4";
static char * const kShouldResponedRotateAssociateKey = "\5";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)_willRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [[self _shouldResponedRotateSubviews] enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
        [aView _willRotateFromInterfaceOrientation:toInterfaceOrientation];
    }];
}

- (void)_animatingRotateWithInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [[self _shouldResponedRotateSubviews] enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
        [aView _animatingRotateWithInterfaceOrientation:toInterfaceOrientation];
    }];
    [self setFrameNoDataSourceViewIfNeeded];
}

- (void)_didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [[self _shouldResponedRotateSubviews] enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
        [aView _didRotateToInterfaceOrientation:toInterfaceOrientation];
    }];
}

- (NSArray<UIView *> *)_shouldResponedRotateSubviews
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *aView in self.subviews)
    {
        if (aView.shouldResponedRotate && [aView isKindOfClass:[UIView class]]) {
            [arr addObject:aView];
        }
    }
    
    return [arr copy];
}

#pragma clang diagnostic pop

- (void)setMessage:(NSString *)message type:(NoDatasourceType)type
{
    if (type == NoDatasourceTypeEmpty)
    {
        self.isEmptyViewShown = YES;;
        [self.emptyView setMessage:message];
        [self.emptyView setHidden:NO];
        if (self.isErrorViewShown)
        {
            [self.errorView setHidden:YES];
            self.isErrorViewShown = NO;
        }
    }
    else if (type == NoDatasourceTypeError)
    {
        self.isErrorViewShown = YES;
        [self.errorView setMessage:message];
        [self.errorView setHidden:NO];
        if (self.isEmptyViewShown)
        {
            [self.emptyView setHidden:YES];
            self.isEmptyViewShown = NO;
        }
    }
    else
    {
        self.shouldResponedRotate = NO;
        return;
    }
    
    self.shouldResponedRotate = YES;
    [self setFrameNoDataSourceViewIfNeeded];
}

- (void)setHiddenNoDatasource
{
    if (self.isErrorViewShown)
    {
        [self.errorView setHidden:YES];
        self.isErrorViewShown = NO;
    }
    
    if (self.isEmptyViewShown)
    {
        [self.emptyView setHidden:YES];
        self.isEmptyViewShown = NO;
    }
}

- (void)setFrameNoDataSourceViewIfNeeded
{
#define IS_SCROLLVIEW   [self isKindOfClass:[UIScrollView class]]
    
    if (self.isEmptyViewShown)
    {
        if (IS_SCROLLVIEW)
        {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGFloat topInset = scrollView.contentInset.top;
            CGFloat boundsY = ABS(scrollView.bounds.origin.y);
            CGFloat heightOffset = topInset+boundsY;
            [self.emptyView setFrame:_CGRect(0, -heightOffset, self.bounds.size.width, self.bounds.size.height)];
        }
        else
        {
            [self.emptyView setFrame:self.bounds];
        }
    }
    
    if (self.isErrorViewShown)
    {
        if (IS_SCROLLVIEW)
        {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGFloat topInset = scrollView.contentInset.top;
            CGFloat boundsY = ABS(scrollView.bounds.origin.y);
            CGFloat heightOffset = topInset+boundsY;
            [self.errorView setFrame:_CGRect(0, -heightOffset, self.bounds.size.width, self.bounds.size.height)];
        }
        else
        {
            [self.errorView setFrame:self.bounds];
        }
    }
}

#pragma mark - Setters/Getters

- (NoDatasourceView *)emptyView
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

- (void)setRetryBlockIfNeeded:(dispatch_block_t)block
{
    objc_setAssociatedObject(self, kRetryBlockAssociateKey, block, OBJC_ASSOCIATION_COPY);
}

- (dispatch_block_t)retryBlock
{
    return objc_getAssociatedObject(self, kRetryBlockAssociateKey);
}

- (void)setShouldResponedRotate:(BOOL)shouldResponedRotate
{
    objc_setAssociatedObject(self, kShouldResponedRotateAssociateKey, @(shouldResponedRotate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldResponedRotate
{
    id value = objc_getAssociatedObject(self, kShouldResponedRotateAssociateKey);
    if (!value) {
        return NO;
    }
    
    return [value boolValue];
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
    
    if ([self.view respondsToSelector:@selector(_willRotateFromInterfaceOrientation:)]) {
        [self.view _willRotateFromInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([self.view respondsToSelector:@selector(_animatingRotateWithInterfaceOrientation:)]) {
            [self.view _animatingRotateWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([self.view respondsToSelector:@selector(_didRotateToInterfaceOrientation:)]) {
            [self.view _didRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
        }
    }];
}

@end
