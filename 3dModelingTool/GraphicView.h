//
//  GraphicView.h
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GLKit/GLKit.h>
#import "CameraModel.h"
#import "Color.h"
#import "GeometricModel.h"
#import "GeometricModelCube.h"
#import "CustomModel.h"
#import "Ghizmo.h"

// GraphicView overrides NSOpenGLView drawRect: in order to render a scene.
// GraphicView provides state and behavior to facilitate scene rendering.
// GraphicView manipulates viewpoint according to mouse, trackpad, or keyboard.
// In this application, GraphicView is regulated by MainWindowController.


@protocol GraphicViewDelegate <NSObject>

-(void)graphicViewUpdated;
-(void)updateObjectList:(NSArray *)objList;

@end

@interface GraphicView : NSOpenGLView <GizmoDelegate>
{
    GLfloat zCubePos;
    int matrixNR;
    
    // tempting the rotation with the pitagora teorem
    GLfloat rotation;
    BOOL cubeIsRotating;
    GLint objects;
    
    int button;
    
    int rotationType;
    int handleSelected;
    /** old mouse position, for moving the object in x and y coordinates */
    NSPoint oldMousePosition;
    /** old object(current selected object) position, for moving the object in x and y coordinates */
    GLKVector3 currentObjectOldLocation;

    
}

@property (nonatomic, assign) float xWorldRotation;
@property (nonatomic, assign) float yWorldRotation;
@property (nonatomic, assign) float zWorldRotation;

/** this is called for each frame that is beeing drawn: while transforming the modelViewMatrix */
@property (nonatomic, strong) id <GraphicViewDelegate> delegate;
@property (nonatomic, strong) CameraModel *cameraModel;

/** i should make use of geometric model, or create a class that has in it all the types of primitive objects, an empty object that will have only a matrix in it and when i create a new GameObject i will pass to it an array of vertices *like unity* */
/**  now that i hae the gizmo this is just staying in the performace way!!! */
@property (nonatomic, strong) Ghizmo *gizmo;

@property (nonatomic, strong) CustomModel *testPicking;
@property (nonatomic, strong) GeometricModelCube *testCube;
@property (nonatomic, strong) GeometricModel *geometricModel;
@property (nonatomic, strong) GeometricModel *axesModel;

@property (nonatomic, strong) NSMutableArray *objectsInWorld;
/** Luminaire Direction vetor*/
@property (nonatomic, strong) GeometricModel *directionModel;
/** current selected Obj */
//@property (nonatomic, strong) CustomModel *customModel;

@property (nonatomic, strong) Color *backgroundColor;
@property (nonatomic, strong) Color *geometryColor;

@property (nonatomic, assign) GLenum polygonModel;
@property (nonatomic, assign) GLenum shadeModel;

@property (nonatomic, assign) BOOL luminaireGeometryVisible;

@property (nonatomic, assign) GLfloat translateZ;

@property (nonatomic, assign) GLKMatrix4 modelViewMatrix;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
@property (nonatomic, assign) GLKMatrix4 cameraPosition;


- (void) prepareOpenGL;
 /** Make the associated OpenGL context current*/
- (void) activateContext;
/** Force execution of buffered OpenGL commands*/
- (void) flushContext;

- (void) clear;
/** Render the scene*/
- (void) drawRect: (NSRect) bounds;
/** Adjust the OpenGL viewport in response to window resize*/
- (void) reshape;
/** Access matrix; column-major order */
- (GLdouble) modelViewMatrix: (int)index;
/** Access matrix; column-major order*/
- (GLdouble) projectionMatrix: (int)index;

/** Corresponds to glPolygonMode(), GL_FILL, GL_LINE */
- (GLenum) polygonModel;
- (void) setPolygonModel: (GLenum) newValue;
/** Corresponds to glShadeModel(), GL_FLAT, GL_SMOOTH*/
- (GLenum) shadeModel;
- (void) setShadeModel: (GLenum) newValue;

/** Something to render*/
- (GeometricModel*) geometricModel;
- (void) setGeometricModel: (GeometricModel*) geometricModel;

/** Visualization of coordinate axes*/
- (GeometricModel*) axesModel;
- (void) setAxesModel: (GeometricModel*) axesModel;

/* Visualization of light direction*/
- (GeometricModel*) directionModel;
- (void) setDirectionModel: (GeometricModel*) directionModel;
/** Defines projection matrix (glFrustum/glOrtho)*/
- (CameraModel*) cameraModel;
- (void) setCameraModel: (CameraModel*) cameraModel;

/** Corresponds to glClearColor()*/
- (Color*) backgroundColor;
- (void) setBackgroundColor: (Color*) color;

/** Used to specify glMaterial()*/
- (Color*) geometryColor;
- (void) setGeometryColor: (Color*) color;

/** Render indication of light direction*/
- (BOOL) luminaireGeometryVisible;
- (void) setLuminaireGeometryVisible: (BOOL) visible;

/** Set camera/viewer to default*/
- (void) initializeModelView;
/** Return camera/viewer to default location/orientation*/
- (void) resetModelView;

/** Move the camera/viewer toward the scene by a quantum*/
- (void) zoomIn;
/** Move the camera/viewer away from the scene by a quantum*/
- (void) zoomOut;
/** Move the camera/viewer toward/away*/
- (void) zoomFactor: (GLdouble) factor;

/** Rotate around the vector defined by the model origin and the camera position.*/
- (void) rotateDeltaTheta: (GLdouble) angleDegrees;
/** Rotate geometry about its origin*/
- (void) rotateDeltaX: (GLdouble) dx
               deltaY: (GLdouble) dy;

/** Mouse scroll wheel movement*/
- (void) scrollWheel: (NSEvent*) event;
/** Trackpad swipe gesture*/
- (void) swipeWithEvent: (NSEvent*) event;
/** Trackpad twist gesture*/
- (void) rotateWithEvent: (NSEvent*) event;
/** Trackpad pinch gesture*/
- (void) magnifyWithEvent: (NSEvent*) event;
/** Mouse click-and-drag*/
- (void) mouseDragged: (NSEvent*) event;
/** Mouse button released*/
- (void) mouseUp: (NSEvent*) event;
/** Mouse button pressed*/
- (void) mouseDown: (NSEvent*) event;
/** Keyboard key pressed*/
- (void) keyDown: (NSEvent*) event;



-(void)addCube;
-(void)setViewPort:(NSInteger)viewPort;



@end
