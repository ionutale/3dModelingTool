//
//  GeometricModelAxes.h
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"

@interface GeometricModelAxes : GeometricModel


+(id)create;

-(id)init;

-(NSString *)description;

-(void)render:(GLenum) polygonMode color:(Color *)color;

@end
