/*
 * Project Name: Creepy Robot Head - Neck
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
include <MG995_servos.scad>;

//use <shapes.scad>;
use <fillets.scad>;
use <kamikaze_shapes.scad>;

// *** VARIABLES *** //

/* Dimensions for MG995 servo
    *Most values from datasheet

        ~6.75     ~27.25
        [---][-------------]
            6.0
            ||
~6.0 >  |------------------|      ---
~2.6 >-------------------------    |
        |                  | ^ 7.0 |
        |                  |       |
        | < 28.00          |       38
        |                  |       |
     ===|                  |       |
        |__________________|      ---

        |------ 40.0 ------|

     --------------------------   ---
     |  |                  |  |    |
     |  |   O              |  |    20.0
     |  |                  |  |    |
     --------------------------   ---

*/

x_neck_height = servo_dimension[0];

x_neck_radius =  ( servo_top[1] / 2 )
                 + servo_top[2]
                 + servo_overhang
                 + screw_head_diameter + print_gap
                 + screw_diameter + print_gap;
                  //   Half the axis diameter
                  // + Remaining width of the server
                  // + servo overhang
                  // + Screw recess diameter
                  // + Screw Diameter ( Arbitrary figure for structure )



screw_diameter = 3;
screw_head_diameter = 6;

screw_diam   = screw_diameter;
screw_length = screw_diameter + 1;
recess_diam  = screw_head_diameter + print_gap;
recess_depth = x_neck_radius - screw_diam - ( recess_diam / 2 );

standard_fn = 100;
print_gap = 2;



// *** MODULES AND FUNCTIONS *** //

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



// Makes the large cylindrical base
module x_neck_base( x_neck_height, x_neck_radius, mod_fn=$fn ) {

  cylinder( h = x_neck_height, r = x_neck_radius, $fn=mod_fn );

}



// Cut's the base cylinder in half.
module x_neck_base_half( x_neck_height, x_neck_radius, mod_fn=$fn ) {

  difference() {

      x_neck_base( x_neck_height, x_neck_radius);

      translate([ 0 - x_neck_radius,0,0])
          cube([ 2 * x_neck_radius, x_neck_radius, x_neck_height ]);
  }
}



// Make room for the servo's pigtail.
module cable_path_cutout( depth, diam, height ) {

  cble_co_diam = diam;
  cble_co_depth = depth;
  cble_co_height = height;

  cylinder( h=cble_co_depth, d=cble_co_diam);

  translate([0 - cble_co_diam, 0 - cble_co_diam / 2, 0])
    cube([ cble_co_height, cble_co_diam, cble_co_depth ]);

}



module x_rotor_disc() {

  disc_diam = 2 * x_neck_radius;
  disc_height = screw_head_diameter;

  disc_track_loc = x_neck_radius - screw_diam - ( recess_diam / 2 );

  y_axis_radius = ( servo_overhang * 3 ) // 3 time for thicker structure
                  + servo_top[0]
                  + ( servo_top[1] / 2)
                  + print_gap;

  y_inv_blk_width = y_axis_radius + ( 2 * screw_head_diameter ) + ( 2 * print_gap );

  y_pivot_blk_x = servo_dimension[0];
  y_pivot_blk_y = y_axis_radius
                + ( 2 * screw_head_diameter )
                + ( 2 * print_gap );
  y_pivot_blk_z = servo_dimension[0] / 4;

  screw_rec_loc_x0 = 0;
  screw_rec_loc_y0 = (y_inv_blk_width / 2)
                      - (recess_diam / 2)
                      - print_gap;
  screw_rec_loc_z0 = 0;

  screw_rec_loc_x1 = 0;
  screw_rec_loc_y1 = 0 - (y_inv_blk_width / 2)
                     + (recess_diam / 2)
                     + print_gap;
  screw_rec_loc_z1 = 0;

  screw_rec_loc_x2 = y_pivot_blk_z * 2.5;
  screw_rec_loc_y2 = (y_inv_blk_width / 2)
                      - (recess_diam / 2)
                      - print_gap;
  screw_rec_loc_z2 = 0;

  screw_rec_loc_x3 = y_pivot_blk_z * 2.5;
  screw_rec_loc_y3 = 0 - (y_inv_blk_width / 2)
                     + (recess_diam / 2)
                     + print_gap;
  screw_rec_loc_z3 = 0;

  screw_rec_loc_x4 = 0 - (y_pivot_blk_z * 2.5);
  screw_rec_loc_y4 = (y_inv_blk_width / 2)
                      - (recess_diam / 2)
                      - print_gap;
  screw_rec_loc_z4 = 0;

