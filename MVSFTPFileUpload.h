//
//  MVSFTPFileUpload.h
//  FileShuttle
//
//  Created by Michael Villar on 12/13/11.
//

#import "MVFileUpload.h"
#import <RegexKit/RegexKit.h>

@interface MVSFTPFileUpload : MVFileUpload {
	pid_t scppid_;
	int masterfd_;
}

@end
