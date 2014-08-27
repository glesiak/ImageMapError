//
//  ViewController.m
//  ImageMapError
//
//  Created by macbook on 26/08/14.
//
//

#import "ViewController.h"

#define SATCarSideRear 0
#define SATCarSideFront 1

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *carSideControl;
@property (weak, nonatomic) IBOutlet MTImageMapView *carImageMapView;
@property (weak, nonatomic) IBOutlet UIButton *carPartSelectButton;

@property (nonatomic,strong) NSArray * carFrontPartsNamesArray;
@property (nonatomic,strong) NSArray * carFrontPartsCoordinates;
@property (nonatomic,strong) NSMutableArray * carFrontPartsCondition;
@property (nonatomic,strong) NSMutableArray * carFrontPartsRemarks;

@property (nonatomic,strong) NSArray * carRearPartsNamesArray;
@property (nonatomic,strong) NSArray * carRearPartsCoordinates;
@property (nonatomic,strong) NSMutableArray * carRearPartsCondition;
@property (nonatomic,strong) NSMutableArray * carRearPartsRemarks;
@property (nonatomic,assign) NSInteger currentCarPartIndex;

- (void) setupData;
- (void) setupControls;

/* Other methods */
- (void) selectCarPartAtIndex: (NSInteger) carPartIndex;

/* Event handlers */
- (IBAction) carSideChanged: (UISegmentedControl*) sender;

@end

@implementation ViewController


#pragma mark Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self setupControls];
}

#pragma mark Controller Setup

- (void) setupData
{
    [self loadCarMapData];
    [self initConditionData];
}

- (void) loadCarMapData
{
    self.carFrontPartsNamesArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                                                     pathForResource:@"carFrontPartsNames" ofType:@"plist"]];
    self.carFrontPartsCoordinates = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                                                      pathForResource:@"carFrontPartsCoordinates" ofType:@"plist"]];
    
    self.carRearPartsNamesArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                                                    pathForResource:@"carRearPartsNames" ofType:@"plist"]];
    self.carRearPartsCoordinates = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                                                     pathForResource:@"carRearPartsCoordinates" ofType:@"plist"]];
}

- (void) setupControls
{
    
    [self.carSideControl removeAllSegments];
    [self.carSideControl insertSegmentWithTitle: @"Rückseite" atIndex: SATCarSideRear animated: NO];
    [self.carSideControl insertSegmentWithTitle: @"Vorderseite" atIndex: SATCarSideFront animated: NO];
    [self.carSideControl setSelectedSegmentIndex: SATCarSideRear];
    [self carSideChanged: self.carSideControl];
}

- (void) initConditionData
{
    self.carFrontPartsCondition = [NSMutableArray arrayWithCapacity: 21];
    self.carFrontPartsRemarks = [NSMutableArray arrayWithCapacity: 0];
    self.carRearPartsCondition = [NSMutableArray arrayWithCapacity: 21];
    self.carRearPartsRemarks = [NSMutableArray arrayWithCapacity: 0];
}

#pragma mark Action handlers

- (IBAction) carSideChanged: (UISegmentedControl*) sender
{
    [self selectCarPartAtIndex: 0];
    
    switch ( self.carSideControl.selectedSegmentIndex )
    {
        case SATCarSideFront:
        {
            [self.carImageMapView setImage: [UIImage imageNamed: @"carFront300.png"]];
            [self.carImageMapView setMapping: self.carFrontPartsCoordinates
                                   doneBlock:^(MTImageMapView *imageMapView)
             {
                 DLog(@"Car front parts are all mapped");
             }];
            break;
        }
        default:
        case SATCarSideRear:
        {
            [self.carImageMapView setImage: [UIImage imageNamed: @"carRear300.png"]];
            [self.carImageMapView setMapping: self.carRearPartsCoordinates
                                   doneBlock:^(MTImageMapView *imageMapView)
             {
                 DLog(@"Car rear parts are all mapped");
             }];
            break;
        }
    }
}

#pragma mark Helper Methods

- (void) selectCarPartAtIndex: (NSInteger) carPartIndex
{
    DLog( @"car part selected %ld", (long)carPartIndex );
    
    NSArray * carSidePartNames;
    if ( self.carSideControl.selectedSegmentIndex==SATCarSideFront )
    {
        carSidePartNames = self.carFrontPartsNamesArray;
    }
    else if ( self.carSideControl.selectedSegmentIndex==SATCarSideRear )
    {
        carSidePartNames = self.carRearPartsNamesArray;
    }
    NSString * partName = [carSidePartNames objectAtIndex: self.currentCarPartIndex];
    
    self.currentCarPartIndex = carPartIndex;
    [self.carPartSelectButton setTitle: partName forState: UIControlStateNormal];
    [self.carPartSelectButton setTitle: partName forState: UIControlStateSelected];
    [self.carPartSelectButton setTitle: partName forState: UIControlStateHighlighted];
}

#pragma mark MapView Delegate

-(void)imageMapView:(MTImageMapView *)inImageMapView didSelectMapArea:(NSUInteger)inIndexSelected
{
    NSInteger carPartIndex = inIndexSelected;
    [self selectCarPartAtIndex: carPartIndex];
}

@end
