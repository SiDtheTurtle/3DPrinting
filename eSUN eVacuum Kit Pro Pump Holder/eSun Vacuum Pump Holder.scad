// ------------------------------------------------------------------------------------------
// MultiConnect holder for eSUN eVacuum Kit Pro Pump
// ------------------------------------------------------------------------------------------
//
// Simple wall holder for the vacuum pump that comes with the eSUN filament bags
// Designed to hold the pump upside down while it remains plugged in, and also includes a
// slot for the sealing clip
//
// https://esun3dstore.uk/products/evacuum-kit-pro
//
//
// Do not print from this SCAD, needs to be merged with the MultiConnect negative, see
// corresponding .3MF file, if you change any of the dimensions here, use 'replace STL' within
// OrcaSlicer
//
// This design is very dependent on the specific dimensions of the pump, if this changes,
// expect things to break, it's not truly parametric
//
// https://3dprinting.seeburn.co.uk/
// https://github.com/SiDtheTurtle/3DPrinting
//
// ------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------
// Parameters
// ------------------------------------------------------------------------------------------

// Define the physical diameter of the pump, where the clip will hold it
Pump_Diameter=34;

// Define the physical width of the sealer clip (SCAD Y dimension)
Sealer_Clip_Width=11.7;

// Define the pysical height of the sealer clip (SCAD Z dimension)
Sealer_Clip_Height=39;

// Define the physical depth of the sealer clip (SCAD X dimension)
Sealer_Clip_Depth=7.5;

// Define how thick you want the round bit of the holder to be, 2mm seems to work
Clip_Thickness=2;

// Define how far from the wall you want the holder to be
Holder_Depth=15;

/* [Hidden] */

// Cylinder facets
$fn=32;

// Main size multiplier - 24 is Multiboard less some wiggle room, if it fits Multiboard it'll fit OpenGrid, so no need to change it even if you're using OpenGrid
Grid_System=24; //[28:OpenGrid, 25:Multiboard]

// Parameters to define the overall size of the clip
Clip_D=Pump_Diameter+(Clip_Thickness*2);
Clip_Z=Grid_System;

// Parameters to define the cutout to hold the pump
Pump_D=Pump_Diameter;
Pump_Z=(Grid_System*2)+1;

// Parameters for the part that joins the clip to the board
Holder_X=(Clip_D/2)+Holder_Depth;
Holder_Y=Grid_System;;
Holder_Z=Clip_Z*2;

// Parameters for the clip cutout, allowing the cable to slide through
Cutout_X=Clip_Thickness+1;
Cutout_Y=5;
Cutout_Z=Clip_Z+1;

// Parameters for negative cutout to hold the sealer, take the actual size and add 2mm tolerance
Sealer_X = Sealer_Clip_Depth+2;
Sealer_Y = Sealer_Clip_Width+2;
Sealer_Z = Sealer_Clip_Height+2;

difference() {
    difference() {
        union(){
            // Outer clip
            cylinder(h=Clip_Z, d=Clip_D, center=true);
            // Holder
            translate([Holder_X/2, 0, Grid_System/-2]) {
                cube([Holder_X, Holder_Y, Holder_Z], center=true);
            }
        }
        // Inner clip negative
        translate([0, 0, Grid_System/-2]) {
            cylinder(h=Pump_Z, d=Pump_D, center=true);
        }
        
        // Clip cutout
        translate([(Clip_D-Clip_Thickness)/-2,0,0]) {
            cube([Cutout_X, Cutout_Y, Cutout_Z], center=true);
        }
    }
    // Sealer clip negative
    // ### Hack, got bored trying to figure out the position
    translate([((Clip_D+Sealer_X)/2)+1, 0, Sealer_Z/5]) {
        cube([Sealer_X, Sealer_Y, Sealer_Z], center=true);
    }
}