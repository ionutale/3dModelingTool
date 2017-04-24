//
//  GraphicView.m
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GraphicView.h"
#import "GeometricModelAxes.h"
#import "GeometricModelVector.h"
#import "GeometricModelCube.h"
#import <OpenGL/gl.h>
#import <GLUT/glut.h>
#import <GLKit/GLKit.h>
#import "GizmoHandle.h"



//
// The following allows pinch-to-zoom on 10.5.x even though the magnification
// message of NSEvent wasn't officially supported until 10.6.
//
@interface NSEvent (GestureEvents)
-(CGFloat)magnification;
@end

@implementation GraphicView
#pragma mark - set self delegate
-(void)setDelegate:(id<GraphicViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}
#pragma mark - gizmo method delegate
-(float)viewPortRatio
{
    NSRect bounds = self.bounds;
    return  NSMidX(bounds) / NSMidY(bounds);
}

-(void)prepareOpenGL
{
    [self initializeModelView];
    // The prepareOpenGL: message may be received after some other
    // controller has received awakeFromNib: and synchronized the
    // GraphicView state with user interface controls.
    //
    // Therefor, only set state if it seems not to have been
    // initialized, already. Objective-C guarantees that ivars
    // are zero/nil/false after allocation, so that may indicate
    // absence of prior initialization.
    zCubePos = 0.0;
    cubeIsRotating = NO;

    if ([self polygonModel] == 0) {
        [self setPolygonModel:GL_LINE];
    }
    
    if ([self shadeModel] == 0) {
        [self setShadeModel:GL_FLAT];
    }
    
    if ([self backgroundColor] == nil) {
        [self setBackgroundColor:[Color createWhite:1.0 alpha:1.0]];
    }
    
    if ([self geometryColor] == nil) {
        [self setGeometryColor:[Color createWhite:0.5 alpha:1.0]];
    }
    
    if ([self axesModel] == nil) {
        [self setAxesModel:[GeometricModelAxes create]];
    }
    _translateZ = 0.0;
    matrixNR = 0.0;
    button = 0;
    //[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(drawRect:) userInfo:nil repeats:YES];

    _objectsInWorld = [NSMutableArray array];
    _gizmo = [Ghizmo create];
    [_gizmo setDelegate:self];
    _testPicking = [CustomModel create];
    [_testPicking setColor:[Color white]];
    GLKMatrix4 matrix = GLKMatrix4Identity;
    matrix.m[14] = -5;
    [_testPicking setMatrix:matrix];
    
    
    
}

-(void)clear
{
    [[self backgroundColor] applyToBackground];
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

-(void)drawRect:(NSRect)bounds
{
    
    GLenum polygonMode = [self polygonModel];
    
    [self activateContext];
    
    
    glEnable(GL_BLEND);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    
    GLfloat ambientLight[] = { 1.0, 1.0, 1.0, 1.0 };
    
    GLfloat lightPosition0 [] = { 10.0, 1.0, 1.0, 0.0 }; // directional source from position
    GLfloat lightAmbient0  [] = { 0.2, 0.2, 0.2, 1.0 };
    GLfloat lightDifuse0   [] = { 0.6, 0.6, 0.6, 1.0 };
    GLfloat lightSpecular0 [] = { 0.2, 0.2, 0.2, 1.0 };
    
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight);
    
    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition0);
    glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient0);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDifuse0);
    glLightfv(GL_LIGHT0, GL_SPECULAR, lightSpecular0);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glCullFace(GL_BACK);
    glShadeModel([self shadeModel]);
    
    [self clear];
    [[self axesModel] render:polygonMode color:nil];
        
    [[self directionModel] render:polygonMode color:[Color purple]];
    for (GeometricModel *customCube in _objectsInWorld) {
        [customCube render:polygonMode color:[self geometryColor]];
        //////NSLog(@"the objMatrix %@", NSStringFromGLKMatrix4(customCube.matrix));
    }
    [_testPicking renderTest];
    [_gizmo render];

    
    [self flushContext];
    [_delegate graphicViewUpdated];
}

