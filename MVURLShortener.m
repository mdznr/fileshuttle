//
//  MVURLShortener.m
//  FileShuttle
//
//  Created by Michael Villar on 12/11/11.
//

#import "MVURLShortener.h"

@implementation MVURLShortener

- (NSString*)shortenURL:(NSString*)url
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *shttleUrl = [NSString stringWithFormat:
						   @"%@?action=shorten&longUrl=%@",
						   [defaults stringForKey:@"url_shortener_url"],
						   url];
	NSString *doc = [NSString stringWithContentsOfURL:[NSURL URLWithString:shttleUrl]
											 encoding:NSUTF8StringEncoding error:nil];
	if ( doc == nil ) return nil;
	
	NSString *shortenedUrl = nil;
	BOOL matched = [doc getCapturesWithRegexAndReferences:@"\\<shortUrl\\>(.*)\\<\\/shortUrl\\>",
					@"${1}", &shortenedUrl, nil];
	if ( matched ) return shortenedUrl;
	
	return nil;
}

@end
