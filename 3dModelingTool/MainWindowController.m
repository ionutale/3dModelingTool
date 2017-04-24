//
//  MainViewController.m
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "MainWindowController.h"
#import "CameraModelPerspective.h"
#import "CameraModelOrthographic.h"
#import "GeometricModelCone.h"
#import "GeometricModelCube.h"
#import "GeometricModelSphere.h"
#import "PolygonModel.h"
#import "ShadeModel.h"
#import "Ghizmo.h"
#import "CustomModel.h"
#import "GeometricModel.h"

#define X_POSITION 1
#define Y_POSITION 2
#define Z_POSITION 3

#define X_ROTATION 4
#define Y_ROTATION 5
#define Z_ROTATION 6

#define X_SCALE 7
#define Y_SCALE 8
#define Z_SCALE 9



@implementation MainWindowController
// setting the 3 view port views
- (IBAction)viewportSelection:(id)sender {
    NSSegmentedControl *sc = (NSSegmentedControl *) sender;
    [_graphicView setViewPort:[sc selectedSegment]];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _cameraModelArray = [NSMutableArray arrayWithCapacity:0] ;
        [_cameraModelArray addObject:[CameraModelPerspective create]];
        [_cameraModelArray addObject:[CameraModelOrthographic create]];
        
        _geometricModelArray = [NSMutableArray arrayWithCapacity:0] ;
        [_geometricModelArray addObject:[GeometricModelSphere create]];
        [_geometricModelArray addObject:[GeometricModelCone create]];
        [_geometricModelArray addObject:[GeometricModelCube create]];
        [_geometricModelArray addObject:[Ghizmo create]];
        
        _polygonModelArray = [NSMutableArray arrayWithCapacity:0];
        [_polygonModelArray addObject:[PolygonModel createFill]];
        [_polygonModelArray addObject:[PolygonModel createLine]];
        
        _shadeModelArray = [NSMutableArray arrayWithCapacity:0] ;
        [_shadeModelArray addObject:[ShadeModel createFlat]];
        [_shadeModelArray addObject:[ShadeModel createSmooth]];
        
        
        _backgroundColor = [NSColor colorWithCalibratedRed:0.3 green:0.5 blue:0.9 alpha:0.8];
        _geometryColor = [NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.0 alpha:0.8];
        _luminaireGeometryVisible = YES;
        
        _allObjectsMutableArray = [NSMutableArray array];
        
        _statisticsVisible = NO;
        _inspectorVisible  = NO;
        
    }
	return self;
}

- (void) awakeFromNib
{
    [self cameraModelChanged:self];
    [self geometricModelChanged:self];
    [self polygonModelChanged:self];
    [self shadeModelChanged:self];
    [self backgroundColorChanged:self];
    [self geometryColorChanged:self];
    [self luminaireGeometryVisibleChanged:self];
    
    // XXX - Cope with 10.5.x Cocoa defect involving PDF-based image templates:
    //
    //       When the image is first loaded in the user interface, transparent
    //       areas, such as the background, are improperly painted white.
    //       Such a white background remains until an event forces the image to
    //       be redrawn.
    //
    //       Manually sending setAlpha: on NSImageRep objects seems to prevent
    //       the inappropriate white background from ever appearing. This
    //       defect is reported on the Internet, but it seems to be obscure,
    //       perhaps due to infrequent use of PDF-based image templates circa
    //       Mac OS X 10.5.
    //
    for (id imageRep in [[_resetViewpointToolbarItem image] representations])
        //[imageRep setAlpha:YES];
    
    [self setMatrixViewValues];
    [_graphicView setDelegate:self];

    // The following line of code causes NSColorPanel instances to support
    // transparency, unless directed otherwise:
    
    [NSColor setIgnoresAlpha:NO];
}

#pragma  mark - graphic view delegate
-(void)graphicViewUpdated
{
    [self setCustomObjPropreties];
}

- (IBAction) cameraModelChanged: (id) sender
{
	////////NSLog(@"Camera Model: %@", [[_cameraModelArrayController selectedObjects] objectAtIndex:0]);
    CameraModel* cameraModel = [[_cameraModelArrayController selectedObjects] objectAtIndex:0];
    [_graphicView setCameraModel:cameraModel];
}

- (IBAction) geometricModelChanged: (id) sender
{
	////////NSLog(@"Geometric Model: %@", [[_geometricModelArrayController selectedObjects] objectAtIndex:0]);
    GeometricModel* geometricModel = [[_geometricModelArrayController selectedObjects] objectAtIndex:0];
    [_graphicView setGeometricModel:geometricModel];
}
- (IBAction) polygonModelChanged: (id) sender
{
	////////NSLog(@"Polygon Model: %@", [[_polygonModelArrayController selectedObjects] objectAtIndex:0]);
    PolygonModel* polygonModel = [[_polygonModelArrayController selectedObjects] objectAtIndex:0];
    [_graphicView setPolygonModel:[polygonModel value]];
}

