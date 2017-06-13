/*
 * Project Name: Creepy Robot Head - Jaw
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Part of the Creepy Robot Head project.
 * Library containing the modules to build the upper and lower jaw.
 *
 */

/* *** TODO LIST ***
 *
 * Need to secure servo in place.
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

partial_rotate_extrude(angle, radius, convex);

fillet_linear_o(l, fillet_r, fillet_angle=90, fillet_fn=0, add=0.02)

 */

// *** INCLUDE/USE LIBRARIES *** //
include <fillets.scad>;
include <MG90S_servos.scad>;
use <kamikaze_shapes.scad>;

// Same funcitonality will be built into OpenSCAD 2016.XX.
use <partial_rotate_extrude.scad>;



// *** VARIABLES *** //


/*
 * Directions:
 *
 * Enter the desired dimension for the jaw and teeth below.
 *
 * Everything else should calculate automatically.
 *
 */

// Length, width, and height of the basic jaw. [x,y,z]
// x should be greater than y.
// Does not include additonal height of lower jaw hinge.
// The height of the lower hinge is to accommodate the
// upper and lower jaw fitting together.

jaw_length = 60;
jaw_width  = 40;
jaw_height = 20;


// Tooth Dimensions
// [x,y,z,r] where;
// x,y,z are dimensions of the cube.
// r is the radius of curved corners.
// Embedded 'r' into the gum line.

tooth_length = 9;
tooth_width  = 5;
tooth_height = 10;
tooth_radius = 1;

num_of_teeth = 14;

//jaw_dimension = [230,150,70];
jaw_dimension = [ jaw_length, jaw_width, jaw_height ];

tooth_dim = [ tooth_length,
              tooth_width,
              tooth_height,
              tooth_radius ];

// Measurements for the jaw's gum line

jaw_radius = jaw_dimension[1] - ( tooth_dim[1] * 1.25 );
// Inner diamter of the jaw
// 1.25 provides just a bit of overhange around the tooth.

// Dimensions of the gum line, [x,y]
// ( actually y,z when rotated for the extrusion.)
rect_dim = [ ( tooth_dim[1] * 1.25 ),
             (jaw_dimension[0] - jaw_dimension[1]) / 2 ];

tz = rect_dim[1] - tooth_dim[3]; // z coordinate of the teeth.


screw_diam = 3;
screw_head_diameter = 6;

screw_length = screw_diam + 1;
recess_diam  = screw_head_diameter + print_gap;
recess_depth = jaw_height;

print_gap = 2;
standard_fn = 100;




// *** MODULES AND FUNCTIONS *** //

// Basic shape created for the tooth.
module tooth(tooth_dim, mod_fn=$fn) {

  minkowski() {

    cube( [ tooth_dim[0] - ( 2 * tooth_dim[3] ),
            tooth_dim[1] - ( 2 * tooth_dim[3] ),
            tooth_dim[2] - ( 2 * tooth_dim[3] )] );

    sphere( tooth_dim[3], $fn );
  }
}



// Build a row of teeth.
module teeth(mod_fn=$fn) {

  translate([0,0,tz])
    rotate([0,0,180])
      make_ring_of(jaw_dimension[1] - print_gap, num_of_teeth, 180)
        tooth(tooth_dim);
}



// 'jaw_radius' is the diameter of the jaw's curve.
// 'rect_dim' is the dimensions of the rectangle that is
// extruded to make the gum line.
module gum_line(jaw_radius, rect_dim) {

  rotate([0,0,90])
    partial_rotate_extrude(180, jaw_radius)
      square(rect_dim);



  // Right side where the jaw meets the hinge.
  translate([0,jaw_radius,0])

    cube([ jaw_dimension[0] - jaw_dimension[1],
           rect_dim[0],
           rect_dim[1] ]);

  // Left side where the jaw meets the hinge.
  // Translate shifts the radius of the jaw
  // plus the width of the rectangle,
  // so it aligns with the jaw on the negative side of the axis.
  translate([ 0, 0 - ( jaw_radius + rect_dim[0] ), 0 ])
    cube([ jaw_dimension[0] - jaw_dimension[1],
           rect_dim[0],
           rect_dim[1] ]);

}



module half_jaw() {

  gum_line(jaw_radius, rect_dim);

  teeth();

}



module hinge_fillets() {

  length = (jaw_dimension[0] - jaw_dimension[1]) / 2;
  radius = ( tooth_dim[1] * 1.25 );

