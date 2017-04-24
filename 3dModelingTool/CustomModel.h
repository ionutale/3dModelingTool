//
//  CustomModel.h
//  3dModelingTool
//
//  Created by AiU on 14/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"
#import <OpenGL/gl.h>
#import <GLKit/GLKit.h>
#import "Matrix4x4.h"
#import "Color.h"

@interface CustomModel : GeometricModel

@property (nonatomic, assign) GLint objID;

@property (nonatomic, assign) GLfloat xPos;
@property (nonatomic, assign) GLfloat yPos;
@property (nonatomic, assign) GLfloat zPos;

@property (nonatomic, assign) GLfloat xRot;
@property (nonatomic, assign) GLfloat yRot;
@property (nonatomic, assign) GLfloat zRot;
@property (nonatomic, assign) GLfloat angle;

@property (nonatomic, assign) GLfloat xAngle;
@property (nonatomic, assign) GLfloat yAngle;
@property (nonatomic, assign) GLfloat zAngle;

@property (nonatomic, assign) GLfloat xScale;
@property (nonatomic, assign) GLfloat yScale;
@property (nonatomic, assign) GLfloat zScale;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL debug;

/** testing some min and max for the colission */
@property (nonatomic, assign) float min;
@property (nonatomic, assign) float max;
// end test @property

@property (nonatomic, assign) GLKVector3 newPosition;
@property (nonatomic, strong) Matrix4x4 *objMatrix;
@property (nonatomic, assign) GLKMatrix4 matrixGLK;


@property (nonatomic, strong) NSMutableArray *verticesArray;
@property (nonatomic, strong) NSMutableArray *normalVertArray;
@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) Color *color;

+(id)create;
-(id)init;
-(void)renderMArray:(GLenum)polygonMode color:(Color *)color;
-(void)renderInIdenity;
-(void)renderTest;
-(void)logTheMatrix:(double *)matrix withdescription:(NSString *)description;

@end
