//
//  GeometricModelVector.h
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"

@interface GeometricModelVector : GeometricModel
{
    GLdouble _from[3];
    GLdouble _to[3];
}

+(id)createFrom: (GLdouble *)a to: (GLdouble *)b;
-(id)  initFrom: (GLdouble *)a to: (GLdouble *)b;

-(NSString *)description;

-(void)render:(GLenum)polygonMode color:(Color *)color;


@end
