//
//  MVSFTPFileUpload.m
//  FileShuttle
//
//  Created by Michael Villar on 12/13/11.
//

#import "MVSFTPFileUpload.h"
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/file.h>
#include <sys/ioctl.h>
#include <sys/param.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <util.h>
#include "sshversion.h"

@interface MVSFTPFileUpload ()

@property (assign) pid_t scppid;
@property (assign) int masterfd;

- (void)write:(char *)buf;
- (void)parseProgressOutputString:(NSString *)line;

@end

@implementation MVSFTPFileUpload

extern int	errno;
extern char	**environ;
int scpconnecting = 0;

@synthesize scppid		= scppid_,
            masterfd	= masterfd_;

#pragma mark -
#pragma mark Private Methods

- (void)start
{
	if([self.delegate respondsToSelector:@selector(fileUploadDidStartUpload:)])
		[self.delegate fileUploadDidStartUpload:self];
	
	[NSThread detachNewThreadSelector:@selector(startFromThread) toTarget:self withObject:nil];
}

- (void)startFromThread
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSURL *url = [NSURL URLWithString:self.destination];
	NSString *path = url.relativePath;
	path = [path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
	NSString *userathostString = [NSString stringWithFormat:@"%@@%@:%@",
                                self.username, url.host, path];
	char* userathost = (char*)[userathostString UTF8String];
	char* password = (char*)[self.password UTF8String];
	int portnumber = [url.port intValue];
	char* localfile = (char*)[[self.source path] UTF8String];
	int scpType = 0;
	
	fd_set		readmask;
  FILE		*mfp;
  int			copying = 0;
  int			status, pwsent = 0, validpw = 0, noscp = 0, loading = 0;
	char		ttyname[ MAXPATHLEN ];
  unichar		buf[ MAXPATHLEN ];
  char		executable[ MAXPATHLEN], *execargs[ 7 ];
  NSString		*scpBinary;
	
	scpBinary = @"/usr/bin/scp";
  strcpy( executable, [ scpBinary UTF8String ] );
  execargs[ 0 ] = executable;
	
  scpconnecting = 1;
	
	char* portarg = (char*)[[[NSNumber numberWithInt:portnumber]stringValue]UTF8String];
	
//execargs[ 1 ] = "-r";
//execargs[ 1 ] = "-q";
  execargs[ 1 ] = "-P";
  execargs[ 2 ] = portarg;
  execargs[ 3 ] = ( scpType == 0 ? localfile : userathost );
  execargs[ 4 ] = ( scpType == 0 ? userathost : localfile );
  execargs[ 5 ] = NULL;
  
	NSString *line;
	
  if ((self.scppid = forkpty( &masterfd_, ttyname, NULL, NULL ))) {
    if ( fcntl( self.masterfd, F_SETFL, O_NONBLOCK ) < 0 ) {	/* prevent master from blocking */
    }
    
    if (( mfp = fdopen( self.masterfd, "r" )) == NULL ) {
			[self performSelectorOnMainThread:@selector(error:)
                             withObject:@"fdopen master fd returned NULL"
                          waitUntilDone:YES];
			return;
    }
    setvbuf( mfp, NULL, _IONBF, 0 );
    
    for ( ;; ) {
      NSAutoreleasePool	*pool = [[ NSAutoreleasePool alloc ] init ];
			FD_ZERO( &readmask );
      FD_SET( self.masterfd, &readmask );
      if ( select( self.masterfd + 1, &readmask, NULL, NULL, NULL ) < 0 ) {
				[self performSelectorOnMainThread:@selector(error:)
                               withObject:@"select() returned a value less than zero"
                            waitUntilDone:YES];
				return;
      }
      
      if ( FD_ISSET( self.masterfd, &readmask )) {
        if ( fgets(( char * )buf, MAXPATHLEN, mfp ) == NULL ) break;
        
				line = [NSString stringWithCString:(char*)buf encoding:NSASCIIStringEncoding];
				
        if (( strstr(( char * )buf, "Password:" ) != NULL
             || strstr(( char * )buf, "password:" ) != NULL
             || strstr(( char * )buf, "passphrase" ) != NULL )
            && !validpw ) {
					// Send password
					[self write:password];
          pwsent = 1;
        }
				else if ( strchr(( char * )buf, '%' ) != NULL ) {
					loading += 1;
					// Loading informations
          if ( ! copying ) {
            copying = 1;
          } else {
            [ self parseProgressOutputString: line];
          }
        }
				else {
					if([line length] > 5 && loading == 0) {
						[self performSelectorOnMainThread:@selector(error:)
                                   withObject:line
                                waitUntilDone:YES];
						return;
					}
				}
        
        
        memset(( char * )buf, '\0', strlen(( char * )buf ));
        [ pool release ];
        if ( noscp ) break;
      }
    }
		
    self.scppid = wait( &status );
		
		if ( fclose( mfp ) != 0 ) {
			NSLog(@"fclose failed: %s", strerror( errno ));
		}
		( void )close( self.masterfd );
		
		
    if ( WIFEXITED( status )) {
      // Normal exit
    } else if ( WIFSIGNALED( status )) {
      NSLog(@"Exit with signal = %d\n", status);
    } else if ( WIFSTOPPED( status )) {
			NSLog(@"WIFSTOPPED\n");
    }
    
    self.scppid = 0;
  } else if ( self.scppid < 0 ) {
    NSLog( @"forkpty failed: %s", strerror( errno ));
  } else {
    execve( executable, ( char ** )execargs, environ );
		[self performSelectorOnMainThread:@selector(error:)
                           withObject:@"execve failed"
                        waitUntilDone:YES];
		return;
  }
	
	[pool release];
	
	if([self.delegate respondsToSelector:@selector(fileUploadDidSuccess:)])
		[self.delegate performSelectorOnMainThread:@selector(fileUploadDidSuccess:)
                                    withObject:self
                                 waitUntilDone:NO];
}

- (void)error:(NSString*)error {
	if([self.delegate respondsToSelector:@selector(fileUpload:didFailWithError:)])
		[self.delegate fileUpload:self
             didFailWithError:error];
}

- (void)write:(char *)buf
{
  int	wr;
  if (( wr = write( self.masterfd, buf, strlen( buf ))) != strlen( buf ))
	{
		[self performSelectorOnMainThread:@selector(error:)
                           withObject:@"error"
                        waitUntilDone:YES];
		return;
	}
  if (( wr = write( self.masterfd, "\n", strlen( "\n" ))) != strlen( "\n" ))
	{
		[self performSelectorOnMainThread:@selector(error:)
                           withObject:@"error"
                        waitUntilDone:YES];
		return;
	}
}

- (void)parseProgressOutputString:(NSString *)line
{
	if ([self.delegate respondsToSelector:@selector(fileUpload:didChangeProgression:
                                                  bytesRead:totalBytes:)])
	{
		NSString *percent = nil;
		BOOL matched = [line getCapturesWithRegexAndReferences:@"( *)([0-9]*)%( *)", @"${2}",
                    &percent, nil];
		
		if(matched) {
			[self.delegate fileUpload:self
           didChangeProgression:[percent floatValue] / 100
                      bytesRead:-1
                     totalBytes:-1];
		}
	}
}

@end
