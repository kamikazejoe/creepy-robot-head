/*
 * Project Name: Kamikaze Shapes
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Library of modules that create shapes I use frequently.
 *
 */

// INCLUDE/USE LIBRARIES

// *** VARIABLES ***
standard_fn = 20;
print_gap = 0;

// *** MODULES AND FUNCTIONS *** //



module rounded_base_plate(plate_x, plate_y, plate_corner_r, plate_depth) {

  translate([plate_corner_r, plate_corner_r,0])
  // Recenter minkowski origin to (0,0).
    minkowski() // Remeber outer dimensions of the box are now x+2r
    {
      cube([plate_x - (2 * plate_corner_r),
            plate_y - (2 * plate_corner_r),
            plate_depth]);

      cylinder(r=plate_corner_r,h=plate_depth);
    }
}



// Function to create a triangluar prism shape or wedge
module wedge(triangle_height, triangle_base, length) {

  linear_extrude(height = length,
                 center = false,
                 convexity = 10,
                 twist = 0)

    polygon(
             points=[ [0,0],
                      [0,triangle_height],
                      [triangle_base,triangle_height] ],

             paths=[ [0,1,2] ]
           );
}


// Rounded isoceles right triangular shape.
// Intended to cut out of flat panels to save space and weight
module triangle_cut_out(triangle_height, length, corner_radius, mod_fn=$fn) {

  translate([corner_radius, corner_radius,0])
  // Recenter minkowski origin to (0,0).
    minkowski() {
      linear_extrude(height = length,
                    center = true,
                    convexity = 10,
                    twist = 0)

      polygon(
          points=[ [0,0,],
                   [triangle_height - ( 2 * corner_radius ),0],
                   [0,triangle_height - ( 2 * corner_radius )] ],

          paths=[ [0,1,2] ]
      );

      cylinder(h=length, r=corner_radius);
  }
}


// recessed_screw_cutout( rdepth, rdiam, slength, screw_diam, mod_fn );
module recessed_screw_cutout( recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam,
                              mod_fn=$fn) {

  translate([ 0, 0, screw_length ])
    cylinder( h=recess_depth, d=recess_diam, $fn=mod_fn );


  cylinder( h=screw_length, d=screw_diam, $fn=mod_fn );

}

// Taken and modified from children.scad in Examples.
module make_ring_of(radius, count, theta)
{
  for (a = [0 : count - 1]) {
      angle = a * theta / count;
      translate(radius * [sin(angle), -cos(angle), 0])
          rotate([0, 0, angle])
              children();
  }
}

// Build_it function just for testing out each module
// during development.
module build_it() {

}

// *** MAIN ***  //
// build_it();
// Nothing should be here.
