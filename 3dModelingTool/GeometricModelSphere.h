//
//  GeometricModelSphere.h
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"

// GeometricModelSphere renders a sphere using OpenGL APIs.

@interface GeometricModelSphere : GeometricModel

@property(nonatomic, assign) double radius;


+(id)create;
+(id)createRadius:(double) radius;

-(id)init;
-(id)initRadius:(double)radius;

-(NSString *)description;
-(void)render:(GLenum)polygonMode color:(Color *)color;

@end
