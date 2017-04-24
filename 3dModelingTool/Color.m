//
//  Color.m
//  3dModelingTool
//
//  Created by AiU on 09/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "Color.h"
#import <stdarg.h>
#import <OpenGL/gl.h>

@implementation Color

#pragma mark - class methods

+(id)create
{
    return [[Color alloc] init];
}

+(id)createColor:(NSColor *)color
{
    return [[Color alloc] initColor:color];
}

+(id)createWhite:(GLfloat)white alpha:(GLfloat)alpha
{
    NSColor *c = [NSColor colorWithCalibratedWhite:white alpha:alpha];
    return [[Color alloc] initColor:c];
}

+(id)createRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha
{
    NSColor *c = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
    return [Color createColor:c];
}

+(id)white
{
    return [Color createWhite:1.0 alpha:1.0];
}

+(id)black
{
    return [Color createWhite:0.0 alpha:1.0];
}

+(id)red
{
    return [Color createRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}

+(id)green
{
    return [Color createRed:0.0 green:1.0 blue:0.0 alpha:1.0];
}

+(id)blue
{
    return [Color createRed:0.0 green:0.0 blue:1.0 alpha:1.0];
}

+(id)yellow
{
    return [Color createRed:1.0 green:1.0 blue:0.0 alpha:1.0];
}

+(id)magenta
{
    return [Color createRed:1.0 green:0.0 blue:1.0 alpha:1.0];
}

+(id)purple
{
    return [Color createRed:0.37 green:0.0 blue:0.37 alpha:1.0];
}

#pragma mark - instance methods

-(id)init
{
    if (self = [super init]) {
        // FIXME - determine correct way to hadle colorspaces with OpenGL
        
        _value = [NSColor colorWithCalibratedWhite:0.5 alpha:0.9];
    }
    return self;
}

-(id)initColor:(NSColor *)color
{
    if (self  = [super init]) {
        // FIXME - determine correct way to hadle colorspaces with OpenGL
        _value = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    }
    return self;
}

-(NSColor *)value
{
    return _value;
}

-(void)applyToBackground
{
    NSColor *color = [self value];
    glClearColor(
                 [color redComponent],
                 [color greenComponent],
                 [color blueComponent],
                 [color alphaComponent]);
}

-(void)applyToColor
{
    NSColor *color = [self value];
    glColor4f(
              [color redComponent],
              [color greenComponent],
              [color blueComponent],
              [color alphaComponent]
              );
}

-(void)applyToBack:(GLenum)material
{
    [self applyToFace:GL_BACK material:material];
}

-(void) applyToFront:(GLenum)material
{
    [self applyToFace:GL_FRONT material:material];
}



-(void)applyToFaces:(GLenum)material
{
    [self applyToFace:GL_FRONT_AND_BACK material:material];
}

-(void)applyToFace:(GLenum)face material:(GLenum)material
{
    NSColor *color = [self value];
    
    GLfloat vector[4];
    vector[0] = [color redComponent];
    vector[1] = [color greenComponent];
    vector[2] = [color blueComponent];
    vector[3] = [color alphaComponent];
    
    glMaterialfv(face, material, vector);
}

-(void)applytoFace:(GLenum)face, ...
{
    va_list args; /// va_list and va_start is like a "primitive" loop, only that it takes the "array" from the function atributes
    va_start(args, face);
    
    [self applyToColor];
    
    GLenum material;
    
    while ((material = va_arg(args, GLenum))) {
        [self applyToFace:face material:material];
    }
    
    va_end(args);
}

-(void)apply:(GLenum)material, ...
{
    va_list args;
    va_start(args, material);
    
    [self applyToColor];
    [self applyToFaces:material];
    
    GLenum m;
    while ((m = va_arg(args, GLenum))) {
        [self applyToFaces:m];
    }
    
    va_end(args);
}


@end
