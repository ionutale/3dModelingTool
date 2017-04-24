//
//  CameraModelOrthographic.h
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "CameraModel.h"

@interface CameraModelOrthographic : CameraModel

+(id)create;

-(NSString *)description;// Get user-friendly name

-(void)applyProjection:(NSRect)bounds; // Set OpenGL projection

@end
