/*
 * Project Name: Creepy Robot Head - Servos
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Consolidating servo related modules into a library for later re-use.
 *
 */

// *** INCLUDE/USE LIBRARIES *** //

// *** VARIABLES *** //

/* Dimensions for MG995 Servo
    *Most values from datasheet

        ~6.75     ~27.25
        [---][-------------]
            6.0
            ||
~6.0 >  |------------------|      ---
~2.6 >-------------------------    |
        |                  | ^ 7.0 |
        |                  |       |
        | < 28.00          |       38 Height
        |                  |       |
     ===|                  |       |
        |__________________|      ---

        |------ 40.0 ------|
    Width

     --------------------------   ---
     |  |                  |  |    |
     |  |   O              |  |    20.0 Depth
     |  |                  |  |    |
     --------------------------   ---

*/

servo_height      = 0;
servo_width       = 0;
servo_depth       = 0;

servo_sub_height  = 0;

servo_overhang    = 0;

// Breakdown of servo width.
// Front to Axis, Axis Diameter, Axis to Rear.
servo_top = [ 0, 0, 0 ];
// Breakdown of the servo height.
// Bottom to cable,
// Calbe width,
// Cable to Overhange,
// Overhange width,
// Overhange to Top.
servo_side = [ 0.0, 0.0, 0.0, 0.0, 0.0 ];

print_gap = 2;

servo_dimension = [ servo_height,
                    servo_width,
                    servo_depth ];

servo_cavity = [ servo_dimension[1] + print_gap,   // Width
                 servo_dimension[2] + print_gap, // Depth
                 servo_sub_height + print_gap ];

servo_recess = [ servo_width + (servo_overhang * 2) + print_gap,
                 servo_depth + print_gap,
                 servo_height - servo_sub_height];

standard_fn = 20;



// *** MODULES AND FUNCTIONS *** //

// Dummy servo block for comparison during development.
module dummy_servo(servo_dimension) {

  color("lightblue")
    cube(servo_dimension);

}



// Size of the cavity that servos will fit in.
module servo_cutout() {

  cube(servo_cavity);

}

// Size of additional cavity to allow servo to fit in flush...ish.
module servo_recess_cutout() {

  translate([0,0,0])
    rotate([0,0,0])
      cube(servo_recess);

}

module cable_path_cutout( depth, diam, height ) {

  cble_co_diam = diam;
  cble_co_depth = depth;
  cble_co_height = height;

  cylinder( h=cble_co_depth, d=cble_co_diam);

  translate([0 - cble_co_diam, 0 - cble_co_diam / 2, 0])
  cube([ cble_co_height, cble_co_diam, cble_co_depth ]);

}

// Build_it function just for testing out each module
// during development.
module build_it() {

}



// *** MAIN ***  //
build_it();
