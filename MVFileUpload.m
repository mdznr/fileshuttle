//
//  MVFileUpload.m
//  FileShuttle
//
//  Created by Michael Villar on 12/10/11.
//

#import "MVFileUpload.h"

@implementation MVFileUpload

@synthesize destination			= destination_,
username			= username_,
password			= password_,
source				= source_,
delegate			= delegate_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[destination_ release];
	[username_ release];
	[password_ release];
	[source_ release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Public Methods

- (id)initWithDestination:(NSString *)destination
				 username:(NSString *)username
				 password:(NSString *)password
				   source:(NSURL *)source
				 delegate:(NSObject <MVFileUploadDelegate> *)delegate
{
	self = [super init];
	if ( self ) {
		destination_	= [destination retain];
		username_		= [username retain];
		password_		= [password retain];
		source_			= [source retain];
		delegate_		= delegate;
	}
	return self;
}

- (void)start
{
	
}

- (void)cancel
{
	
}

@end
