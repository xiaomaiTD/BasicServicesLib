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

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

- (UIImage *)cropedImageWithCornerRaidus:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, cornerRadius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height-cornerRadius);
    CGContextAddArc(context, cornerRadius, self.size.height-cornerRadius, cornerRadius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width-cornerRadius, self.size.height);
    CGContextAddArc(context, self.size.width-cornerRadius, self.size.height-cornerRadius, cornerRadius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, cornerRadius);
    CGContextAddArc(context, self.size.width-cornerRadius, cornerRadius, cornerRadius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, cornerRadius, 0.0f);
    CGContextAddArc(context, cornerRadius, cornerRadius, cornerRadius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
