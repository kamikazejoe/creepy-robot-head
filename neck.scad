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
 * Don't forget the cable channels!
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
[0, 0, 0],     		// vector[1]
[0, 0, 0],			// vector[2]
[0, 0, 0]      		// vector[3]
];
        

 */

// *** INCLUDE/USE LIBRARIES *** //
include <MG995_servos.scad>;

use <shapes.scad>;
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

//x_neck_height = servo_cavity[0];
x_neck_height = servo_dimension[0];

x_neck_radius =  ( servo_top[1] / 2 )
                 + servo_top[2]
                 + servo_overhang
                 + screw_head_diameter + print_gap
                 + screw_diameter;
                  //   Half the axis diameter
                  // + Remaining width of the server
                  // + servo overhang
                  // + Screw recess diameter
                  // + Screw Diameter ( Arbitrary figure for structure )



screw_diameter = 3;
screw_head_diameter = 7;
                  
screw_diam   = screw_diameter + print_gap;
screw_length = screw_diameter + 1;
recess_diam  = screw_head_diameter + print_gap;
recess_depth = x_neck_radius - screw_diam - ( recess_diam / 2 );

standard_fn = 100;



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
module cable_path_cutout() {
    
    
    
}



module x_rotor_disc() {
  
  
  
}


module x_collar_ring() {
  
  
  
}



module x_collar_mount() {
  
  height = x_neck_height;
  diam = recess_diam;
  
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
    
    translate([0,0, height - screw_length])
      cylinder( h=screw_length, d=screw_diam );
    
  }
}

// Left half of the base for the x-axis servo
module x_neck_A() {
    
    servo_loc = [ 0 - servo_top[0] - ( servo_top[1] / 2 ),
                  servo_cavity[2] / 2,
                  servo_cavity[0]];
    
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
    
    difference() {
        
        
        // Base
        translate([0,0,0])
            rotate([0,0,0])
                x_neck_base_half( x_neck_height, x_neck_radius);
        
        
        
        
        // Servo cavity
        translate(servo_loc)
            rotate([90,90,0])
                servo_cutout();
                
        translate(servo_rec_loc)
            rotate([0,0,0])
                servo_recess_cutout();
        
        translate([0,0,0])
            rotate([0,0,0])
                cable_path_cutout();
                
                
                
        
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
    
    translate([0,0,x_neck_height]) // Will need to be adjusted for servo horn.
      rotate([0,0,-72])
        make_ring_of(x_neck_radius - screw_diam, 5, 180)
          sphere(3);
          
    
    // Collar mount points
    translate(col_mnt_loc)
          x_collar_mount();
    
}



// Right half of the base for the x-axis servo
module x_neck_B() {
    
    mirror([0,1,0]) x_neck_A();
    
}



// Build_it function just for testing out each module
// during development.
module build_it() {
    
    //dummy_servo();
    //servo_cutout();
	//x_neck_base();
    //x_neck_base_half();
    //recessed_screw_cutout( 10, 10, 5, 5 );
    x_neck_A();
    //x_neck_B();
    //servo_recess_cutout();
}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