- (IBAction) shadeModelChanged: (id) sender
{
	////////NSLog(@"Shade Model: %@", [[_shadeModelArrayController selectedObjects] objectAtIndex:0]);
    ShadeModel* shadeModel = [[_shadeModelArrayController selectedObjects] objectAtIndex:0];
    [_graphicView setShadeModel:[shadeModel value]];
}

- (IBAction) backgroundColorChanged: (id) sender
{
	////////NSLog(@"Background Color: %@", [self backgroundColor]);
    //[_graphicView setBackgroundColor:[self backgroundColor]];
    [_graphicView setBackgroundColor:[Color createColor:[self backgroundColor]]];
}

- (IBAction) geometryColorChanged: (id) sender
{
	////////NSLog(@"Geometry Color: %@", [self geometryColor]);
    //[_graphicView setGeometryColor:[self geometryColor]];
    [_graphicView setGeometryColor:[Color createColor:[self geometryColor]]];
}

- (IBAction) luminaireGeometryVisibleChanged: (id) sender
{
	////////NSLog(@"Luminaire Geometry Visible: %hhd", [self luminaireGeometryVisible]);
    [_graphicView setLuminaireGeometryVisible:[self luminaireGeometryVisible]];
}


#pragma mark - add new obj

-(IBAction)addCube:(id)sender
{
    [_graphicView addCube];
}

#pragma mark - not my stuff :D

- (IBAction) resetViewpoint: (id) sender
{
    [_graphicView resetModelView];
}

- (void) zoomIn: (id) sender
{
    [_graphicView zoomIn];
}

- (void) zoomOut: (id) sender
{
    [_graphicView zoomOut];
}

- (NSColor*) backgroundColor;
{
    return _backgroundColor;
}

- (void) setBackgroundColor: (NSColor*) color
{
    _backgroundColor = color;
    [self backgroundColorChanged:self];
}

- (BOOL) luminaireGeometryVisible
{
    return _luminaireGeometryVisible;
}

- (void) setLuminaireGeometryVisible: (BOOL) visible
{
    _luminaireGeometryVisible = visible;
    [self luminaireGeometryVisibleChanged:self];
}

- (NSColor*) geometryColor
{
    return _geometryColor;
}

- (void) setGeometryColor: (NSColor*) color
{
    _geometryColor = color;
    [self geometryColorChanged:self];
}

- (unsigned int) countOfCameraProjections
{
    return (unsigned int) [_cameraModelArray count];
}

- (id) objectInCameraProjectionsAtIndex: (unsigned int)index
{
    return [_cameraModelArray objectAtIndex:index];
}

- (void) insertObject: (id)anObject inCameraProjectionsAtIndex: (unsigned int)index
{
    [_cameraModelArray insertObject:anObject atIndex:index];
}

- (void) removeObjectFromCameraProjectionsAtIndex: (unsigned int)index
{
    [_cameraModelArray removeObjectAtIndex:index];
}

- (void) replaceObjectInCameraProjectionsAtIndex: (unsigned int)index
                                      withObject: (id)anObject
{
    [_cameraModelArray replaceObjectAtIndex:index withObject:anObject];
}

- (unsigned int) countOfGeometricModels
{
    return (unsigned int) [_geometricModelArray count];
}

- (id)objectInGeometricModelsAtIndex:(unsigned int)index
{
    return [_geometricModelArray objectAtIndex:index];
}

- (void)insertObject:(id)anObject inGeometricModelsAtIndex:(unsigned int)index
{
    [_geometricModelArray insertObject:anObject atIndex:index];
}

- (void)removeObjectFromGeometricModelsAtIndex:(unsigned int)index
{
    [_geometricModelArray removeObjectAtIndex:index];
}

- (void)replaceObjectInGeometricModelsAtIndex:(unsigned int)index
                                   withObject:(id)anObject
{
    [_geometricModelArray replaceObjectAtIndex:index withObject:anObject];
}

- (unsigned int) countOfPolygonModels
{
    return (unsigned int) [_polygonModelArray count];
}

- (id) objectInPolygonModelsAtIndex: (unsigned int)index
{
    return [_polygonModelArray objectAtIndex:index];
}

- (void) insertObject: (id)anObject inPolygonModelsAtIndex: (unsigned int)index
{
    [_polygonModelArray insertObject:anObject atIndex:index];
}

- (void) removeObjectFromPolygonModelsAtIndex: (unsigned int)index
{
    [_polygonModelArray removeObjectAtIndex:index];
}

