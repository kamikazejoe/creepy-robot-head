// Mock-up of Arduino Dimensions
module arduino() {
    difference() {
        color("lightblue")
            cube([68.6,53.4,21]);

/*    
// mounting holes are 0mm x 0mm, 0 diameter
        translate([3.5,3.5,0])
            cylinder(h=22, d=2.75);
        
        translate([3.5,52.5,0])
            cylinder(h=22, d=2.75);
        
        translate([61.5,52.5,0])
            cylinder(h=22, d=2.75);
        
        translate([61.5,3.5,0])
            cylinder(h=22, d=2.75);
*/
    }
}


module arduino_mount_bracket() {
   difference() {
      translate([0,0,0])
         cube([58.1,50,5]);
      
      translate([6,6,-3])
         cube([45.1,44,10]);
   }
}   
      
module arduino_mount_screw_holes() {
   
        translate([0,0,-10])
            cylinder(h=22, d=2.75, $fn=20);
        
        translate([1.3,48,-10])
            cylinder(h=22, d=2.75, $fn=20);
        
        translate([52.1,33,-10])
            cylinder(h=22, d=2.75, $fn=20);
        
        translate([52.1,5.1,-10])
            cylinder(h=22, d=2.75, $fn=20);
}


// Basic flat base plate shape.
module base_plate() {
    linear_extrude(height = 5, center = false, convexity = 10, twist = 0)
        polygon(
            points=[ [20,0],[0,20],[0,130],[20,150],[80,150],[100,130],[100,20],[80,0] ],
            paths=[ [0,1,2,3,4,5,6,7] ]
        );
}



// Screw mounting slot
module cut_slot() {
    //translate([5,5,-3])
      //  rotate([0,0,0])
            hull() {
                cylinder(h=10, d=3, $fn=20);
                    
                translate([0,60,0])
                    cylinder(h=100, d=3, $fn=20);
                }
}

module smaller_slot() {
            hull() {
                cylinder(h=10, d=3, $fn=20);
                    
                translate([0,50,0])
                    cylinder(h=100, d=3, $fn=20);
                }
}

module slot_grid() {
   
   //Front
   translate([10,20,-3])
      smaller_slot();
   
   translate([10,80,-3])
      smaller_slot();
   
    for ( i = [20 : 10 : 80] )
    {
        translate([i, 5, -3])
            cut_slot();
    }
    
        for ( i = [20 : 10 : 80] )
    {
        translate([i, 85, -3])
            cut_slot();
    }
    
   //Back
   translate([90,20,-3])
      smaller_slot();
   
   translate([90,80,-3])
      smaller_slot();
}



module grid_plate() {
    difference() {
        base_plate();
        //cut_grid();
        slot_grid();
    }
    /*
   translate([92,49,0])
      rotate([0,0,90])
         arduino_mount_bracket();
    */
    
}

module build_upper_plate() {
        
   difference() {
        grid_plate();
        translate([97,100,0])
         rotate([0,0,180])
            arduino_mount_screw_holes();
      
   }

}


//projection() build_upper_plate();
