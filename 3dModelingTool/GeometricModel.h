//
//  GeometricModel.h
//  3dModelingTool
//
//  Created by AiU on 09/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Color.h"



@interface GeometricModel : NSObject

@property (nonatomic, assign) NSRect boundingBox;
@property (nonatomic, assign) GLKMatrix4 matrix;
@property (nonatomic, weak ) NSString *description;
@property (nonatomic, strong) NSString *desc;

-(void)render:(GLenum) polygonMode color:(Color *)color;


@end
