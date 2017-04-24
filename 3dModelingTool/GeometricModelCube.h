//
//  GeometricModelCube.h
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"

// GeometricModelCube renders a cube using OpenGL APIs.

@interface GeometricModelCube : GeometricModel

@property (nonatomic, assign) GLfloat xPos;
@property (nonatomic, assign) GLfloat yPos;
@property (nonatomic, assign) GLfloat zPos;


+(id)create;

-(id)init;

-(NSString *)description;

-(void)render:(GLenum)polygonMode color:(Color *)color;
-(void)render:(GLenum)polygonMode color:(Color *)color andZ:(GLfloat)z;

@end
