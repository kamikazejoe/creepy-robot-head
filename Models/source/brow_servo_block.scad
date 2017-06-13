/*
 * Project Name:
 * Author: Kamikaze Joe
 *
 * Description:
 */

/* *** TODO LIST ***
 *
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
[0, 0, 0],        // vector[1]
[0, 0, 0],      // vector[2]
[0, 0, 0]         // vector[3]
];


 */

// *** INCLUDE/USE LIBRARIES *** //
use <fillets.scad>;
use <kamikaze_shapes.scad>;
include <ES08AII_servos.scad>;

// *** VARIABLES *** //
standard_fn = 100;
print_gap = 2;

screw_diam = 3;
screw_head_diameter = 6;

screw_length = screw_diam + 1;
recess_diam  = screw_head_diameter + print_gap;

block_diameter = servo_width + servo_overhang * 2 + recess_diam * 2;
block_depth = servo_height;

recess_depth = block_diameter;

// *** MODULES AND FUNCTIONS *** //

module half_block() {

  difference() {

    cylinder( h=block_depth, d=block_diameter );

    translate([ 0 - block_diameter/2, 0 - block_diameter/2, 0])
      cube([ block_diameter, block_diameter/2, block_depth]);

  }

}

module brow_servo_block() {

  difference() {

    half_block();

    translate([ 0 - servo_cavity[0]/2, 0, 0])
      servo_cutout();

    translate([ 0 - servo_recess[0]/2, 0, block_depth - servo_recess[2] ])
      servo_recess_cutout();

    translate([ block_diameter/2 - servo_overhang, -.1, block_depth/2 ])
      rotate([-90,0,0])
        recessed_screw_cutout( recess_depth,
                               recess_diam,
                               screw_length,
                               screw_diam,
                               standard_fn );

    translate([ 0- block_diameter/2 + servo_overhang, -.1, block_depth/2 ])
      rotate([-90,0,0])
        recessed_screw_cutout( recess_depth,
                               recess_diam,
                               screw_length,
                               screw_diam,
                               standard_fn );

    translate([ block_diameter / 2, servo_depth / 2, servo_side[0] - .1 ])
      rotate([0,-90,0])
        cable_path_cutout( block_diameter, servo_side[1] + print_gap, servo_side[0] );

  }

}

// Build_it function just for testing out each module
// during development.
module build_it() {

  brow_servo_block();
  //half_block();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
