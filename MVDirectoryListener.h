//
//  MVDirectoryListener.h
//  FileShuttle
//
//  Created by Michaël on 26/04/11.
//

#import <Foundation/Foundation.h>

@protocol MVDirectoryListenerDelegate;

@interface MVDirectoryListener : NSObject {
@private
  BOOL listening;
	NSString *path;
	NSString *extension;
	NSDate *date;
	NSObject <MVDirectoryListenerDelegate> *delegate;
}

@property (assign, nonatomic) BOOL listening;
@property (readonly) NSString *path;
@property (retain) NSString *extension;
@property (assign) NSObject <MVDirectoryListenerDelegate> *delegate;

- (id)initWithPath:(NSString*)aPath;

@end

@protocol MVDirectoryListenerDelegate

- (void)directoryListener:(MVDirectoryListener*)aDirectoryListener
                  newFile:(NSString*)filename;

@end