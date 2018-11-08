#import "NEOColorPickerFavoritesViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface NEOColorPickerFavoritesViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) CALayer *selectedColorLayer;
@property (nonatomic, strong) NSMutableArray *colorLayers;
@property (nonatomic, strong) NSMutableArray *bgColorLayers;
@property (nonatomic, assign) CGRect selectedColorLabelBaseFrame;
@property (nonatomic, assign) CGRect scrollViewBaseFrame;
@property (nonatomic, assign) CGRect doneButtonBaseFrame;

@end

@implementation NEOColorPickerFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorLayers = [NSMutableArray array];
    self.bgColorLayers = [NSMutableArray array];
    
    self.selectedColorLabel.frame = CGRectMake(20, 10, 130, 40);
    self.selectedColorLabelBaseFrame = self.selectedColorLabel.frame;
    self.scrollView.frame = CGRectMake(0, 65, 320, 360);
    self.scrollViewBaseFrame = self.scrollView.frame;
    self.doneButton.frame = CGRectMake(240, 0, 80, 65);
    self.doneButtonBaseFrame = self.doneButton.frame;
    
    self.selectedColorLabel.numberOfLines = 5;
    if (self.selectedColorText.length != 0) {
        self.selectedColorLabel.text = self.selectedColorText;
    }
    if (self.doneButtonText.length != 0) {
        [self.doneButton setTitle:self.doneButtonText forState:UIControlStateNormal];
    }
    
    self.selectedColoerFrame = [self getFrameNextToLabel:self.selectedColorLabel]; //CGRectMake(130, 16, 100, 40);
    UIImageView *checkeredView = [[UIImageView alloc] initWithFrame:self.selectedColoerFrame];
    checkeredView.layer.cornerRadius = 6.0;
    checkeredView.layer.masksToBounds = YES;
    checkeredView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorPicker.bundle/color-picker-checkered"]];
    [self.centeredView addSubview:checkeredView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.selectedColoerFrame;
    layer.cornerRadius = 6.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.8;
    
    [self.centeredView.layer addSublayer:layer];
    self.selectedColorLayer = layer;
    self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
    
    [self repositionTheColorsPalette];
    
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.scrollView addGestureRecognizer:recognizer];
}


- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.scrollView];
    int page = point.x / (CGRectGetWidth(self.scrollView.bounds));
    int delta = (int)point.x % ((int)CGRectGetWidth(self.scrollView.bounds));
    
    int row = (int)((point.y - 8) / 48);
    int column = (int)((delta - 8) / 78);
    int index = 24 * page + row * 4 + column;
    
    if (index < [[NEOColorPickerFavoritesManager instance].favoriteColors count])
    {
        self.selectedColor = [[NEOColorPickerFavoritesManager instance].favoriteColors objectAtIndex:index];
        self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
        [self.selectedColorLayer setNeedsDisplay];
        if ([self.delegate respondsToSelector:@selector(colorPickerViewController:didChangeColor:)]) {
            [self.delegate colorPickerViewController:self didChangeColor:self.selectedColor];
        }
    }
}


- (IBAction)pageValueChange:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(self.pageControl.currentPage * CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds)) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateForDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
    CGFloat degrees = 0.0f;
    switch (orientation)
    {
        case UIDeviceOrientationLandscapeLeft:
            degrees = 90.0f;
            break;
        case UIDeviceOrientationLandscapeRight:
            degrees = -90.0f;
            break;
        case UIDeviceOrientationPortrait:
            degrees = 0.0f;
            break;
        default:
            return;
            break;
    }
    
    CGFloat duration = (animated) ? [UIApplication sharedApplication].statusBarOrientationAnimationDuration : 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        // Rotate view
        [self rotateView:self.scrollView withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.selectedColorLabel withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.doneButton withDegrees:degrees andOrientation:orientation];
        
    } completion:^(BOOL finished){[self repositionTheColorsPalette];}];
}

-(CGRect)getBaseViewFrameForView:(UIView*)view
{
    if (view == self.selectedColorLabel)
    {
        return self.selectedColorLabelBaseFrame;
    }
    if (view == self.scrollView)
    {
        return self.scrollViewBaseFrame;
    }
    if (view == self.doneButton)
    {
        return self.doneButtonBaseFrame;
    }
    
    return view.frame;
}

-(void)rotateView:(UIView*)rotatingView withDegrees:(CGFloat)degrees andOrientation:(UIDeviceOrientation)orientation
{
    rotatingView.transform = CGAffineTransformIdentity;
    rotatingView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    
    CGRect baseRect = [self getBaseViewFrameForView:rotatingView];
    CGFloat width = CGRectGetWidth(baseRect);
    CGFloat height = CGRectGetHeight(baseRect);
    if (degrees != 0)
    {
        // Resize view for rotation
        width = CGRectGetHeight(baseRect);
        height = CGRectGetWidth(baseRect);
    }
    CGSize newSize = CGSizeMake(width, height);
    
    CGRect viewBounds = rotatingView.bounds;
    viewBounds.size = newSize;
    rotatingView.bounds = viewBounds;
    
    CGRect viewFrame = rotatingView.frame;
    viewFrame.size = newSize;
    rotatingView.bounds = viewFrame;
}

-(void)repositionTheColorsPalette
{
    [UIView animateWithDuration:0.1 animations:^{
        for (UIImageView *bgView in self.bgColorLayers)
        {
            [bgView removeFromSuperview];
        }
        for (CALayer *colorLayer in self.colorLayers)
        {
            [colorLayer removeFromSuperlayer];
        }
        [self.colorLayers removeAllObjects];
        [self.bgColorLayers removeAllObjects];
        NSOrderedSet *colors = [NEOColorPickerFavoritesManager instance].favoriteColors;
        UIColor *pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorPicker.bundle/color-picker-checkered"]];
        NSUInteger count = [colors count];
        for (int i = 0; i < count; i++)
        {
            int page = i / 24;
            int x = i % 24;
            int column = x % 4;
            int row = x / 4;
            CGRect frame = CGRectMake(page * CGRectGetWidth(self.scrollView.bounds) + 8 + (column * 78), 8 + row * 48, 70, 40);
            
            UIImageView *checkeredView = [[UIImageView alloc] initWithFrame:frame];
            checkeredView.layer.cornerRadius = 6.0;
            checkeredView.layer.masksToBounds = YES;
            checkeredView.backgroundColor = pattern;
            [self.scrollView addSubview:checkeredView];
            [self.bgColorLayers addObject:checkeredView];
            
            CALayer *layer = [CALayer layer];
            layer.cornerRadius = 6.0;
            UIColor *color = [colors objectAtIndex:i];
            layer.backgroundColor = color.CGColor;
            layer.frame = frame;
            [self setupShadow:layer];
            [self.scrollView.layer addSublayer:layer];
            [self.colorLayers addObject:layer];
        }
        NSInteger pages = (count - 1) / 24 + 1;
        self.scrollView.contentSize = CGSizeMake(pages * CGRectGetWidth(self.scrollView.bounds), 296);
        self.pageControl.numberOfPages = pages;
    }];
}

@end