- (void) replaceObjectInPolygonModelsAtIndex: (unsigned int)index
                                  withObject: (id)anObject
{
    [_polygonModelArray replaceObjectAtIndex:index withObject:anObject];
}

- (unsigned int) countOfShadeModels
{
    return (unsigned int) [_shadeModelArray count];
}

- (id) objectInShadeModelsAtIndex: (unsigned int)index
{
    return [_shadeModelArray objectAtIndex:index];
}

- (void) insertObject: (id)anObject inShadeModelsAtIndex: (unsigned int)index
{
    ////////NSLog(@"inserting obj in shadeModel at index:%i", index);
    [_shadeModelArray insertObject:anObject atIndex:index];
}

- (void) removeObjectFromShadeModelsAtIndex: (unsigned int)index
{
    [_shadeModelArray removeObjectAtIndex:index];
}

- (void) replaceObjectInShadeModelsAtIndex: (unsigned int)index
                                withObject: (id)anObject
{
    [_shadeModelArray replaceObjectAtIndex:index withObject:anObject];
}


- (void) toggleStatisticsVisibility: (id) sender
{
    if ([_statisticsView isVisible])
        [_statisticsView close];
    else
    {
        [self willChangeValueForKey:@"statisticsVisible"];
        [_statisticsView makeKeyAndOrderFront:self];
        [self didChangeValueForKey:@"statisticsVisible"];
    }
}

- (BOOL) isStatisticsVisible
{
    return _statisticsVisible;
}

- (void) setStatisticsVisible: (BOOL) visible
{
    [self willChangeValueForKey:@"statisticsVisible"];
    _statisticsVisible = visible;
    [self didChangeValueForKey:@"statisticsVisible"];
}
/// inspector view
- (void) toggleInspectorVisible: (id) sender
{
    if ([_inspectorView isVisible])
        [_inspectorView close];
    else
    {
        [self willChangeValueForKey:@"inspectorVisible"];
        [_inspectorView makeKeyAndOrderFront:self];
        [self didChangeValueForKey:@"inspectorVisible"];
    }
}

-(BOOL)isInspectorVisible
{
    return _inspectorVisible;
}

-(void)setInspectorVisible:(BOOL)visible
{
    [self willChangeValueForKey:@"inspectorVisible"];
    _inspectorVisible = visible;
    [self didChangeValueForKey:@"inspectorVisible"];
}


- (NSString*) modelViewMatrix: (int)index
{
    return [NSString stringWithFormat:@"%lf", [_graphicView modelViewMatrix:index]];
}

- (NSString*) projectionMatrix: (int)index
{
    return [NSString stringWithFormat:@"%lf", [_graphicView projectionMatrix:index]];
}

#pragma mark - matrix setter
-(void)setMatrixViewValues
{
    NSArray *matrixFields = [[[_boxModelViewMatrix subviews] objectAtIndex:0] subviews];
    NSArray *projectionMatrix = [[[_boxProjectionMatrix subviews] objectAtIndex:0] subviews];
    
    for (int i = 0; i < 16; i++) {
        NSTextField *textField = [matrixFields objectAtIndex:i];
        [textField setStringValue:[self modelViewMatrix:(int)textField.tag - 110]];

        NSTextField *textFild2 = [projectionMatrix objectAtIndex:i];
        [textFild2 setStringValue:[self projectionMatrix:(int)textFild2.tag - 210]];

    }
    
}

#pragma mark - customObj settings

-(void)setCustomObjPropreties
{
    [self setMatrixViewValues];
    /*
    // setting the value to textField
    [_textFieldPositionX setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] xPos]]];
    [_textFieldPositionY setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] yPos]]];
    [_textFieldPositionZ setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] zPos]]];
    
    [_textFieldRotationX setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] xAngle]]];
    [_textFieldRotationY setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] yAngle]]];
    [_textFieldRotationZ setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] zAngle]]];
  
    [_textFieldScaleX setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] xScale]]];
    [_textFieldScaleY setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] yScale]]];
    [_textFieldScaleZ setStringValue:[NSString stringWithFormat:@"%f", [[_graphicView currentOBJ] zScale]]];
    //obj description
    [_objDescriptionTextField setStringValue:[NSString stringWithFormat:@" %@",[[_graphicView currentOBJ] description]]];

    // setting the value to the stepper
    [_stepperPositionX setDoubleValue:[_textFieldPositionX doubleValue]];
    [_stepperPositionY setDoubleValue:[_textFieldPositionY doubleValue]];
    [_stepperPositionZ setDoubleValue:[_textFieldPositionZ doubleValue]];

    [_stepperRotationX setDoubleValue:[_textFieldRotationX doubleValue]];
    [_stepperRotationY setDoubleValue:[_textFieldRotationY doubleValue]];
    [_stepperRotationZ setDoubleValue:[_textFieldRotationZ doubleValue]];

    [_stepperScaleX setDoubleValue:[_textFieldScaleX doubleValue]];
    [_stepperScaleY setDoubleValue:[_textFieldScaleY doubleValue]];
    [_stepperScaleZ setDoubleValue:[_textFieldScaleZ doubleValue]];
    
    [self setMatrixViewValues];
     */
}

