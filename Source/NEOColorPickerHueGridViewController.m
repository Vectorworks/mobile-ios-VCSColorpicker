#import "NEOColorPickerHueGridViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface NEOColorPickerHueGridViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) CALayer *selectedColorLayer;
@property (nonatomic, strong) NSMutableArray *hueColors;
@property (nonatomic, strong) NSMutableArray *colorLayers;
@property (nonatomic, assign) CGRect selectedColorLabelBaseFrame;
@property (nonatomic, assign) CGRect scrollViewBaseFrame;
@property (nonatomic, assign) CGRect doneButtonBaseFrame;

@end

@implementation NEOColorPickerHueGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hueColors = [NSMutableArray array];
        
        for (int i = 0 ; i < 12; i++) {
            CGFloat hue = i * 30 / 360.0;
            int colorCount = NEOColorPicker4InchDisplay() ? 32 : 24;
            for (int x = 0; x < colorCount; x++) {
                int row = x / 4;
                int column = x % 4;
                
                CGFloat saturation = column * 0.25 + 0.25;
                CGFloat luminosity = 1.0 - row * 0.12;
                UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:luminosity alpha:1.0];
                [self.hueColors addObject:color];
            }
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorLayers = [NSMutableArray array];
    
    self.selectedColorLabel.frame = CGRectMake(20, 10, 130, 40);
    self.selectedColorLabelBaseFrame = self.selectedColorLabel.frame;
    self.scrollView.frame = CGRectMake(0, 65, 320, 330);
    self.scrollViewBaseFrame = self.scrollView.frame;
    self.doneButton.frame = CGRectMake(240, 0, 80, 65);
    self.doneButtonBaseFrame = self.doneButton.frame;
    
    self.selectedColorLabel.numberOfLines = 5;
    if (self.selectedColorText.length != 0)
    {
        self.selectedColorLabel.text = self.selectedColorText;
    }
    if (self.doneButtonText.length != 0)
    {
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
    
    
    self.colorBar.image = [UIImage imageNamed:@"colorPicker.bundle/color-bar"];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.scrollView addGestureRecognizer:recognizer];
    
    self.colorBar.userInteractionEnabled = YES;
    UITapGestureRecognizer *barRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorBarTapped:)];
    [self.colorBar addGestureRecognizer:barRecognizer];
}

- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.scrollView];
    int page = point.x / CGRectGetWidth(self.scrollView.bounds);
    int delta = (int)point.x % ((int)CGRectGetWidth(self.scrollView.bounds));
    
    int row = (int)((point.y - 8) / 48);
    int column = (int)((delta - 8) / 78);
    int colorCount = NEOColorPicker4InchDisplay() ? 32 : 24;
    int index = colorCount * page + row * 4 + column;
    self.selectedColor = [self.hueColors objectAtIndex:index];
    self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
    [self.selectedColorLayer setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(colorPickerViewController:didChangeColor:)]) {
        [self.delegate colorPickerViewController:self didChangeColor:self.selectedColor];
    }
}


- (void) colorBarTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.colorBar];
    int page = point.x / 25;
    [self.scrollView scrollRectToVisible:CGRectMake(page*CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds)) animated:YES];
}

- (IBAction)doneButtonClicked:(UIButton *)sender
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
        [self rotateView:self.selectedColorLabel withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.scrollView withDegrees:degrees andOrientation:orientation];
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
    
    return CGRectZero;
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
        for (CALayer *colorLayer in self.colorLayers)
        {
            [colorLayer removeFromSuperlayer];
        }
        [self.colorLayers removeAllObjects];
        int index = 0;
        for (int i = 0; i < 12; i++) {
            int colorCount = NEOColorPicker4InchDisplay() ? 32 : 24;
            for (int x = 0; x < colorCount; x++) {
                CALayer *layer = [CALayer layer];
                layer.cornerRadius = 6.0;
                UIColor *color = [self.hueColors objectAtIndex:index++];
                layer.backgroundColor = color.CGColor;
                
                int column = x % 4;
                int row = x / 4;
                layer.frame = CGRectMake(i * CGRectGetWidth(self.scrollView.bounds) + 8 + (column * 78), 8 + row * 48, 70, 40);
                [self setupShadow:layer];
                [self.scrollView.layer addSublayer:layer];
                [self.colorLayers addObject:layer];
            }
        }
        self.scrollView.contentSize = CGSizeMake(12 * CGRectGetWidth(self.scrollView.bounds), 296);
    }];
}

@end