  screw_rec_loc_x5 = 0 - (y_pivot_blk_z * 2.5);
  screw_rec_loc_y5 = 0 - (y_inv_blk_width / 2)
                     + (recess_diam / 2)
                     + print_gap;
  screw_rec_loc_z5 = 0;


  screw_rec_loc = [[screw_rec_loc_x0, screw_rec_loc_y0, screw_rec_loc_z0],
                   [screw_rec_loc_x1, screw_rec_loc_y1, screw_rec_loc_z1],
                   [screw_rec_loc_x2, screw_rec_loc_y2, screw_rec_loc_z2],
                   [screw_rec_loc_x3, screw_rec_loc_y3, screw_rec_loc_z3],
                   [screw_rec_loc_x4, screw_rec_loc_y4, screw_rec_loc_z4],
                   [screw_rec_loc_x5, screw_rec_loc_y5, screw_rec_loc_z5]];

  difference() {

    cylinder( h=disc_height, d=disc_diam);

    cylinder( h=disc_height, d=screw_head_diameter + print_gap );

    translate([0,0,disc_height + print_gap])
      rotate_extrude()
        translate([disc_track_loc,0,0])
          circle( r=screw_diam + print_gap );

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

    translate(screw_rec_loc[2])
      rotate([0,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(screw_rec_loc[3])
      rotate([0,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(screw_rec_loc[4])
      rotate([0,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(screw_rec_loc[5])
      rotate([0,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);
  }

}


module x_collar_ring() {

  ring_height = screw_head_diameter * 2;

  cutout_radius = x_neck_radius - screw_diam - ( recess_diam / 2 );
  groove_radius = x_neck_radius + print_gap;
  ring_radius = x_neck_radius + screw_diam + print_gap;

  col_mnt_loc_x = 0;
  col_mnt_loc_y = 0 - x_neck_radius - (recess_diam / 2) + 1;
  col_mnt_loc_z = 0;

  col_mnt_loc = [ col_mnt_loc_x, col_mnt_loc_y, col_mnt_loc_z ];

  difference() {

    union() {

      cylinder( h=ring_height, r=ring_radius );

      // Collar mount points
      translate(col_mnt_loc)
        x_collar_mount(ring_height, recess_diam);

      // Collar mount points
      mirror([0,1,0])
        translate(col_mnt_loc)
          x_collar_mount(ring_height, recess_diam);
    }


    translate([0,0, ring_height / 2])
      cylinder( h=ring_height, r=groove_radius );

    cylinder( h=ring_height, r=cutout_radius );

    translate(col_mnt_loc)
      cylinder( h=ring_height, d=screw_diam );

    mirror([0,1,0])
      translate(col_mnt_loc)
        cylinder( h=ring_height, d=screw_diam );

  }




}



module x_collar_mount( height, diam ) {

  //height = x_neck_height;
  //diam = recess_diam;

  lfx_loc = 0 - (diam / 2);
  lfy_loc = diam / 2;
  lfz_loc = 0;

  rfx_loc = diam / 2;
  rfy_loc = diam / 2;
  rfz_loc = 0;

  left_fillet_loc  = [ lfx_loc, lfy_loc, lfz_loc];
  right_fillet_loc = [ rfx_loc, rfy_loc, rfz_loc];


  difference() {

    union() {

      translate([ 0 - ( diam / 2 ), 0, 0])
        cube([ diam, diam / 2, height ]);

      translate([0,0,0])
        rotate([0,0,0])
          cylinder(h=height,d=recess_diam);



      translate(left_fillet_loc)
        rotate([0,0,180])
          fillet_linear_i(height, diam / 2 , fillet_fn=standard_fn);

      translate(right_fillet_loc)
        rotate([0,0,-90])
          fillet_linear_i(height, diam / 2, fillet_fn=standard_fn);
    }

    translate([0,0,0])
      cylinder( h=height, d=screw_diam );

  }
}




// Left half of the base for the x-axis servo
module x_neck_A() {

  servo_loc = [ 0 - servo_top[0] - ( servo_top[1] / 2 ),
                0 - servo_cavity[1] / 2,
                0];

  screw_rec_loc_x = x_neck_radius - screw_diam - ( recess_diam / 2 );
  screw_rec_loc_y = 1;
  screw_rec_loc_z = x_neck_height / 2;

  screw_rec_loc = [[screw_rec_loc_x, screw_rec_loc_y, screw_rec_loc_z],
                   [ 0 - screw_rec_loc_x, screw_rec_loc_y, screw_rec_loc_z]];

  servo_rec_loc_x = servo_loc[0] - servo_overhang;
  servo_rec_loc_y = 0 - (servo_recess[1] / 2);
  servo_rec_loc_z = x_neck_height - servo_recess[2];

  servo_rec_loc = [servo_rec_loc_x, servo_rec_loc_y, servo_rec_loc_z];

  col_mnt_loc_x = 0;
  col_mnt_loc_y = 0 - x_neck_radius - (recess_diam / 2) + 1;
  col_mnt_loc_z = 0;

  col_mnt_loc = [ col_mnt_loc_x, col_mnt_loc_y, col_mnt_loc_z ];

  cble_co_diam = servo_side[1] + print_gap;
  cble_co_depth = x_neck_radius - servo_top[0];
  cble_co_height = servo_side[0] + ( servo_side[1] / 2 );

  cble_co_loc_x = 0 - servo_top[0];
  cble_co_loc_y = 0;
  cble_co_loc_z = servo_side[0];

  cble_co_loc = [ cble_co_loc_x, cble_co_loc_y, cble_co_loc_z ];


  difference() {


    // Base
    translate([0,0,0])
      rotate([0,0,0])
        x_neck_base_half( x_neck_height, x_neck_radius);




    // Servo cavity
    translate(servo_loc)
      rotate([0,0,0])
        servo_cutout();

    translate(servo_rec_loc)
      rotate([0,0,0])
        servo_recess_cutout();

    translate(cble_co_loc)
      rotate([0,-90,0])
        cable_path_cutout( cble_co_depth, cble_co_diam, cble_co_height );




    // Screw points
    translate(screw_rec_loc[0])
      rotate([90,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(screw_rec_loc[1])
      rotate([90,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

  }

  // Poor man's bearings.
  translate([0,0,x_neck_height]) // Will need to be adjusted for servo horn.
    rotate([0,0,-72])
      make_ring_of(screw_rec_loc_x, 5, 180)
        sphere(screw_diam);


  // Collar mount points
  translate(col_mnt_loc)
    x_collar_mount(x_neck_height, recess_diam);

}



// Right half of the base for the x-axis servo
module x_neck_B() {

  mirror([0,1,0]) x_neck_A();

}



module y_servo_block_A() {

  y_axis_radius = ( servo_overhang * 3 ) // 3 time for thicker structure
                  + servo_top[0]
                  + ( servo_top[1] / 2);

  y_axis_depth = servo_dimension[0];

  add_block_length = [ y_axis_radius + ( servo_overhang * 3 ),
                       2 * y_axis_radius,
                       y_axis_depth ];

  abl_loc = [ 0 - add_block_length[0],
              0 - ( add_block_length[1] / 2),
              0];

  servo_loc = [ 0 - (servo_top[1] / 2) - servo_top[2],
                0 - servo_cavity[1] / 2,
                0];


  servo_rec_loc_x = 0 - (servo_top[1] / 2) - servo_top[2] - servo_overhang;
  servo_rec_loc_y = 0 - (servo_recess[1] / 2);
  servo_rec_loc_z =  y_axis_depth - servo_recess[2];

  servo_rec_loc = [servo_rec_loc_x, servo_rec_loc_y, servo_rec_loc_z];

  cble_co_diam = servo_side[1] + print_gap;
  cble_co_depth = y_axis_radius - (servo_top[1] / 2) - servo_top[0];
  cble_co_height = servo_side[0] + ( servo_side[1] / 2 );

  cble_co_loc_x = 0 + cble_co_depth + (servo_top[1] / 2) + servo_top[0];
  cble_co_loc_y = 0;
  cble_co_loc_z = servo_side[0];

  cble_co_loc = [ cble_co_loc_x, cble_co_loc_y, cble_co_loc_z ];

  chop_in_half = [ add_block_length[0] + y_axis_radius,
                   y_axis_radius,
                   y_axis_depth ];

  screw_rec_loc_x0 = (chop_in_half[0] / 2)
                     - screw_diam
                     - ( recess_diam / 2 )
                     - (y_axis_radius / 2);

  screw_rec_loc_y0 = 1;
  screw_rec_loc_z0 = y_axis_depth / 2;

  screw_rec_loc_x1 = 0 - add_block_length[0] + screw_diam + ( recess_diam / 2 ) + servo_overhang;
  screw_rec_loc_y1 = 1;
  screw_rec_loc_z1 = y_axis_depth / 2;


  screw_rec_loc = [[screw_rec_loc_x0, screw_rec_loc_y0, screw_rec_loc_z0],
                   [screw_rec_loc_x1, screw_rec_loc_y1, screw_rec_loc_z1]];

  mount_screw_loc0 = [ 0 - add_block_length[0],
                       0 - (y_axis_radius / 2),
                       servo_cavity[2] ];

  mount_screw_loc1 = [ 0 - add_block_length[0],
                       0 - (y_axis_radius / 2),
                       servo_dimension[1] - servo_cavity[2] ];

  difference() {

    union() {

      cylinder( h=y_axis_depth, r=y_axis_radius );

      translate(abl_loc)
        cube(add_block_length);

    }

    // Servo cavity
    translate(servo_loc)
      rotate([0,0,0])
        servo_cutout();

    translate(servo_rec_loc)
      rotate([0,0,0])
        servo_recess_cutout();

    translate(cble_co_loc)
      rotate([0,-90,0])
        cable_path_cutout( cble_co_depth, cble_co_diam, cble_co_height );

    translate([ 0 - add_block_length[0], 0, 0 ])
      cube(chop_in_half);


    // Screw points
    translate(screw_rec_loc[0])
      rotate([90,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(screw_rec_loc[1])
      rotate([90,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(mount_screw_loc0)
      rotate([0,90,0])
        cylinder( h=screw_length, d=screw_diam );


    translate(mount_screw_loc1)
      rotate([0,90,0])
        cylinder( h=screw_length, d=screw_diam );

  }
}



module y_servo_block_B() {

  mirror([0,1,0]) y_servo_block_A();

}


module y_servo_block_inverse() {

  y_axis_radius = ( servo_overhang * 3 ) // 3 time for thicker structure
                  + servo_top[0]
                  + ( servo_top[1] / 2)
                  + print_gap;

  y_axis_depth = servo_dimension[0];

  inv_block = [ servo_dimension[1],
                y_axis_radius
                + ( 2 * screw_head_diameter )
                + ( 2 * print_gap ),
                y_axis_depth ];

  screw_rec_loc_x0 = inv_block[0];
  screw_rec_loc_y0 = recess_diam / 2 + print_gap;
  screw_rec_loc_z0 = y_axis_depth / 2;

  screw_rec_loc_x1 = inv_block[0];
  screw_rec_loc_y1 = inv_block[1] - print_gap - ( recess_diam / 2);
  screw_rec_loc_z1 = y_axis_depth / 2;


  screw_rec_loc = [[screw_rec_loc_x0, screw_rec_loc_y0, screw_rec_loc_z0],
                   [screw_rec_loc_x1, screw_rec_loc_y1, screw_rec_loc_z1]];

  difference() {

    cube(inv_block);

    translate([ 0, (y_axis_radius / 2) + screw_head_diameter + print_gap, 0 ])
      cylinder( h=y_axis_depth, r=y_axis_radius);


    // Screw points
    translate(screw_rec_loc[0])
      rotate([90,0,-90])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    translate(screw_rec_loc[1])
      rotate([90,0,-90])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);

    }

}

module y_axis_pivot() {

  y_axis_radius = ( servo_overhang * 3 ) // 3 time for thicker structure
                  + servo_top[0]
                  + ( servo_top[1] / 2)
                  + print_gap;

  pivot_blk_x = servo_dimension[0];
  pivot_blk_y = y_axis_radius
                + ( 2 * screw_head_diameter )
                + ( 2 * print_gap );
  pivot_blk_z = servo_dimension[0] / 4;

  pivot_blk_dim = [ pivot_blk_x, pivot_blk_y, pivot_blk_z ];

  difference() {

    union() {

      cube(pivot_blk_dim);

      translate([0, pivot_blk_y / 2, 0])
        cylinder( h=pivot_blk_z, d=pivot_blk_y );
    }

    translate([0, pivot_blk_y / 2, 0])
      cylinder( h=pivot_blk_z, d=recess_diam );


    // Screw holes
    translate([pivot_blk_x, recess_diam / 2 + print_gap, pivot_blk_z / 2])
      rotate([0,-90,0])
        cylinder( h=screw_length, d=screw_diam );

    translate([pivot_blk_x, pivot_blk_y - (recess_diam / 2 + print_gap), pivot_blk_z / 2])
      rotate([0,-90,0])
        cylinder( h=screw_length, d=screw_diam );

  }
}


// Build_it function just for testing out each module
// during development.
module build_it() {

  //dummy_servo();
  //servo_cutout();
  //x_neck_base();
  //x_neck_base_half();
  //recessed_screw_cutout( 10, 10, 5, 5 );
  //x_neck_A();
  //x_neck_B();
  //servo_recess_cutout();
  //x_rotor_disc();
  //x_collar_ring();
  //y_servo_block_A();
  //y_servo_block_B();
  //y_servo_block_inverse();
  //y_axis_pivot();
  //translate([0- (38 / 2), -25, 40 + 6]) rotate([0,90,0]) y_servo_block_inverse();
  //translate([0- (38 * .75), -25, 40]) rotate([0,90,0]) y_axis_pivot();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