#pragma mark - panel setings/options

- (IBAction)stepperAction:(NSStepper *)sender
{
    switch (sender.tag) {
        case X_POSITION:
            [_textFieldPositionX setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case Y_POSITION:
            [_textFieldPositionY setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case Z_POSITION:
            [_textFieldPositionZ setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case X_ROTATION:
            [_textFieldRotationX setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case Y_ROTATION:
            [_textFieldRotationY setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case Z_ROTATION:
            [_textFieldRotationZ setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case X_SCALE:
            [_textFieldScaleX setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case Y_SCALE:
            [_textFieldScaleY setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
        case Z_SCALE:
            [_textFieldScaleZ setStringValue:[NSString stringWithFormat:@"%f", [sender floatValue]]];
            break;
            
        default:
            break;
    }
    /*
    
    [self setCustomObjPosition:[_textFieldPositionX floatValue]
                             y:[_textFieldPositionY floatValue]
                             z:[_textFieldPositionZ floatValue]];
    
    [self setCustomObjRotation:[_textFieldRotationX floatValue]
                             y:[_textFieldRotationY floatValue]
                             z:[_textFieldRotationZ floatValue]];
    
    [self setCustomObjScale:[_textFieldScaleX floatValue]
                          y:[_textFieldScaleY floatValue]
                          z:[_textFieldScaleZ floatValue]];*/
}


-(void)textDidChange:(NSNotification *)notification
{
    ////////NSLog(@"this is a notification from NSTextDelegate method in the window controller");
}

- (void)controlTextDidChange:(NSNotification *)notification
{/*
    [self setCustomObjPosition:[_textFieldPositionX floatValue]
                             y:[_textFieldPositionY floatValue]
                             z:[_textFieldPositionZ floatValue]];
    
    [self setCustomObjRotation:[_textFieldRotationX floatValue]
                             y:[_textFieldRotationY floatValue]
                             z:[_textFieldRotationZ floatValue]];
    
    [self setCustomObjScale:[_textFieldScaleX floatValue]
                          y:[_textFieldScaleY floatValue]
                          z:[_textFieldScaleZ floatValue]];
   // [[_graphicView currentOBJ] setDescription:[_objDescriptionTextField stringValue]];
    [self setCustomObjPropreties]; */
}
/*
#pragma mark - current Obj position
-(void)setCustomObjPosition:(float)x y:(float)y z:(float)z
{
    [[_graphicView currentOBJ] setXPos:x];
    [[_graphicView currentOBJ] setYPos:y];
    [[_graphicView currentOBJ] setZPos:z];
    [_graphicView setNeedsDisplay:YES];
}

#pragma mark - current obj rotation
-(void)setCustomObjRotation:(float)x y:(float)y z:(float)z
{
    [[_graphicView currentOBJ] setXAngle:x];
    [[_graphicView currentOBJ] setYAngle:y];
    [[_graphicView currentOBJ] setZAngle:z];
    [_graphicView setNeedsDisplay:YES];
}

#pragma mark - current Obj Scale
-(void)setCustomObjScale:(float)x y:(float)y z:(float)z
{
    [[_graphicView currentOBJ] setXScale:x];
    [[_graphicView currentOBJ] setYScale:y];
    [[_graphicView currentOBJ] setZScale:z];
    [_graphicView setNeedsDisplay:YES];
}
*/


#pragma mark - NSTableView delegate/datasource methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [_allObjectsMutableArray count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    CustomModel *customOBJ = [_allObjectsMutableArray objectAtIndex:row];
    return customOBJ.description;  //[dictionary objectForKey:[tableColumn identifier]];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    ////NSLog(@"the cell is beiing edited");
    return YES;
}
// inca case i have more than one coumn this is the way to do it
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}
// clicked row
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    ////NSLog(@"should select row");
   // [_graphicView setCurrentOBJ:[_allObjectsMutableArray objectAtIndex:row]];
    return YES;
}
// _graphics view delegating the update table
-(void)updateObjectList:(NSArray *)objList
{
   // ////NSLog(@"is this ever called");
    _allObjectsMutableArray = nil;
    _allObjectsMutableArray = [NSMutableArray arrayWithArray:objList];
    [_allObjectsTableView reloadData];
}

@end
