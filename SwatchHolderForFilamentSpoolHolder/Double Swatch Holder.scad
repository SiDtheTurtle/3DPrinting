// ------------------------------------------------------------------------------------------
// Swatch Holder for Filament Spool Holder (2/2) - Swatch Holder
// ------------------------------------------------------------------------------------------
//
// Corresponding swatch holder for the preceding peg clip
// Can be used as a standalone swatch holder by turning off the 'Include Cutout' parameter
//
// Print in rendered orientation, no supports or brim should be required unless the cutout
// sags, do not print on its side as the arms would need supports
//
// https://github.com/SiDtheTurtle/CAD/SwatchHolderForFilamentSpoolHolder/
//
// ------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------
// Parameters
// ------------------------------------------------------------------------------------------

// Width of the swatch, defaults to 150mm for 2x fenglyu@MakerWorld's short cards, anything wider won't fit if you have multiple holders, unless you've scaled the pegs accordingly
Swatch_Width = 150; //[50:300]

// Thickness of the swatch, defaults to 2mm for both versions of fenglyu@MakerWorld's cards, use 2.2mm for Makkuro@Printables design
Swatch_Depth = 2; //[2:0.1:10]

// Overall thickness off all the dimensions, increase to make a bulkier holder
Holder_Thickness = 2; // [2:0.1:5]

// Added buffer for expansion to allow the swatch to slide in easily
Material_Tolerance = 0.3; // [0:0.1:1]

// Switch to turn off the cutout if using the swatch holder without the corresponding peg clip holder
Include_Cutout = true;

// For the connector to the clip, how much extra to expand the hole. Increase if you're having trouble pushing the connector in, decrease if the join is too loose.
Join_Tolerance = 0.1; // [0:0.1:1]

// Width of the cutout, should match the Clip_Width parameter on the peg clip
Cutout_Width = 15; // [15:100]

// Height of the cutout, shoud match the Nub_Height parameter on the peg clip
Cutout_Height = 10;  // [10:30]

// Distance beyond the holder foot before the cutout is drawn, set to provide a gap between the foot and clip, allowing the spool to rest on the peg not the clip
Cutout_Spacing = 10; // [5:50]

/* [Hidden] */

// Overall width: the width of the swatches, plus the holder thickness times two (two arms), plus the material tolerance times 2
Overall_Width = Swatch_Width + (Holder_Thickness * 2) + (Material_Tolerance * 2);

// Overall depth: the holder thickness times 2 (the back and lips), plus the depth of the swatch, plus the material tolerance times 2
Overall_Depth = (Holder_Thickness * 2) + Swatch_Depth + (Material_Tolerance * 2);

// Overall holder height, forced to allow bottom of holder to sit flush with the feet of the holder, will need changing if the holder is scaled
Overall_Height = 40;
 
// Width of the clip's male connector
Join_Width = Cutout_Width + Join_Tolerance;

// Height of the clip's male connector
Join_Height = Cutout_Height + Join_Tolerance;

// Distance above clip's male connector to the top of the connector
Join_Top_Distance = 5;

// Size of the filament spool holder foot
Foot_Width = 25;

// ------------------------------------------------------------------------------------------
// Modules
// ------------------------------------------------------------------------------------------

// Module to generate a rounded corner, sub-module of Rounded_Corner(Q)
module Rounded_Corner_Element(H) {
    translate([Holder_Thickness / -2, Holder_Thickness / 2,0]) {
        difference() {
            cylinder(h = H, r = Holder_Thickness, $fn = 20, center = true);
            translate([0, Holder_Thickness / 2, 0]) {
                cube([Holder_Thickness * 2, Holder_Thickness, H + 1], center = true);
            }
            translate([Holder_Thickness / -2, Holder_Thickness / -2, 0]) {
                cube([Holder_Thickness, Holder_Thickness + 1, H + 1], center = true);
            }
        }
    }
}

// Module to generate a rounded corner, Q specifies what orientation in the style of a clock i.e. 1==noon to 3, 2==3 to 6 etc.
module Rounded_Corner(Q, H) {  
    if (Q == 1) {
        rotate([0, -90, -90]) {
            Rounded_Corner_Element(H);
        }
    }
    else if (Q == 2) {
        rotate([-90, 90, -180]) {
            Rounded_Corner_Element(H);
        }        
    }
    else if (Q == 3) {
        rotate([90, 0, 0]) {
            Rounded_Corner_Element(H);
        }        
    }    
    else if (Q == 4) {
        rotate([-90, 0, 0]) {
            Rounded_Corner_Element(H);
        }        
    }    
}