  vx_loc = (jaw_dimension[0] - jaw_dimension[1]) / 2;
  vy_loc = jaw_dimension[1] - ( tooth_dim[1] * 1.25 );
  vz_loc = 0;

  hx_loc = (jaw_dimension[0] - jaw_dimension[1]);
  hy_loc = jaw_dimension[1] - ( tooth_dim[1] * 1.25 );
  hz_loc = (jaw_dimension[0] - jaw_dimension[1]) / 2;

  vert_fillet_loc = [ vx_loc, vy_loc, vz_loc ];
  horz_fillet_loc = [ hx_loc, hy_loc, hz_loc ];


  translate(vert_fillet_loc)
    rotate([0,0,180])
      fillet_linear_i(length, radius, fillet_fn=standard_fn);

  translate(horz_fillet_loc)
    rotate([0,-90,0])
      fillet_linear_i(length, radius, fillet_fn=standard_fn);

}



module right_hinge_fillets() {

  hinge_fillets();

}



module left_hinge_fillets() {

  mirror([0,1,0]) hinge_fillets();

}



module lower_hinge(x, y, z, x_loc, y_loc) {

  difference() {

    union() {

      translate([x_loc, y_loc,0])
        cube([x,y, z - (y / 2) ]);

      translate([x_loc + (x / 2), (y_loc + y), z - (y / 2) ])
        rotate([90,0,0])
          cylinder(h=y,d=x);
    }

    translate([x_loc + (x / 2), (y_loc + y), z - (y / 2) ])
      rotate([90,0,0])
        cylinder(h=y,d=screw_diam);
  }
}



module left_hindge() {

  x = (jaw_dimension[0] - jaw_dimension[1]) / 2; // = rect_dim[1];
  y = ( tooth_dim[1] * 1.25 ); // = rect_dim[0];
  z = (jaw_dimension[2] * 2) + 2;
    // Double the hight of the jaw.
    // Plus a small gap.

  x_loc = x;
  y_loc = 0 - jaw_dimension[1] + ( tooth_dim[1] * 1.25 );



  lower_hinge(x, y, z, x_loc, y_loc);
  left_hinge_fillets();

}



module right_hindge() {

  x = (jaw_dimension[0] - jaw_dimension[1]) / 2; // = rect_dim[1];
  y = ( tooth_dim[1] * 1.25 ); // = rect_dim[0];
  z = (jaw_dimension[2] * 2) + 2;
    // Double the hight of the jaw.
    // Plus a small gap.

  x_loc = x;
  y_loc = jaw_dimension[1] - (( tooth_dim[1] * 1.25 ) * 2 );



  lower_hinge(x, y, z, x_loc, y_loc);
  right_hinge_fillets();

}



// Provides gap for the lower hinge to fit into the upper jaw.
module upper_hinge_cutout(x, y, z, x_loc, y_loc) {

  translate([x_loc,y_loc,0]) // 40,129,-1
    cube([x,y,z]);

  // Screw hole
  translate([ x_loc + x/2, y_loc, z/2 ])
    rotate([90,0,0])
      cylinder( h=rect_dim[0], d=screw_diam );

}



module left_upper_hindge_cutout() {

  x = (jaw_dimension[0] - jaw_dimension[1]) / 2;
  y = print_gap;
  z = (jaw_dimension[0] - jaw_dimension[1]) / 2;

  x_loc = x;
  y_loc = 0 - jaw_dimension[1] + ( tooth_dim[1] * 1.25 ) - y;

  upper_hinge_cutout(x, y, z, x_loc, y_loc);

}



module right_upper_hindge_cutout() {

  mirror([0,1,0])
    left_upper_hindge_cutout();

}



module upper_jaw_mount_plate() {

  difference() {

    cylinder(h=screw_length, r=jaw_radius);

    translate([0, 0 - jaw_radius, 0])
      cube([jaw_radius, jaw_radius * 2, screw_length]);

  }

  translate([0, 0 - (jaw_radius - rect_dim[0]) + (print_gap / 2), 0])
    cube([servo_recess[0] + (servo_overhang * 2) - (print_gap / 2),
          ((jaw_radius - rect_dim[0]) * 2) - print_gap,
          screw_length]);

  // Servo mounting block
  translate([0 - (print_gap / 2),
             0 - (jaw_radius - rect_dim[0])
             + (print_gap / 2),
             screw_length])