-(void)reshape
{
    // The viewing frustum must be updated. The frustum is defined by
	// a field of view, a near clipping plane, and the distance to
	// the far clipping plane.
	//
	// In OpenGL, the viewing frustum looks down the -Z axis. The
	// +Y axis is up. The +X axis is to the right. The world is
	// translated and rotated in front of the frustum by means
	// of the model-view matrix.
	//
	// In general, it is not practical to incorporate the actual
	// characteristics of the physical computer display into the
	// frustum calculation: the visual may span multiple display
	// devices of varying dimension and resolution. In other
	// words, nothing can be assumed about the number of pixels
	// or the number of pixels per inch, because these
	// characteristics might vary across the logical viewport.
	//
	// Depth buffer precision is affected by the values specified for
	// zNear and zFar. Bits of lost depth buffer precision (L) is
	// approximately:
	//
	//     L = log2(zFar / zNear)
	//
	// The greater the ratio of zFar to zNear, the less effective
	// the depth buffer will be at distinguishing surfaces that are
	// near each other. Depth buffer effectiveness also declines if
	// zNear approaches zero.

    [self activateContext];
    
    NSRect bounds = [self bounds];
    
    GLint x = NSMinX(bounds);
    GLint y = NSMinY(bounds);
    GLsizei w = NSWidth(bounds);
    GLsizei h = NSHeight(bounds);
    
    glViewport(x, y, w, h); // Map OpenGL projection plane to NSWindow
    
    [[self cameraModel] applyProjection:bounds];
}

#pragma mark - add obj

-(void)addCube
{
    
    id obj = [CustomModel create];
    [obj setObjID:objects++];
    [obj setDesc:[NSString stringWithFormat:@"addedCube:%i", objects]];
    [obj setXPos:-2];
    [obj setZPos:-15];

    [_objectsInWorld addObject:obj];
    
    id obj2 = [CustomModel create];
    [obj2 setObjID:objects++];
    [obj2 setDesc:[NSString stringWithFormat:@"addedCube:%i", objects]];
    [obj2 setXPos:2];
    [obj2 setZPos:-10];
    
    [_objectsInWorld addObject:obj2];
    
    
    for (int i = 0; i < 36 ; i++) {
        float angle = GLKMathDegreesToRadians(10 * i);

        float sin = sinf(angle);
        float cos = cosf(angle);

        id obj3 = [CustomModel create];
        [obj3 setXPos:cos * 10];
        [obj3 setZPos:sin * 10];
        [_objectsInWorld addObject:obj3];
        
        id obj4 = [CustomModel create];
        [obj4 setYPos:cos * i];
        [obj4 setZPos:sin * i];
        [_objectsInWorld addObject:obj4];
        //
        id obj5 = [CustomModel create];
        [obj5 setXPos:cos * 8];
        [obj5 setYPos:sin * 8];
        [_objectsInWorld addObject:obj5];
    }
    
    // update the table view
    [_delegate updateObjectList:_objectsInWorld];
    [_delegate graphicViewUpdated];

    [self setNeedsDisplay:YES];
}

-(void)setCurrentObjectToGizmo:(CustomModel *)customObj
{
    [_gizmo setCurrentObject:customObj];
    [self setNeedsDisplay:YES];
}

-(void)initializeModelView
{
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslated(0.0, 0.0, -2.0);
   // glRotated(-90.0, 1.0, 0.0, 0.0);
   // glRotated(-90.0, 0.0, 0.0, 1.0);
   // glRotated(  5.0, 0.0, 1.0, 0.0);
   // glRotated( -5.0, 0.0, 0.0, 1.0);
    glGetFloatv(GL_MODELVIEW_MATRIX, _cameraPosition.m);

}

-(void)resetModelView
{
    [self activateContext];
    [self initializeModelView];
    [self setNeedsDisplay:YES];
}

-(void)activateContext
{
    [[self openGLContext] makeCurrentContext]; // Infinite loop if called within prepareOpenGL ?
}

-(void)flushContext
{
    [[self openGLContext] flushBuffer];
}


-(void)setPolygonModel:(GLenum)newValue
{
    _polygonModel = newValue;
    [self setNeedsDisplay:YES];
}



-(void)setShadeModel:(GLenum)newValue
{
    _shadeModel = newValue;
    [self setNeedsDisplay:YES];
}


