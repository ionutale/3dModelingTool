//
//  InspectorPanel.h
//  3dModelingTool
//
//  Created by AiU on 07/05/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InspectorPanel : NSSplitView


@property (nonatomic, strong) IBOutlet NSView *canvasView;
@property (nonatomic, strong) IBOutlet NSView *inspectorView;
@end
