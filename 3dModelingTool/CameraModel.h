//
//  CameraModel.h
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraModel : NSObject

-(NSString *) description; // get user friendly name

-(void)applyProjection:(NSRect )bounds; // set OpenGL projection

@end
