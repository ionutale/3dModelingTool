//
//  GizmoHandle.h
//  3dModelingTool
//
//  Created by AiU on 18/05/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"
#import "Color.h"
#import "GeometricModelCone.h"
@interface GizmoHandle : GeometricModel
/** the returning tag:
 1 = x
 2 = y
 3 = z */

@property (nonatomic, assign) int tag;
@property (nonatomic, strong) Color *color;
@property (nonatomic, strong) GeometricModelCone *cone;
@property (nonatomic, assign) NSRect boundingBox;

+(id)create;
-(id)init;

-(void)render;


@end
