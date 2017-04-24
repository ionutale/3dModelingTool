//
//  GeometricModel.m
//  3dModelingTool
//
//  Created by AiU on 09/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"

@implementation GeometricModel
@synthesize matrix = _matrix;

-(instancetype)init
{
    if (self = [super init]) {
        _matrix = GLKMatrix4Identity;
        _desc = @"";
        
    }
    return self;
}

/*-(void)setDescription:(NSString *)description
{
    if (description != _description){
        _description = description;
    }
}
 */
/*
-(NSString *)description
{
    return nil;
    // override in subclass
}
*/
-(void)render:(GLenum)polygonMode color:(Color *)color
{
    // Intentionally left blank.
    // Override in subclass.
 
}

-(GLKMatrix4)matrix
{
    return _matrix;
}

-(void)setMatrix:(GLKMatrix4)matrix
{
        _matrix = matrix;
}

@end
