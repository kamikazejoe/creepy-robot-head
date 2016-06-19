// Mount for Raspberry Pi Camera Module

// Camera Mounting Bracket
module camera_mount() {
    difference() {
        union() {
            
           /*
            // Camera Struts
            translate([8,0,0])
                cube([62,4,3]);
            
            translate([8,21,0])
                cube([62,4,3]);
            */
           
           translate([8,0,0])
                cube([45,4,3]);
            
            translate([8,21,0])
                cube([45,4,3]);
           
            /*
            // Lower Anchor slot
            translate([72,0,0])
                cube([2,25,25]);
            
            translate([72,0,0])
                cube([6,25,2]);
            
            translate([78,0,0])
                cube([2,25,25]);
            */
           
            // Upper Anchor slot
            translate([0,0,0])
                cube([2,25,25]);
            
            translate([2,0,0])
                cube([6,25,5]);
            
            translate([6,0,0])
                cube([2,25,25]);
            
           
           
            // Lower Support Wedges
            /*
            translate([70,4,0])
                rotate([0,-90,90])
                    linear_extrude(height = 4, center = false, convexity = 10, twist = 0)
                    polygon(
                    points=[ [0,0],[0,25],[25,0] ],
                    paths= [ [0,1,2] ]
                    );
            
            translate([70,25,0])
                rotate([0,-90,90])
                    linear_extrude(height = 4, center = false, convexity = 10, twist = 0)
                    polygon(
                    points=[ [0,0],[0,25],[25,0] ],
                    paths= [ [0,1,2] ]
                    );
            
            translate([73,25,0])
                rotate([0,-90,90])
                    linear_extrude(height = 25, center = false, convexity = 10, twist = 0)
                    polygon(
                    points=[ [0,0],[0,10],[10,0] ],
                    paths= [ [0,1,2] ]
                    );*/
            
            // Upper support wedge
            translate([8,0,25])
                rotate([-90,0,0])
                    linear_extrude(height = 25, center = false, convexity = 10, twist = 0)
                        polygon(
                            points=[ [0,0],[0,25],[5,25] ],
                            paths=[ [0,1,2] ]
                        );

            // Opposite Upper support wedge
            translate([0,25,25])
                rotate([-90,0,180])
                    linear_extrude(height = 25, center = false, convexity = 10, twist = 0)
                        polygon(
                            points=[ [0,0],[0,25],[5,25] ],
                            paths=[ [0,1,2] ]
                        );
                  
            // Lower Cross-beam        
            translate([50,0,0])
                cube([5,25,3]);            
            
            
            // Upper Cross-beam        
            translate([7,0,0])
                cube([7,25,3]);
        }
        
        // Screw holes
        translate([25,2,-5])
            rotate([0,0,0])
                cylinder(h=10, d=2.5, $fn=20);
        
        translate([25,23,-5])
            rotate([0,0,0])
                cylinder(h=10, d=2.5, $fn=20);
        
        translate([37.5,2,-5])
            rotate([0,0,0])
                cylinder(h=10, d=2.5, $fn=20);
        
        translate([37.5,23,-5])
            rotate([0,0,0])
                cylinder(h=10, d=2.5, $fn=20);
    }
    
}

camera_mount();