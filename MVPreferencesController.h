//
//  MVPreferencesController.h
//  FileShuttle
//
//  Created by Michael Villar on 8/15/11.
//

#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "MTZColoredBackgroundView.h"

@interface MVPreferencesController : NSObject <NSTextFieldDelegate> {
	BOOL showDockIcon_;
	NSTimer *passwordTimer_;
	NSWindow *window_;
	NSSecureTextField *passwordTextField_;
	NSPopUpButton *showInPopUpButton_;
	SRRecorderControl *clipboardRecorderControl_;
	IBOutlet NSPanel *URLShortenerProtocolInfomationWindow;
	IBOutlet MTZColoredBackgroundView *informationWindowBackgroundView;
	IBOutlet NSTextField *URLShortenerProtocolXMLExpectedOutputTextField;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSView *generalView;
@property (assign) IBOutlet NSView *advancedView;
@property (assign) IBOutlet NSSecureTextField *passwordTextField;
@property (assign) IBOutlet NSPopUpButton *showInPopUpButton;
@property (assign) IBOutlet SRRecorderControl *clipboardRecorderControl;

- (IBAction)toolbarItemAction:(id)sender;
- (IBAction)protocolChanged:(id)sender;
- (IBAction)passwordChanged:(id)sender;
- (IBAction)showInPopUpButtonChanged:(id)sender;
- (IBAction)showURLShortenerInfo:(id)sender;

@end
