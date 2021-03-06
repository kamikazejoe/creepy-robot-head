/*
 * Project Name: Creepy Robot Head
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * 3D Models of Creepy Robot Head that will do stuff
 *
 * This isn't really a usable file.
 * It is just a mock-up for reference.
 *
 */


// *** INCLUDE/USE LIBRARIES *** //
include <fillets.scad>;

//Other Robot Head Parts
include <jaw.scad>;
include <bottom-jaw.scad>;
include <upper-jaw.scad>;
include <mid-deck.scad>;
include <upper-deck.scad>;
include <neck.scad>;
include <nasal_camera_mount.scad>;
include <nasal_bone.scad>;


// *** VARIABLES *** //
standard_fn = 10;


// *** MODULES AND FUNCTIONS *** //

module build_it() {

  translate([0,0,0]) {

    x_neck_A();
    x_neck_B();

  }

  translate([0,0,50]) {

      rotate([180,0,90])
        x_rotor_disc();

  }



  translate([0,0,60]) {

      rotate([180,0,0])
        x_collar_ring();

  }



  translate([ servo_dimension[1] / 2, 0, 140 ]) { //- servo_dimension[1] / 2, 140 ]) {

    rotate([0,-90,90])
      y_servo_block_inverse();

  }

  translate([ servo_dimension[1] / 2, servo_dimension[1] * .75, 140 ]) {

    rotate([0,-90,90])
      y_axis_pivot();

  }

  translate([ servo_dimension[1] / 2, 0 - servo_dimension[1], 140 ]) {

    rotate([0,-90,90])
      y_axis_pivot();

  }


    translate([0, servo_dimension[2] / 2, 120]) {

      rotate([0,-90,90])
        y_servo_block_A();

      rotate([0,-90,90])
        y_servo_block_B();

  }



  translate([-75,0,175]) {

  //scale([0.25,0.25,0.25])
  translate([0,0,-10])
    rotate([0,0,0])
      bottom_jaw();

  //scale([0.25,0.25,0.25])
  translate([0,0,jaw_dimension[1]])
    rotate([180,0,0])
      upper_jaw();
  }


  translate([-100,0 - jaw_radius,225]) {
    nasal_bone();

  }


  translate([-130,0 - jaw_radius,250]) {
    rotate([0,90,0])
      picam_mount_plate();

  }


  translate([-75,-75,250]) {
    build_with_mount_holes();

  }



  translate([-50,-75,300]) {
    build_upper_plate();

  }




}

// *** MAIN ***  //
build_it();
