/*
 * Project Name: Creepy Robot Head - Nasal Camera Mount
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Raspberry Pi Camera Mount.  Also the point where the jaw mounts
 * to the rest of the head.
 *
 */

/* *** TODO LIST ***
 *
 * Tabs to spaces
 *
 */

/* ***** Cheats *****

cube([x,y,z]);
translate([x,y,z]);
rotate([x_deg,y_deg,z_deg]);
cylinder(h=x,d=y);

translate([0,0,0])
    rotate([0,0,0])
        function();

vector = [ // aka: A matrix or array.
[0, 0, 0],          // vector[0][0,1,2]
[0, 0, 0],              // vector[1]
[0, 0, 0],                      // vector[2]
[0, 0, 0]               // vector[3]
];


 */

// *** INCLUDE/USE LIBRARIES *** //
use <fillets.scad>;
use <kamikaze_shapes.scad>;

// *** VARIABLES *** //

plate_depth = 3; // Thickness of the camera mount.

// Maths from module datasheet as a self-reminder of measurments.
picam_screw_hole_vector = [
                           [ 2, 2, 0],
                           [ 2, 2 + 21, 0],
                           [ 2 + 12.5, 2, 0],
                           [ 2 + 12.5, 2 + 21, 0]
                          ];

picam_xy = [ 24, 25 ];

print_gap = 1;
standard_fn = 20;
screw_diam = 2 + print_gap;


// *** MODULES AND FUNCTIONS *** //

module picam_base_plate(plate_depth) {

  cube([picam_xy[0],picam_xy[1],plate_depth]);

}



module picam_screw_holes(plate_depth, screw_diam=screw_diam) {

  translate(picam_screw_hole_vector[0])
    cylinder(h=plate_depth, d=screw_diam, $fn=20);

  translate(picam_screw_hole_vector[1])
    cylinder(h=plate_depth, d=screw_diam, $fn=20);

  translate(picam_screw_hole_vector[2])
    cylinder(h=plate_depth, d=screw_diam, $fn=20);

  translate(picam_screw_hole_vector[3])
    cylinder(h=plate_depth, d=screw_diam, $fn=20);

}



module picam_lense_hole(plate_depth) {

  lense_size = 8 + print_gap;

  // Complicated maths to allow lense_size to adjust and keep hole centered.
  translate([ 24 - (5.5 - ( (lense_size - 8) / 2 )) - lense_size,
              (8.5 - ((lense_size - 8) / 2)),
              0])
    cube([ lense_size, lense_size, plate_depth ]);

}



module picam_mount_plate(plate_depth) {

  difference() {

    picam_base_plate(plate_depth);

    picam_screw_holes(plate_depth);

    picam_lense_hole(plate_depth);

  }

}

// Build_it function just for testing out each module
// during development.
module build_it() {

  picam_mount_plate(plate_depth);

}

// *** MAIN ***  //
build_it();
