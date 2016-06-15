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
 * Need to scale down the jaw by .25 percent.
 * Mounting for upper jaw.
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
[0, 0, 0],        // vector[1]
[0, 0, 0],      // vector[2]
[0, 0, 0]         // vector[3]
];

partial_rotate_extrude(angle, radius, convex);

fillet_linear_o(l, fillet_r, fillet_angle=90, fillet_fn=0, add=0.02)      

 */

// *** INCLUDE/USE LIBRARIES *** //
//include <shapes.scad>;
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

jaw_diam = jaw_dimension[1] - ( tooth_dim[1] * 1.25 ); 
// Inner diamter of the jaw
// 1.25 provides just a bit of overhange around the tooth.

// Dimensions of the gum line, [x,y]
// ( actually y,z when rotated for the extrusion.)
rect_dim = [ ( tooth_dim[1] * 1.25 ),
             (jaw_dimension[0] - jaw_dimension[1]) / 2 ];

tz = rect_dim[1] - tooth_dim[3]; // z coordinate of the teeth.


standard_fn = 100;      




// *** MODULES AND FUNCTIONS *** //

// Basic shape created for the tooth.
//module tooth(pos_vector, tooth_dim, mod_fn=$fn) 
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



// 'jaw_diam' is the diameter of the jaw's curve.
// 'rect_dim' is the dimensions of the rectangle that is
// extruded to make the gum line.
module gum_line(jaw_diam, rect_dim) {
  
  rotate([0,0,90])
    partial_rotate_extrude(180, jaw_diam) 
      square(rect_dim);


  
  // Right side where the jaw meets the hinge.
  translate([0,jaw_diam,0])

    cube([ jaw_dimension[0] - jaw_dimension[1], 
           rect_dim[0], 
           rect_dim[1] ]);
  
  // Left side where the jaw meets the hinge.
  // Translate shifts the radius of the jaw
  // lus the width of the rectangle, 
  // so it aligns with the jaw on the negative side of the axis.
  translate([ 0, 0 - ( jaw_diam + rect_dim[0] ), 0 ])
    cube([ jaw_dimension[0] - jaw_dimension[1], 
           rect_dim[0], 
           rect_dim[1] ]);

}



module half_jaw() {
        
    gum_line(jaw_diam, rect_dim);
        
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
  
   translate([x_loc, y_loc,0])
       cube([x,y, z - (y / 2) ]);
     
   translate([x_loc + (x / 2), (y_loc + y), z - (y / 2) ])
     rotate([90,0,0])
       cylinder(h=y,d=x);
  
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
  
  x = (jaw_dimension[0] - jaw_dimension[1]) / 2;
  y = print_gap;
  z = (jaw_dimension[0] - jaw_dimension[1]) / 2; 
  
  x_loc = x; 
  y_loc = jaw_dimension[1] - ( tooth_dim[1] * 1.25 );
  
  upper_hinge_cutout(x, y, z, x_loc, y_loc);
  
}


module bottom_jaw() {
  
   half_jaw();
   left_hindge();
   right_hindge();

}



module upper_jaw() {
  
  difference() {
    
    half_jaw();
  
    left_upper_hindge_cutout();
    right_upper_hindge_cutout();
  }
  
}



// Build_it function just for testing out each module
// during development.
module build_it() {

  //bottom_jaw();

  upper_jaw();

}

// *** MAIN ***  //
$fn=standard_fn;
build_it();
