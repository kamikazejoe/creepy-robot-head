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
[0, 0, 0],     		// vector[1]
[0, 0, 0],			// vector[2]
[0, 0, 0]      		// vector[3]
];
        

 */

// *** INCLUDE/USE LIBRARIES *** //
use <shapes.scad>;
use <fillets.scad>;
use <kamikaze_shapes.scad>;

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

Neck_Servo_Height      = 38;
Neck_Servo_Width       = 40;
Neck_Servo_Depth       = 20;

Neck_Servo_Sub_Height  = 28;

neck_servo_overhang    = 7;

screw_diameter = 3;
screw_head_diameter = 7;

// Breakdown of servo width.
// Front to Axis, Axis Diameter, Axis to Rear.
neck_servo_axis_width = [ 6.75, 6.0, 27.25 ];

print_gap = 2;

neck_servo_dimension = [ Neck_Servo_Height,
                         Neck_Servo_Width,
                         Neck_Servo_Depth ];

neck_servo_cavity = [ Neck_Servo_Sub_Height + print_gap,
                      neck_servo_dimension[1] + print_gap,   // Width
                      neck_servo_dimension[2] + print_gap ]; // Depth
                      
neck_servo_recess = [ Neck_Servo_Width + neck_servo_overhang,
                      Neck_Servo_Depth,
                      Neck_Servo_Height - Neck_Servo_Sub_Height]; 

standard_fn = 100;



// *** MODULES AND FUNCTIONS *** //


// Dummy servo block for comparison during development.
module dummy_neck_servo() {
    
    color("lightblue")
        cube(neck_servo_dimension);
        
}


// Size of the cavity that servos will fit in.
module neck_servo_cutout() {
    
    cube(neck_servo_cavity);
    
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



module x_neck_base( neck_height, neck_radius, mod_fn=$fn ) {
      
    cylinder( h = neck_height, r = neck_radius, $fn=mod_fn );
    
}



module x_neck_base_half( neck_height, neck_radius, mod_fn=$fn ) {
       
    difference() {
        
        x_neck_base( neck_height, neck_radius);
        
        translate([ 0 - neck_radius,0,0])
            cube([ 2 * neck_radius, neck_radius, neck_height ]);
    }
}



module recessed_screw_cutout( recess_depth, 
                              recess_diam, 
                              screw_length, 
                              screw_diam, 
                              mod_fn=$fn) {
    
    translate([ 0, 0, screw_length ])
    cylinder( h=recess_depth, d=recess_diam, $fn=mod_fn );
    

    cylinder( h=screw_length, d=screw_diam, $fn=mod_fn );
    
}



module cable_path_cutout() {
    
    
    
}



module neck_servo_recess_cutout() {
  
  translate([0,0,0])
    rotate([0,0,0])
      cube(neck_servo_recess);
  
}

module x_neck_A() {
    
    neck_height = neck_servo_cavity[0];
    neck_radius =  ( neck_servo_axis_width[1] / 2 )
                     + neck_servo_axis_width[2]
                     + neck_servo_overhang
                     + screw_head_diameter + print_gap
                     + screw_diameter;
                      //   Half the axis diameter
                      // + Remaining width of the server
                      // + Servo overhang
                      // + Screw recess diameter
                      // + Screw Diameter ( Arbitrary figure for structure )

    screw_diam   = screw_diameter + print_gap;
    screw_length = screw_diameter + 1;
    recess_diam  = screw_head_diameter + print_gap;
    recess_depth = neck_radius - screw_diam - ( recess_diam / 2 );

    servo_loc = [ 0 - neck_servo_axis_width[0] 
                  - ( neck_servo_axis_width[1] / 2 ),
                  neck_servo_cavity[2] / 2,
                  neck_servo_cavity[0]];
    
    recess_loc_x = neck_radius - screw_diam - ( recess_diam / 2 );
    recess_loc_y = 1;
    recess_loc_z = neck_height / 2;
      
    recess_loc = [[recess_loc_x, recess_loc_y, recess_loc_z],
                  [ 0 - recess_loc_x, recess_loc_y, recess_loc_z]];
                  
                  
    
    difference() {
        
        translate([0,0,0])
            rotate([0,0,0])
                x_neck_base_half( neck_height, neck_radius);
        
        translate(servo_loc)
            rotate([90,90,0])
                neck_servo_cutout();
                
        translate([servo_loc[0], 0 - (neck_servo_recess[1] / 2), neck_height - neck_servo_recess[2]])
            rotate([0,0,0])
                neck_servo_recess_cutout();
                
        translate(recess_loc[0])
            rotate([90,0,0])
                recessed_screw_cutout(recess_depth,
                                      recess_diam,
                                      screw_length,
                                      screw_diam);
                
        translate(recess_loc[1])
            rotate([90,0,0])
                recessed_screw_cutout(recess_depth,
                                      recess_diam,
                                      screw_length,
                                      screw_diam);
                
        translate([0,0,0])
            rotate([0,0,0])
                cable_path_cutout();
                
    }
    
    translate([0,0,neck_height]) // Will need to be adjusted for servo horn.
    rotate([0,0,-72])
    make_ring_of(neck_radius - screw_diam, 5, 180)
      sphere(3);
    
}



module x_neck_B() {
    
    neck_height = neck_servo_cavity[0];
    neck_radius =  ( neck_servo_axis_width[1] / 2 )
                     + neck_servo_axis_width[2]
                     + neck_servo_overhang
                     + screw_head_diameter + print_gap
                     + screw_diameter;
                      //   Half the axis diameter
                      // + Remaining width of the server
                      // + Servo overhang
                      // + Screw recess diameter
                      // + Screw Diameter ( Arbitrary figure for structure )

    screw_diam   = screw_diameter + print_gap;
    screw_length = screw_diameter + 1;
    recess_diam  = screw_head_diameter + print_gap;
    recess_depth = neck_radius - screw_diam - ( recess_diam / 2 );

    servo_loc = [ 0 - neck_servo_axis_width[0] 
                  - ( neck_servo_axis_width[1] / 2 ),
                  neck_servo_cavity[2] / 2,
                  neck_servo_cavity[0]];
    
    recess_loc_x = neck_radius - screw_diam - ( recess_diam / 2 );
    recess_loc_y = -1;
    recess_loc_z = neck_height / 2;
      
    recess_loc = [[recess_loc_x, recess_loc_y, recess_loc_z],
                  [ 0 - recess_loc_x, recess_loc_y, recess_loc_z]];
                  
                  
    
    difference() {
        
        translate([0,0,0])
            rotate([0,0,180])
                x_neck_base_half( neck_height, neck_radius);
        
        translate(servo_loc)
            rotate([90,90,0])
                neck_servo_cutout();
                
        translate(recess_loc[0])
            rotate([90,0,180])
                recessed_screw_cutout(recess_depth,
                                      recess_diam,
                                      screw_length,
                                      screw_diam);
                
        translate(recess_loc[1])
            rotate([90,0,180])
                recessed_screw_cutout(recess_depth,
                                      recess_diam,
                                      screw_length,
                                      screw_diam);
                
        translate([0,0,0])
            rotate([0,0,0])
                cable_path_cutout();
                
    }
    
}



// Build_it function just for testing out each module
// during development.
module build_it() {
    
    //dummy_neck_servo();
    //neck_servo_cutout();
	//x_neck_base();
    //x_neck_base_half();
    //recessed_screw_cutout( 10, 10, 5, 5 );
    x_neck_A();
    //x_neck_B();
    //neck_servo_recess_cutout();
}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
