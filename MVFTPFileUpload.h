//
//  MVFTPFileUpload.h
//  FileShuttle
//
//  Created by Michael Villar on 12/10/11.
//

#import <Foundation/Foundation.h>
#import "MVFileUpload.h"
#import "MVFileUploadDelegate.h"
#define kMyBufferSize  32768

@interface MVFTPFileUpload : MVFileUpload {
	CFWriteStreamRef writeStream_;
	CFReadStreamRef readStream_;
	long fileSize_;
	long totalBytesWritten_;
	long leftOverByteCount_;
	UInt8 buffer[kMyBufferSize];
}


@end