// Module to generate the back of the swatch holder
module Base() {
    color("red") {
        translate([0, 0, Overall_Height / - 2]) {
            cube([
                Overall_Width - (Holder_Thickness * 2),
                Overall_Depth,
                Holder_Thickness],
                center = true
            );
            translate([(Overall_Width / 2)+(Holder_Thickness / -2), 0, 0]) {
                Rounded_Corner(Q = 3, H = Overall_Depth);
            }
            translate([(Overall_Width / -2)+(Holder_Thickness / 2), 0, 0]) {
                Rounded_Corner(Q = 2, H = Overall_Depth);
            }            
        }
    }
}

// Module to generate the side arm of the holder, sub-module of Arm(D)
module Arm_Element() {
    cube([
        Holder_Thickness,
        Overall_Depth,
        Overall_Height - (Holder_Thickness * 2)],
        center = true
    );
}

// Module to generate the lip of the holder, sub-module of Arm(D)
module Lip_Element() {
    cube([
        Holder_Thickness,
        Holder_Thickness,
        Overall_Height - Holder_Thickness],
        center = true
    );
}

// Module to generate the overall arm of the holder, D specifies left or right arm
module Arm(D) {
    color("green") {
        if (D == "left") {
            // Arm with rounded corner
            translate([(Overall_Width-Holder_Thickness) / 2, 0, Holder_Thickness / -2]) {
                Arm_Element();
                translate([0, 0, (Overall_Height - Holder_Thickness) / 2]) {
                    Rounded_Corner(Q = 4, H = Overall_Depth);
                }
            }
            // Lip
            translate([(Overall_Width / 2) - Holder_Thickness - (Holder_Thickness / 2), (Overall_Depth / 2) - (Holder_Thickness / 2), 0]) {
               Lip_Element();
            }
          
      }
      else if (D=="right") {
          // Arm with rounded corner
          translate([(Overall_Width-Holder_Thickness) / -2, 0, Holder_Thickness / -2]) {
              Arm_Element();
              translate([0, 0, (Overall_Height-Holder_Thickness) / 2]) {
                  Rounded_Corner(Q = 1, H = Overall_Depth);
              }              
          }
          //Lip
          translate([(Overall_Width / -2) + Holder_Thickness - (Holder_Thickness / -2), (Overall_Depth / 2) - (Holder_Thickness / 2), 0]) {
              Lip_Element();
          }          
      }
    }
}

// Module to generate the central arm to hold the base of the two swatches
module CentreArm() {
    color("orange") {
        translate([0, (Overall_Depth - Holder_Thickness) / 2, (Overall_Height / -2) + Holder_Thickness]) {
            cube(
                [Overall_Width - (Holder_Thickness * 4),
                Holder_Thickness,
                Holder_Thickness],
                center = true
            );
        }
    }
}

// Module to generate the back piece of the holder, sub-module of Back(C)
module Back_Element() {
    cube([
        Swatch_Width + (Material_Tolerance*2),
        Holder_Thickness,
        Overall_Height - Holder_Thickness],
        center = true
    );    
}

// Module to generate the back piece cutout, sub-module of Back(C)
module Back_Cutout_Element() {
    translate([0, 0, ((Overall_Height - Holder_Thickness - Join_Height) / 2) - Join_Top_Distance]) {
        cube([
            Join_Width,
            Holder_Thickness + 1,
            Join_Height],
            center=true
        );
    }
}

// Module to generate the back portion of the holder, C specifies whether there should be a
// cutout for the peg clip, set to false if using the holder without the peg clip
module Back(C) {
    color("blue") {
        translate([0, (Overall_Depth - Holder_Thickness) / -2, 0]) {
            if (C==true) {
                difference() {
                    Back_Element();
                    translate([((Overall_Width - Join_Width - Foot_Width - Material_Tolerance) / 2) - Cutout_Spacing, 0, 0]) {
                        Back_Cutout_Element();
                    }
                    translate([((Overall_Width - Join_Width - Foot_Width - Material_Tolerance) / -2) + Cutout_Spacing, 0, 0]) {
                        Back_Cutout_Element();
                    }
                }
            }
            else {
                Back_Element();
            }
        }
    }
}

// ------------------------------------------------------------------------------------------
// Rendering
// ------------------------------------------------------------------------------------------

Base();
Back(C=Include_Cutout);
Arm(D="left");
Arm(D="right");
CentreArm();