-(void)setGeometricModel:(GeometricModel *)geometricModel
{
    _geometricModel = geometricModel;
    [self setNeedsDisplay:YES];
}

-(void)setAxesModel:(GeometricModel *)axesModel
{
    _axesModel = axesModel;
}

-(void)setDirectionModel:(GeometricModel *)directionModel
{
    _directionModel = directionModel;
    [self setNeedsDisplay:YES];
}

-(void)setCameraModel:(CameraModel *)cameraModel
{
    _cameraModel = cameraModel;
    [self reshape];
    [self setNeedsDisplay:YES];
}

-(void)setBackgroundColor:(Color *)color
{
    _backgroundColor = color;
    [self setNeedsDisplay:YES];
}

-(void)setGeometryColor:(Color *)color
{
    _geometryColor = color;
    [self setNeedsDisplay:YES];
}

-(BOOL)luminaireGeometryVisible
{
    return [self directionModel] != nil;
}

-(void)setLuminaireGeometryVisible:(BOOL)visible
{
    if (visible)
    {
        if (![self directionModel])
        {
             // FIXME - Redundant, hard-coded values must match light position!
            GLdouble from[] = {1.0, 1.0, 1.0};
            GLdouble to[]   = {0.1, 0.1, 0.1};
            GeometricModel *gmv = [GeometricModelVector createFrom:from to:to];
            [self setDirectionModel:gmv];
            [self setNeedsDisplay:YES];
        }
    }
    else
    {
        if ([self directionModel])
        {
            [self setDirectionModel:nil];
            [self setNeedsDisplay:YES];
        }
    }
}


#pragma mark - responder

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(GLdouble)modelViewMatrix:(int)index
{
   // if(_currentOBJ == NULL)
    if (YES)
    {
    GLdouble matrix[] =
    {
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 1
    };
    [self activateContext];
    glGetDoublev(GL_MODELVIEW_MATRIX, matrix);
    

    return matrix[index];
    }
    
    return _gizmo.currentObject.matrixGLK.m[index];
}

- (GLdouble) projectionMatrix: (int)index
{
    GLdouble matrix[] =
    {
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 1,
    };
    
    [self activateContext];
    
    glGetDoublev(GL_PROJECTION_MATRIX, matrix);

    return matrix[index];
}


