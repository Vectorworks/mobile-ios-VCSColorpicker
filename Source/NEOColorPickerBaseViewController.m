#import "NEOColorPickerBaseViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation NEOColorPickerFavoritesManager {
    NSMutableOrderedSet *_favorites;
}

+ (NEOColorPickerFavoritesManager *) instance {
    static dispatch_once_t _singletonPredicate;
    static NEOColorPickerFavoritesManager *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    return _singleton;
}


- (id)init {
    if (self = [super init]) {
        
        NSFileManager *fs = [NSFileManager defaultManager];
        NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"neoFavoriteColors.data"];
        if ([fs isReadableFileAtPath:filename]) {
            _favorites = [[NSMutableOrderedSet alloc] initWithOrderedSet:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]];
        } else {
            _favorites = [[NSMutableOrderedSet alloc] init];
        }
    }
    
    return self;
}


+ (id) allocWithZone:(NSZone *)zone {
    return [self instance];
}


- (void)addFavorite:(UIColor *)color {
    [_favorites addObject:color];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_favorites];
    NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"neoFavoriteColors.data"];
    [data writeToFile:filename atomically:YES];
}


- (NSOrderedSet *)favoriteColors {
    return _favorites;
}

@end


@interface NEOColorPickerBaseViewController ()

@end

@implementation NEOColorPickerBaseViewController

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonPressCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonPressDone:)];
    self.preferredContentSize = CGSizeMake(320.0f, 460.0f);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait)
        {
            [self didRotate:nil];
        }
    }
}


- (IBAction)buttonPressCancel:(id)sender {
    [self.delegate colorPickerViewControllerDidCancel:self];
}


- (IBAction)buttonPressDone:(id)sender {
    [self.delegate colorPickerViewController:self didSelectColor:self.selectedColor];
}

-(CGRect)getFrameNextToLabel:(UILabel*)label
{
    CGRect nextToLabelFrame = CGRectMake((label.frame.origin.x + label.frame.size.width), label.frame.origin.y, 80, 40);
    return nextToLabelFrame;
}


- (void) setupShadow:(CALayer *)layer {
    layer.shadowColor = [UIColor clearColor].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOffset = CGSizeMake(0, 2);
    CGRect rect = layer.frame;
    rect.origin = CGPointZero;
    layer.shadowPath = [UIBezierPath bezierPath].CGPath;
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:layer.cornerRadius].CGPath;
}

- (void)updateForDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
}

-(void)repositionTheColorsPalette
{
}

-(void)didRotate:(NSNotification*)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    [self updateForDeviceOrientation:orientation animated:YES];
}

-(void)rotateView:(UIView*)rotatingView withDegrees:(CGFloat)degrees andOrientation:(UIDeviceOrientation)orientation
{
    rotatingView.transform = CGAffineTransformIdentity;
    rotatingView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    
    // Resize view for rotation
    CGFloat width = CGRectGetWidth(rotatingView.bounds);
    CGFloat height = CGRectGetHeight(rotatingView.bounds);
    if (width <= height)
    {
        width = MAX(CGRectGetWidth(rotatingView.bounds), CGRectGetHeight(rotatingView.bounds));
        height = MIN(CGRectGetWidth(rotatingView.bounds), CGRectGetHeight(rotatingView.bounds));
    }
    else
    {
        width = MIN(CGRectGetWidth(rotatingView.bounds), CGRectGetHeight(rotatingView.bounds));
        height = MAX(CGRectGetWidth(rotatingView.bounds), CGRectGetHeight(rotatingView.bounds));
    }
    
    CGSize newSize = CGSizeMake(width, height);
    
    CGRect viewBounds = rotatingView.bounds;
    viewBounds.size = newSize;
    rotatingView.bounds = viewBounds;
    
    CGRect viewFrame = rotatingView.frame;
    viewFrame.size = newSize;
    rotatingView.bounds = viewFrame;
}

@end
