//
//  ViewController.m
//  Dropit
//
//  Created by Ryan on 2015/1/28.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
//@property (strong, nonatomic) UIGravityBehavior *gravity;
//@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) DropitBehavior *dropitBehavior;

//@property (weak, nonatomic) UIView *lastblock;

@end

@implementation ViewController



static const CGSize DROP_SIZE = { 40, 40 };



- (UIDynamicAnimator *)animator {
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        
        //delegate is an object that going to find out when the animator stops and when it start up again
        _animator.delegate = self;
    }
    return _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

- (bool)removeCompletedRows {
    
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height-DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width-DROP_SIZE.width/2; x += DROP_SIZE.width){
            
            //hittest will find the view nearest with the CGPoint
            UIView *hitView = [self.gameView hitTest:CGPointMake(x,y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
        return YES;
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove{
    [UIView animateWithDuration:3.0
                     animations:^(){
                         for (UIView *drop in dropsToRemove){
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5) - (int)self.gameView.bounds.size.width*2 );
                             int y = self.gameView.bounds.size.height;
                             //If someone changed the center, frame, alpha, transform. It will automatically animate
                             drop.center = (CGPointMake(x, -y));
                         }
                     }
                     completion:^(BOOL finished){
                         
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
    
}



- (DropitBehavior *)dropitBehavior {
    if(!_dropitBehavior) {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}


- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}



- (void)drop {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
   
    //[self.collider addItem:dropView];
    //[self.gravity addItem:dropView];
    [self.dropitBehavior addItem:dropView];

    
    //NSLog(@"center x : %f" , self.gameView.center.x);

}

- (UIColor *)randomColor {
    
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
