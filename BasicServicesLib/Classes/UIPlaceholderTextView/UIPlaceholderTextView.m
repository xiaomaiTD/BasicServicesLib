//
//  Copyright © 2019 yeeshe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UIPlaceholderTextView.h"
#import "NSString+Size.h"
#import "Macros.h"
#import "UIView+CGRect.h"

@implementation UIPlaceholderTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _placeholderColor = [UIColor lightGrayColor];
        [NotificationCenter addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _placeholderColor = [UIColor lightGrayColor];
        [NotificationCenter addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.placeholder.length > 0)
    {
        CGRect start = [self caretRectForPosition:self.beginningOfDocument];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = self.font;
        attrs[NSForegroundColorAttributeName] = self.placeholderColor;
        
        CGFloat width = [_placeholder boundingSizeWithFont:self.font constrainedToSize:_CGSize(self.width, self.font.lineHeight)].width;
        CGRect range = _CGRect(0, 0, width, self.font.lineHeight);
        
        if (self.textAlignment == NSTextAlignmentCenter) {
            range.origin.x = self.width/2-width/2;
        }
        else if (self.textAlignment == NSTextAlignmentRight)
        {
            range.origin.x = self.width-width;
        }
        else
        {
            range.origin.x = start.origin.x;
        }
        
        range.origin.y = start.origin.y+(start.size.height-self.font.lineHeight)/2;
        [self.placeholder drawInRect:range withAttributes:attrs];
    }
}

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

//- (void)textDidChange:(NSNotification *)aNotice
//{
//    [self setNeedsDisplay];
//}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

@end
