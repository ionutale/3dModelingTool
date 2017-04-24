//
//  Ghizmo.h
//  3dModelingTool
//
//  Created by AiU on 16/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModel.h"
#import "CustomModel.h"
#import "GizmoHandle.h"
#import "GeometricModelCone.h"

@protocol GizmoDelegate <NSObject>

-(float)viewPortRatio;

@end

@interface Ghizmo : GeometricModel
@property (nonatomic, strong) id<GizmoDelegate> delegate;



@property (nonatomic, assign) GLKMatrix4 objMatrix;
@property (nonatomic, assign) GLKMatrix4 gizmoMatrix;
@property (nonatomic, strong) NSMutableArray *verticesArray;
@property (nonatomic, strong) Color *color;
@property (nonatomic, strong) CustomModel *currentObject;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) float aspectRatio;

/** this has one cicle run delay for the correct values */
@property (nonatomic, assign) BOOL isGizmoActive;


@property (nonatomic, strong) NSArray *handles;
/** the x handle, in the gizmo TODO: delete one x from the handle */
@property (nonatomic, strong) GizmoHandle *xHandle;
/** the y handle, in the gizmo */
@property (nonatomic, strong) GizmoHandle *yHandle;
/** the z handle, in the gizmo */
@property (nonatomic, strong) GizmoHandle *zHandle;

@property (nonatomic, assign) GLKMatrix4 handleMatrix;



+(id)create;

-(id)init;

-(NSString *)description;
-(int)mouseDownInPosition:(NSPoint)position;



-(void)render;
@end
