//
//  MTZColoredBackgroundView.m
//  FileShuttle
//
//  Created by Matt Zanchelli on 2/8/13.
//
//

#import "MTZColoredBackgroundView.h"

@implementation MTZColoredBackgroundView

@synthesize backgroundColor;

- (void)drawRect:(NSRect)rect
{
    [backgroundColor set];
    NSRectFill([self bounds]);
}

@end
