//
//  NSString+MD5.h
//  FileShuttle
//
//  Created by Michaël on 26/04/11.
//

#import <Foundation/Foundation.h>
#import <openssl/md5.h>

@interface NSString (MD5)

- (NSString*)md5;

@end