    cube([ servo_recess[0] + (servo_overhang * 2),
           servo_cavity[2] + servo_side[3] + servo_side[4] + servo_overhang,
           servo_recess[1] ]);

// Fillet along the Y
  translate([ 0 - (print_gap / 2),

              servo_side[4]
              + servo_overhang - (print_gap / 4), // Don't know why this is off by .5 mm

              screw_length ])

    rotate([0,-90,90])
      fillet_linear_i(servo_cavity[2]
                      + servo_side[3]
                      + servo_side[4]
                      + servo_overhang,
                      servo_recess[1],
                      fillet_fn=standard_fn);


// Fillet along the X
  translate([ servo_recess[0] + (servo_overhang * 2) - (print_gap / 2),

              servo_side[4]
              + servo_overhang - .5, // Don't know why this is off by .5 mm

              screw_length ])

    rotate([0,-90,0])
      fillet_linear_i(servo_recess[0] + (servo_overhang * 2),
                      servo_recess[1],
                      fillet_fn=standard_fn);

}

module bottom_jaw() {

  half_jaw();
  left_hindge();
  right_hindge();

}



module upper_jaw() {

  screw_rec_loc_x = 0 - (jaw_radius / 2);
  screw_rec_loc_y = 0;
  screw_rec_loc_z = -2;

  screw_rec_loc = [[screw_rec_loc_x, screw_rec_loc_y, screw_rec_loc_z],
                [ 0 - screw_rec_loc_x, screw_rec_loc_y, screw_rec_loc_z]];

  servo_loc = [ jaw_dimension[0]
                - jaw_dimension[1]
                - servo_overhang
                - servo_top[0]
                - (servo_top[1] / 2),

                0 - (jaw_radius - rect_dim[0])
                + (print_gap / 2)
                + servo_recess[2]
                + servo_cavity[2] - .1,

                screw_length];

  servo_rec_loc_x = jaw_dimension[0]
                    - jaw_dimension[1]
                    - (servo_overhang * 2)
                    - servo_top[0]
                    - (servo_top[1] / 2);

  servo_rec_loc_y = 0 - (jaw_radius - rect_dim[0]) + (print_gap / 2) + (servo_recess[2]) - .1;

  servo_rec_loc_z = screw_length;

  servo_rec_loc = [servo_rec_loc_x, servo_rec_loc_y, servo_rec_loc_z];

  cble_co_diam = servo_side[1] + print_gap;
  cble_co_depth = servo_loc[0] + servo_recess[1];
  cble_co_height = servo_depth;


  cble_co_loc_x = servo_loc[0] - (cble_co_diam / 2) + print_gap;
  cble_co_loc_y = servo_loc[1] - servo_side[0] - servo_side[1] - (cble_co_diam / 2);
  cble_co_loc_z = screw_length + (servo_depth /2);

  cble_co_loc = [ cble_co_loc_x, cble_co_loc_y, cble_co_loc_z ];

  wh = screw_length + ((servo_depth - rect_dim[1]) / 2);
  wb = rect_dim[0];



  rotate([0,0,90])
    partial_rotate_extrude(180, jaw_radius)
        polygon(
          points=[ [0,0],
                   [0,wh],
                   [wb,wh] ],

          paths=[ [0,1,2] ]
        );



  difference() {

    upper_jaw_mount_plate();

    // Servo cavity
    translate(servo_loc)
        rotate([90,0,0])
            servo_cutout();

    translate(servo_rec_loc)
        rotate([90,0,0])
            servo_recess_cutout();

    translate(cble_co_loc)
        rotate([0,-90,0])
          cable_path_cutout( cble_co_depth, cble_co_diam, cble_co_height );



    // Screw points
    translate(screw_rec_loc[0])
        rotate([0,0,0])
            recessed_screw_cutout(recess_depth,
                                  recess_diam,
                                  screw_length,
                                  screw_diam);

    translate(screw_rec_loc[1])
        rotate([0,0,0])
            recessed_screw_cutout(recess_depth,
                                  recess_diam,
                                  screw_length,
                                  screw_diam);

  }

  translate([ 0,0,screw_length + ((servo_depth - rect_dim[1]) / 2) ])
    difference() {

      half_jaw();

      left_upper_hindge_cutout();
      right_upper_hindge_cutout();

    }

}



// Build_it function just for testing out each module
// during development.
module build_it() {

  //rotate([180,0,0])
  //bottom_jaw();

  upper_jaw();

}

// *** MAIN ***  //
$fn=standard_fn;
build_it();
