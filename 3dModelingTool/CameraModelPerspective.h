//
//  CameraModelPerspective.h
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "CameraModel.h"

@interface CameraModelPerspective : CameraModel

+(id)create;

-(NSString *)description; // get user friendly name

-(void)applyProjection:(NSRect)bounds; // set OpenG projection


@end
