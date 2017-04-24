//
//  MainViewController.h
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphicView.h"

// MainWindowController intermediates between GUI and OpenGL scene.


@interface MainWindowController : NSObject < NSTextDelegate, NSTextFieldDelegate, GraphicViewDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet id _resetViewpointToolbarItem;
    
    IBOutlet GraphicView* _graphicView; // Subclass of NSOpenGLView
    IBOutlet NSPanel* _statisticsView; // Provides view of OpenGL matrices
    IBOutlet NSPanel* _inspectorView;
    
    IBOutlet id _cameraModelArrayController; // Intermediary with NSPopUpButton
    IBOutlet id _geometricModelArrayController; // Intermediary with NSPopUpBut
    IBOutlet id _polygonModelArrayController; // Intermediary with NSPopUpButton
    IBOutlet id _shadeModelArrayController; // Intermediary with NSPopUpButton
    
    NSMutableArray* _cameraModelArray; // Available OpenGL projection models
	NSMutableArray* _geometricModelArray; // Available OpenGL geometry models
    NSMutableArray* _polygonModelArray; // Available OpenGL polygon draw models
    NSMutableArray* _shadeModelArray; // Available OpenGL shade models
    
    NSColor* _backgroundColor; // To specify the OpenGL clear color
    NSColor* _geometryColor; // To specify OpenGL material properties
    BOOL _luminaireGeometryVisible; // To reveal direction of OpenGL light
    BOOL _statisticsVisible; // Whether the statistics panel is on screen
    BOOL _inspectorVisible;
}

//@property (nonatomic, assign) BOOL inspectorVisible;
@property (weak) IBOutlet NSSegmentedControl *viewPortSelection;
- (IBAction)viewportSelection:(id)sender;

@property (strong) IBOutlet NSTableView *allObjectsTableView;
@property (strong) NSMutableArray *allObjectsMutableArray;


- (id) init;

- (void) awakeFromNib;

- (IBAction) cameraModelChanged: (id) sender; // Notifies GraphicView
- (IBAction) geometricModelChanged: (id) sender;  // Notifies GraphicView
- (IBAction) polygonModelChanged: (id) sender; // Notifies GraphicView
- (IBAction) shadeModelChanged: (id) sender; // Notifies GraphicView
- (IBAction) backgroundColorChanged: (id) sender; // Notifies GraphicView
- (IBAction) geometryColorChanged: (id) sender; // Notifies GraphicView
- (IBAction) luminaireGeometryVisibleChanged: (id) sender; // Notifies GraphicView

- (IBAction) addCube: (id) sender; // Delegates to GraphicView

- (IBAction) resetViewpoint: (id) sender; // Delegates to GraphicView
- (IBAction) zoomIn: (id) sender; // Delegates to GraphicView
- (IBAction) zoomOut: (id) sender; // Delegates to GraphicView

- (NSColor*) backgroundColor; // Intermediary with GraphicView
- (IBAction) setBackgroundColor: (NSColor*) color;

- (NSColor*) geometryColor; // Intermediate with GraphicView
- (IBAction) setGeometryColor: (NSColor*) color;

- (BOOL) luminaireGeometryVisible; // Intermediate with GraphicView
- (void) setLuminaireGeometryVisible: (BOOL) visible;

- (unsigned int) countOfCameraProjections; // KVC for NSArrayController Content
- (id) objectInCameraProjectionsAtIndex: (unsigned int)index;
- (void) insertObject: (id)anObject inCameraProjectionsAtIndex: (unsigned int)index;
- (void) removeObjectFromCameraProjectionsAtIndex: (unsigned int)index;
- (void) replaceObjectInCameraProjectionsAtIndex: (unsigned int)index withObject: (id)anObject;

- (unsigned int)countOfGeometricModels; // KVC for NSArrayController Content
- (id)objectInGeometricModelsAtIndex:(unsigned int)index;
- (void)insertObject:(id)anObject inGeometricModelsAtIndex:(unsigned int)index;
- (void)removeObjectFromGeometricModelsAtIndex:(unsigned int)index;
- (void)replaceObjectInGeometricModelsAtIndex:(unsigned int)index withObject:(id)anObject;

- (unsigned int) countOfPolygonModels; // KVC for NSArrayController Content
- (id) objectInPolygonModelsAtIndex: (unsigned int)index;
- (void) insertObject: (id)anObject inPolygonModelsAtIndex: (unsigned int)index;
- (void) removeObjectFromPolygonModelsAtIndex: (unsigned int)index;
- (void) replaceObjectInPolygonModelsAtIndex: (unsigned int)index withObject: (id)anObject;

- (unsigned int) countOfShadeModels; // KVC for NSArrayController Content
- (id) objectInShadeModelsAtIndex: (unsigned int)index;
- (void) insertObject: (id)anObject inShadeModelsAtIndex: (unsigned int)index;
- (void) removeObjectFromShadeModelsAtIndex: (unsigned int)index;
- (void) replaceObjectInShadeModelsAtIndex: (unsigned int)index withObject: (id)anObject;

- (BOOL) isStatisticsVisible; // KVC to synchronize Statistics Panel visibility
- (void) setStatisticsVisible:(BOOL) visible;
- (BOOL) isInspectorVisible;
- (void) setInspectorVisible:(BOOL) visible;

- (NSString*) modelViewMatrix: (int)index; // Delegate to GraphicView
- (NSString*) projectionMatrix: (int)index; // Delegate to GraphicView

#pragma mark - stepper iboutles

@property (nonatomic, strong) IBOutlet NSStepper *stepperPositionX;
@property (nonatomic, strong) IBOutlet NSStepper *stepperPositionY;
@property (nonatomic, strong) IBOutlet NSStepper *stepperPositionZ;

@property (nonatomic, strong) IBOutlet NSStepper *stepperRotationX;
@property (nonatomic, strong) IBOutlet NSStepper *stepperRotationY;
@property (nonatomic, strong) IBOutlet NSStepper *stepperRotationZ;

@property (nonatomic, strong) IBOutlet NSStepper *stepperScaleX;
@property (nonatomic, strong) IBOutlet NSStepper *stepperScaleY;
@property (nonatomic, strong) IBOutlet NSStepper *stepperScaleZ;

/** object description : see CustomModel.h */
@property (weak) IBOutlet NSTextField *objDescriptionTextField;

#pragma mark - inspector options

/* position textField */
@property (nonatomic, strong) IBOutlet NSTextField *textFieldPositionX;
@property (nonatomic, strong) IBOutlet NSTextField *textFieldPositionY;
@property (nonatomic, strong) IBOutlet NSTextField *textFieldPositionZ;
/* position textField */
@property (nonatomic, strong) IBOutlet NSTextField *textFieldRotationX;
@property (nonatomic, strong) IBOutlet NSTextField *textFieldRotationY;
@property (nonatomic, strong) IBOutlet NSTextField *textFieldRotationZ;
/* position textField */
@property (nonatomic, strong) IBOutlet NSTextField *textFieldScaleX;
@property (nonatomic, strong) IBOutlet NSTextField *textFieldScaleY;
@property (nonatomic, strong) IBOutlet NSTextField *textFieldScaleZ;

@property (nonatomic, strong) IBOutlet NSView *stepperAndTextFieldViewParrent;

- (IBAction)stepperAction:(NSStepper *)sender;



@property (weak) IBOutlet NSBox *boxModelViewMatrix;
@property (weak) IBOutlet NSBox *boxProjectionMatrix;





@end
