//
//  Color.h
//  3dModelingTool
//
//  Created by AiU on 09/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject
{
    
}

@property (nonatomic, strong) NSColor *value;

+(id)create;
+(id)createColor:(NSColor *)color;
+(id)createWhite:(GLfloat)white alpha:(GLfloat)alpha;
+(id)createRed:(GLfloat) red green:(GLfloat) green blue:(GLfloat) blue alpha:(GLfloat)alpha;
+(id)white;
+(id)black;
+(id)red;
+(id)green;
+(id)blue;
+(id)yellow;
+(id)magenta;
+(id)purple;

-(id)init;
-(id)initColor:(NSColor *)color;


-(NSColor *)value;

-(void)applyToBackground;
-(void)applyToColor;
-(void)applyToBack:(GLenum)material;
-(void)applyToFront:(GLenum)material;
-(void)applyToFaces: (GLenum)material;
-(void)applyToFace:(GLenum)face material:(GLenum)material;
-(void)applytoFace:(GLenum)face, .../**material */; //color & ...
-(void)apply:(GLenum )material, .../** material*/; //color & both faces

@end
