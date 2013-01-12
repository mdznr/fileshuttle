//
//  MVURLShortener.h
//  FileShuttle
//
//  Created by Michael Villar on 12/11/11.
//

#import <Foundation/Foundation.h>
#import <RegexKit/RegexKit.h>

@interface MVURLShortener : NSObject

- (NSString*)shortenURL:(NSString*)url;

@end
