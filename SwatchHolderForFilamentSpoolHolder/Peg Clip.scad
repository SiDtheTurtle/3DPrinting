// ------------------------------------------------------------------------------------------
// Swatch Holder for Filament Spool Holder (1/2) - Peg Clip
// ------------------------------------------------------------------------------------------
//
// Clip that snuggly fits around the pegs of this filament spool holder: 
// https://www.printables.com/model/388935-fully-printable-filament-storage-rack
//
// Print in rendered orientation, no supports or brim should be required
//
// https://github.com/SiDtheTurtle/CAD/SwatchHolderForFilamentSpoolHolder/
//
// ------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------
// Parameters
// ------------------------------------------------------------------------------------------

// Width of the clip that will clasp onto the peg, needs to match Join_Width of the swatch connector, not including Join_Tolerance
Clip_Width = 15; // [15:100]

// Thickness of the clip ring, thicker than 1.5 makes it hard to clip on to the peg
Clip_Thickness = 1.5; // [1:0.1:2]

// How much to reduce the size of the inner circle to in crease to bind the clip to the peg
Clutch_Tolerance = 0.0; // [0:0.1:1]

// Thickness of the joining nub, should match the Holder_Thickness setting of the swatch holder
Nub_Depth = 2; // [2:0.1:5]

// Height of the nub, should match the Cutout_Width parameter of the swatch holder
Nub_Height = 10; // [10:30]

// Hidden Parameters - Not normally required to be changed

/* [Hidden] */

// The diameter of the filament holder peg, usually not changed unless you scale the holder peg
Peg_Diameter = 25;

// Used to simplify the readabilty of the cylinder calcs
Peg_Radius = Peg_Diameter / 2;

// The inner radius of the clip that binds to the peg: take the radius of the peg, reduced, by the clutch tolerance, therefore the inner circle will be slightly smaller than the peg, allowing it to grip firmly
Clip_Inner_Radius = Peg_Radius - Clutch_Tolerance;

// The outer radius of the clip: the inner radius plus the user defined thickness
Clip_Outer_Radius = Clip_Inner_Radius + Clip_Thickness;

// Size of the connector block to space out the depth to the nub
Connector_Block_Width = 15;

// Size of the connector block height, needs to be set to be flush with the bottom of the clip
Connector_Block_Height = Peg_Diameter * 0.8;

// Translation factor to align connect to the bottom of clip
Connector_Alignment_Factor = 0.6;

// ------------------------------------------------------------------------------------------
// Rendering
// ------------------------------------------------------------------------------------------
difference() {
    union() {
        // Outer clip cylinder
        cylinder(
            h = Clip_Width,
            r = Clip_Outer_Radius,
        center = true
        );
        
        // Connecting cube
        translate ([-Peg_Radius, 0, 0]){
            cube([
                Connector_Block_Width,
                Connector_Block_Height,
                Clip_Width],
                center = true
            );
        }
    }
    // Inner clip cylinder cut out
    cylinder(
        h = Clip_Width + 1,
        r = Clip_Inner_Radius,
        center = true
    );
    // Bottom of clip cut out
    translate([0, Peg_Diameter * Connector_Alignment_Factor, 0]) {
        cube([
            Peg_Diameter * 2,
            Peg_Diameter * (1 - Connector_Alignment_Factor),
            Clip_Width + 1],
        center = true
        );
    }
}

// Connector nub
translate([-Peg_Radius - (Connector_Block_Width / 2) - (Nub_Depth /2 ), 0, 0]) {
    cube(
        [Nub_Depth,
        Nub_Height,
        Clip_Width],
        center = true
    );
}