-(void)rotateDeltaX:(GLdouble)dx deltaY:(GLdouble)dy
{

    GLdouble length = sqrt(dx*dx + dy*dy);
    GLdouble angle  = length;
    
    GLdouble vx = dx / length;
    GLdouble vy = dy / length;
    
    
    if (isnan(vx) ||
        isnan(vy))
        return;
    
    GLfloat modelViewMatrix[] =
    {
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
      [self activateContext];
    GLKMatrix4 storeMatrix = GLKMatrix4Identity;

    if (rotationType == 1) {
        glGetFloatv(GL_MODELVIEW_MATRIX, storeMatrix.m);
        glLoadIdentity();
    } else {
        glGetFloatv(GL_MODELVIEW_MATRIX, modelViewMatrix);
    }
    //
    // OpenGL uses the column vector convention with column-major memory layout:
    //
    //    [ 1 0 0 x ]    [  0  4  8  12 ]
    //    [ 0 1 0 y ]    [  1  5  9  13 ]
    //    [ 0 0 1 z ]    [  2  6  10 14 ]
    //    [ 0 0 0 1 ]    [  3  7  11 15 ]
    //
    glMatrixMode(GL_MODELVIEW);
    
    glRotated(-angle, // negativevalue for maverics gestures
               vx * modelViewMatrix[1] + vy * modelViewMatrix[0], // x
               vx * modelViewMatrix[5] + vy * modelViewMatrix[4], // y
               vx * modelViewMatrix[9] + vy * modelViewMatrix[8]);// z
    glMultMatrixf(storeMatrix.m);
   
    [self setNeedsDisplay:YES];
}

-(void)rotateDeltaTheta:(GLdouble)angleDegrees
{
    if (angleDegrees == 0) {
        return;
    }
    
    GLdouble angle = angleDegrees;
    
    GLdouble matrix[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    [self activateContext];
    
    glGetDoublev(GL_MODELVIEW_MATRIX, matrix);

    
    //
    // OpenGL uses the column vector convention with column-major memory layout:
    //
    //    [ 1 0 0 x ]    [  0  4  8  12 ]
    //    [ 0 1 0 y ]    [  1  5  9  13 ]
    //    [ 0 0 1 z ]    [  2  6  10 14 ]
    //    [ 0 0 0 1 ]    [  3  7  11 15 ]
    //
    
    glMatrixMode(GL_MODELVIEW);
    glRotated(angle, matrix[2], matrix[6], matrix[10]);

    [self setNeedsDisplay:YES];
}

-(void)zoomFactor:(GLdouble)factor
{
    
    //
    // OpenGL uses the column vector convention with column-major memory layout:
    //
    //    [ 1 0 0 x ]    [  0  4  8  12 ]
    //    [ 0 1 0 y ]    [  1  5  9  13 ]
    //    [ 0 0 1 z ]    [  2  6  10 14 ]
    //    [ 0 0 0 1 ]    [  3  7  11 15 ]
    //
    
    GLdouble matrix[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    [self activateContext];
    
    glGetDoublev(GL_MODELVIEW_MATRIX, matrix);
    
    // Invert the scale factor before applying it to the z-axis displacement
    // component of the matrix, so that a 'smaller scale' creates a larger
    // displacement from the camera.
    int matrixIndex = 14;
    matrix[matrixIndex] += (factor-1.0) * 2;
    //NSLog(@"factor %f", factor);
    
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixd(matrix);
    
    [self setNeedsDisplay:YES];
}

-(void)moveXAxies:(GLdouble)factor
{
    if (factor == 1) {
     //   return;
    }
    GLdouble matrix[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    [self activateContext];
    
    glGetDoublev(GL_MODELVIEW_MATRIX, matrix);
    
    // Invert the scale factor before applying it to the z-axis displacement
    // component of the matrix, so that a 'smaller scale' creates a larger
    // displacement from the camera.
    int matrixIndex = 12;
    matrix[matrixIndex] +=  (factor - 1.0) * 2;
    // FIXME - Inappropriate hard-coded value used to prevent zooming in
    //         'too far'.
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixd(matrix);
    
    [self setNeedsDisplay:YES];
}


-(void)moveYAxies:(GLdouble)factor
{
    if (factor == 1) {
        //   return;
    }
    GLdouble matrix[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    [self activateContext];
    
    glGetDoublev(GL_MODELVIEW_MATRIX, matrix);
    
    // Invert the scale factor before applying it to the z-axis displacement
    // component of the matrix, so that a 'smaller scale' creates a larger
    // displacement from the camera.
    int matrixIndex = 13;
    matrix[matrixIndex] -=  (factor - 1.0) * 10;

    // FIXME - Inappropriate hard-coded value used to prevent zooming in
    //         'too far'.
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixd(matrix);
    
    [self setNeedsDisplay:YES];
}

#pragma mark - zoom factor


-(void)zoomIn
{
    [self zoomFactor:1.1];
}

-(void)zoomOut
{
    [self zoomFactor:1.1];
}

-(void)keyDown:(NSEvent *)event
{
    NSUInteger modifierFlags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    
    
    if ([[event characters] compare:@"r"] == NSOrderedSame) {
        [self resetModelView];
    }
    if ([[event characters] compare:@"i"] == NSOrderedSame) {
        [self zoomIn];
    }
    if ([[event characters] compare:@"o"] == NSOrderedSame) {
        [self zoomOut];
    }
    
    if ([[event characters] compare:@"x"]) button = 1;
    if ([[event characters] compare:@"y"]) button = 2;
    if ([[event characters] compare:@"z"]) button = 3;

    // forward
    if (([event keyCode] == 13) & !(modifierFlags == NSCommandKeyMask)) {
        glLoadMatrixf([Matrix4x4 moveToForward:[self modelViewMatrix]].m);
        ////NSLog(@"moving forward");
    }
    // left
    if ([event keyCode] == 0) {
        glLoadMatrixf([Matrix4x4 moveToRight:[self modelViewMatrix]].m);
    }
    // backward
    if (([event keyCode] == 1) & !(modifierFlags == NSCommandKeyMask)) {
        glLoadMatrixf([Matrix4x4 moveToBackWard:[self modelViewMatrix]].m);
    }
    // rigth
    if ([event keyCode] == 2) {
        glLoadMatrixf([Matrix4x4 moveToLeft:[self modelViewMatrix]].m);
    }
    // up
    if (([event keyCode] == 13) & (modifierFlags == NSCommandKeyMask)) {
        glLoadMatrixf([Matrix4x4 moveToUp:[self modelViewMatrix]].m);
    }
    // down
    if (([event keyCode] == 1) & (modifierFlags == NSCommandKeyMask)) {
        glLoadMatrixf([Matrix4x4 moveToDown:[self modelViewMatrix]].m);
    }
   
    if (modifierFlags == NSAlternateKeyMask) {
        rotationType = 1;
    }
    
    [self setNeedsDisplay:YES];
}

-(void)keyUp:(NSEvent *)event
{
    NSUInteger modifierFlags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    if (modifierFlags == NSAlternateKeyMask) {
        rotationType = 0;
    }
}

-(void)mouseDragged:(NSEvent *)event
{
    NSPoint position = [self worldMouseLocation:[event locationInWindow]];
    NSRect bounds   = self.bounds;
    float ratio     = NSMidX(bounds) / NSMidY(bounds);

    switch (handleSelected) {
        case 1:
        {
            NSPoint convertedPosition = [self calculateMousePosition:[self subtractNewMousePosition:position withOldMousePosition:oldMousePosition] inZ:_gizmo.currentObject.matrix.m32 withAspect:ratio];
            _gizmo.currentObject.xPos = convertedPosition.x + currentObjectOldLocation.x; //  - 0.5;
        }
            break;
        case 2:
        {
            NSPoint convertedPosition = [self calculateMousePosition:[self subtractNewMousePosition:position withOldMousePosition:oldMousePosition] inZ:_gizmo.currentObject.matrix.m32 withAspect:ratio];
            _gizmo.currentObject.yPos = convertedPosition.y + currentObjectOldLocation.y; //  - 0.5;
        }
            break;
        case 3:
        {
            NSPoint convertedPosition = [self calculateMousePosition:[self subtractNewMousePosition:position withOldMousePosition:oldMousePosition] inZ:_gizmo.currentObject.matrix.m32 withAspect:ratio];
            _gizmo.currentObject.zPos = convertedPosition.x + currentObjectOldLocation.z; //  - 0.5;
        }
            break;
            
        default:
            [self.gizmo setCurrentObject:[self selectObjectInMousePosition:position]];
            
            break;
    }
    // nslog nothing here
    
    [self setNeedsDisplay:YES];
    
}
-(void)mouseDown:(NSEvent *)event
{
    NSPoint position = [self worldMouseLocation:[event locationInWindow]];
    oldMousePosition = position;
    currentObjectOldLocation = GLKVector3Make( _gizmo.currentObject.xPos,  _gizmo.currentObject.yPos, _gizmo.currentObject.zPos);
    ////NSLog(@"mouse down");

    if ([_gizmo isGizmoActive]) {
        handleSelected = [_gizmo mouseDownInPosition:position];
        if (handleSelected != 0) {
            [self setNeedsDisplay:YES];
            return;
        }
    }
    
    [self.gizmo setCurrentObject:[self selectObjectInMousePosition:position]];
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent*) event
{
    ////NSLog(@"mouse up");
    handleSelected = 0;
}

-(void)magnifyWithEvent:(NSEvent *)event
{
    CGFloat magnification = [event magnification];
    GLdouble factor = exp(magnification);
    [self zoomFactor:factor];
}

-(void)rotateWithEvent:(NSEvent *)event
{
    GLdouble angleDegrees = [event rotation];
    NSUInteger modifierFlags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;

    if (!modifierFlags) {
        [self rotateDeltaTheta:angleDegrees];
    }
}

- (void) swipeWithEvent: (NSEvent*)event
{
    ////NSLog(@"[GraphicView swipeWithEvent:%@", event);
}

- (void) scrollWheel: (NSEvent*) event
{
    NSUInteger modifierFlags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
    if ([event deltaZ]!= 0.0) {

    }
    if (!modifierFlags)
    {
        GLdouble dx = -[event deltaX];
        GLdouble dy = -[event deltaY];
    
        [self rotateDeltaX:dx deltaY:dy];
    }
    else if (modifierFlags == NSCommandKeyMask)
    {
        // There is probably a more sensible formula for converting
        // offset to a scale factor than this:

        [self setNeedsDisplay:YES];
        
        GLdouble offset = -[event deltaY];
        GLdouble factor = log(fabs(offset * 0.1) + M_E);
        if (offset > 0)
            factor = 2 - factor;
        //////NSLog(@"factor = %f", factor);
        
        [self zoomFactor:factor];
    }
    else if (modifierFlags == NSShiftKeyMask)
    {
        // There is probably a more sensible formula for converting
        // offset to a scale factor than this:
        
        [self setNeedsDisplay:YES];
        
        GLdouble offsetX = -[event deltaX];
        GLdouble factorX = log(fabs(offsetX * 0.1) + M_E);
        
        if (offsetX > 0)
            factorX = 2 - factorX;
        
        [self moveXAxies:factorX];
        
        GLdouble offsetY = -[event deltaY];
        GLdouble factorY = log(fabs(offsetY * 0.1) + M_E);
        
        if (offsetY > 0)
            factorY = 2 - factorY;

        [self moveYAxies:factorY];
    }
}


-(void)moveWorld
{
    GLdouble matrix[] =
    {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    [self activateContext];
    
    glGetDoublev(GL_MODELVIEW_MATRIX, matrix);
    
    // Invert the scale factor before applying it to the z-axis displacement
    // component of the matrix, so that a 'smaller scale' creates a larger
    // displacement from the camera.
    int matrixIndex = 14;
  //  matrix[matrixIndex] += (1.0 / factor);
    
    // FIXME - Inappropriate hard-coded value used to prevent zooming in
    //         'too far'.
    
    if (matrix[matrixIndex] > -2.0) {
        matrix[matrixIndex] = -2.0;
    }
    
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixd(matrix);
}

#pragma mark - mouse 2D cordonates conversion

-(NSPoint)worldMouseLocation:(NSPoint )mouseWindowPosition
{
    float x = mouseWindowPosition.x;
    float y = mouseWindowPosition.y;
    NSRect bounds = self.bounds;
    
    float windowWidth =  NSMidX(bounds) ;
    float windowHeigth  = NSMidY(bounds);

    NSPoint newCoordinate = NSMakePoint((x - windowWidth) / windowWidth, (y - windowHeigth) / windowHeigth);
    return newCoordinate;
}

-(void)setViewPort:(NSInteger)viewPort
{
    GLKMatrix4 curMatrix;
    glGetFloatv(GL_MODELVIEW_MATRIX, curMatrix.m);
    curMatrix.m00 = 1.0;
    curMatrix.m01 = 0.0;
    curMatrix.m02 = 0.0;
    
    curMatrix.m10 = 0.0;
    curMatrix.m11 = 1.0;
    curMatrix.m12 = 0.0;

    curMatrix.m20 = 0.0;
    curMatrix.m21 = 0.0;
    curMatrix.m22 = 1.0;
    glLoadMatrixf(curMatrix.m);

    switch (viewPort) {
        case 0:
            glRotatef(90, 1.0, 0.0, 0.0);
            break;
        case 1:
            glRotatef(90, 0.0, 1.0, 0.0);
            break;
        case 2:
            glRotatef(90, 0.0, 0.0, 1.0);
            break;
            
        default:
            ////NSLog(@"unknown view port selection");
            break;
    }
    [self setNeedsDisplay:YES];
}

#pragma mark -  get radians from world matrix

-(float)xWorldRotation
{
    GLKMatrix4 matrix = [self modelViewMatrix];
    return _xWorldRotation = atan2f(matrix.m12, matrix.m22);
}

-(float)yWorldRotation
{
    GLKMatrix4 matrix = [self modelViewMatrix];
    return _yWorldRotation = atan2f(-matrix.m02, sqrtf(matrix.m12 * matrix.m12 + matrix.m22 * matrix.m22));
}

-(float)zWorldRotation
{
    GLKMatrix4 matrix = [self modelViewMatrix];
    return _zWorldRotation = atan2f(matrix.m01, matrix.m00);
    
}

#pragma mark - get matrixes
-(GLKMatrix4)modelViewMatrix
{
    glGetFloatv(GL_MODELVIEW_MATRIX, _modelViewMatrix.m);
    return _modelViewMatrix;
}
-(GLKMatrix4)projectionMatrix
{
    glGetFloatv(GL_PROJECTION_MATRIX, _projectionMatrix.m);
    return _projectionMatrix;
}

#pragma mark -  object selection
-(CustomModel *)selectObjectInMousePosition:(NSPoint)mousePosition
{
    NSRect bounds   = self.bounds;
    float ratio     = NSMidX(bounds) / NSMidY(bounds); // a better aproach will be to invers the midX and midY for the ratio
    
    for (CustomModel *geometricModel in _objectsInWorld) {
        GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Identity;
        
        float z = geometricModel.matrix.m32;
        if (z < 0) {
        // generating the mouse coordinates
            float x = mousePosition.x * (-z * (0.36 * ratio))   - modelViewProjectionMatrix.m30;
            float y = mousePosition.y * (-z * 0.36)             - modelViewProjectionMatrix.m31;
            
            GLKMatrix4 newMatrixForGizmo = GLKMatrix4Make(1, 0, 0, 0,
                                                          0, 1, 0, 0,
                                                          0, 0, 1, 0,
                                                          x, y, z, 1);
            
            [_gizmo setMatrix:newMatrixForGizmo];
            [_testPicking setMatrix:newMatrixForGizmo];
            
            if ([self checkPointInCustomModel:geometricModel]) {
                ////NSLog(@"returning the geometric model");
                return geometricModel;
            }
        }
    }
    return nil;
}

#warning message - this breakpoint are to check if any of this methods are in use ?! the methods not in use it will be terminated
-(BOOL)checkRectFromCustomModel:(GeometricModel *)obj
{
    NSRect ocjRect   = NSMakeRect(obj.matrix.m30 - 0.25, obj.matrix.m31 - 0.25, 0.5, 0.5);
    NSRect mouseRect = NSMakeRect(_gizmo.matrix.m30 - 0.25, _gizmo.matrix.m31 - 0.25,  0.5, 0.5);
   return NSIntersectsRect(ocjRect, mouseRect);
}


-(BOOL)checkPointInCustomModel:(GeometricModel *)obj
{
    NSRect objRect   = NSMakeRect(obj.matrix.m30 - 0.25, obj.matrix.m31 - 0.25, 0.5, 0.5);
    NSPoint mouseRect = NSMakePoint(_gizmo.matrix.m30, _gizmo.matrix.m31 );
    return NSPointInRect(mouseRect, objRect);
}




-(BOOL)checkPointInGizmoHandle:(GizmoHandle *)gizmoHandle mouse3DPosition:(NSPoint)mousePosition
{
    NSRect objRect   = NSMakeRect(gizmoHandle.matrix.m30 , gizmoHandle.matrix.m31 - 0.05, 0.1, 0.1);;
    NSPoint mouseRect = NSMakePoint(_gizmo.matrix.m30, _gizmo.matrix.m31);
    return NSPointInRect(mouseRect, objRect);
}


-(NSPoint)calculateMousePosition:(NSPoint )mousePosition inZ:(float)z withAspect:(float)ratio
{
    float x = mousePosition.x * (-z * (0.36 * ratio));
    float y = mousePosition.y * (-z * 0.36);

    return NSMakePoint(x, y);
}

-(NSPoint)subtractNewMousePosition:(NSPoint)newMousePosition withOldMousePosition:(NSPoint)oldmousePosition
{
    return NSMakePoint(newMousePosition.x - oldmousePosition.x,newMousePosition.y - oldmousePosition.y);
}
/*
-(GLKVector3)gizmoPosition:(Ghizmo *)gizmoOBJ fromMouse:(GLKVector3)mousePosition
{
    
}
*/


@end
