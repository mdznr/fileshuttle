#import <Cocoa/Cocoa.h>

@interface NSBezierPath (RoundedRect)

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;

@end