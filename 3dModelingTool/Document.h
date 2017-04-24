//
//  Document.h
//  Game Builder
//
//  Created by Ion Utale on 4/10/13.
//  Copyright (c) 2013 AiU. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface Document : NSDocument <NSOpenSavePanelDelegate>
{
    //•• properties!
    IBOutlet NSView     *saveDialogCustomView;
    IBOutlet NSButton   *soundOnCheck;
    IBOutlet NSButton   *appendCheck;
    IBOutlet NSButton   *navigatePackages;
}

@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NSData *docData;

@property (strong) IBOutlet NSSavePanel *savePanel;

@end
