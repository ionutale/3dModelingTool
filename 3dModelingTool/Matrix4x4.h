//
//  Matrix4x4.h
//  3dModelingTool
//
//  Created by AiU on 28/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Matrix4x4 : NSObject
{
    
}
@property (nonatomic, assign) GLKMatrix4 matrix;

-(id)initWithMatrix:(GLKMatrix4 )matrix;
+(id)initWithMatrix:(GLKMatrix4 )matrix;


-(GLKMatrix4)moveCameraInPosition:(GLKMatrix4 )matrix;

/** move forward this is multiplying the matrix with a vector3 *TODO: improve it , by translating based on the rotation* */
-(GLKMatrix4)moveToForward:(GLKMatrix4)worldMatrix;
+(GLKMatrix4)moveToForward:(GLKMatrix4)worldMatrix;
/** move rigth this is multiplying the matrix with a vector3 *TODO: improve it , by translating based on the rotation* */
-(GLKMatrix4)moveToRight:(GLKMatrix4)worldMatrix;
+(GLKMatrix4)moveToRight:(GLKMatrix4)worldMatrix;
/** move backward this is multiplying the matrix with a vector3 *TODO: improve it , by translating based on the rotation* */
-(GLKMatrix4)moveToBackWard:(GLKMatrix4)worldMatrix;
+(GLKMatrix4)moveToBackWard:(GLKMatrix4)worldMatrix;
/** move left this is multiplying the matrix with a vector3 *TODO: improve it , by translating based on the rotation* */
-(GLKMatrix4)moveToLeft:(GLKMatrix4)worldMatrix;
+(GLKMatrix4)moveToLeft:(GLKMatrix4)worldMatrix;

// move up
-(GLKMatrix4)moveToUp:(GLKMatrix4)worldMatrix;
+(GLKMatrix4)moveToUp:(GLKMatrix4)worldMatrix;
// move down
-(GLKMatrix4)moveToDown:(GLKMatrix4)worldMatrix;
+(GLKMatrix4)moveToDown:(GLKMatrix4)worldMatrix;
@end
