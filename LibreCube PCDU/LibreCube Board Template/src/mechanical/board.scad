////////////////////////////////////////////////////////////////////////////////
// LibreCube Board (all dimensions in mm)

$fa = 0.05; // default minimum facet angle
$fs = 0.05; // default minimum facet size

pitch = 2.54; // pitch between pins

pcb_width = 90.17;
pcb_depth = 95.89;
pcb_height = 1.57;

pin_width = 0.64;
pin_height = 12.19;
pins_per_row = 26;

hole_dia = 3.18; 
pad_dia = 6.35;  
via_dia = 1.016; // 0.40 mil

pin_H1_01_pos = [13.97, 83.19, 0]; 
pin_H2_01_pos = [13.97, 88.27, 0]; 

hole_pos = [[5.08, 5.08],
            [85.09, 5.08],
            [8.89, 90.81],
            [82.55, 90.81]];

fillet_radius = 1.2;  
fillet_radius_left = 1.0;

margin = 0.1; // to remove surfaces with zero thickness

module fillet(r, h) 
{
    translate([r/2,r/2,0])
        difference() 
        {
            cube([r+margin, r+margin, h], center=true);
            translate([r/2, r/2, 0])
                cylinder(r=r, h=h+1, center=true);
        }
}

module bottom_cutout()
{
    difference()
    {
        cube([56.39-36.07,2.92+margin,3*pcb_height]);
        // round corners
        translate([0,2.92+margin,pcb_height])
            rotate([0,0,-90])
                fillet(fillet_radius, 5*pcb_height); 
        translate([56.39-36.07,2.92+margin,pcb_height])
            rotate([0,0,180])
                fillet(fillet_radius, 5*pcb_height); 
    }
    // round corners
    translate([0,margin,pcb_height])
        rotate([0,0,90])
            fillet(fillet_radius, 5*pcb_height); 
    translate([56.39-36.07,0,pcb_height])
        rotate([0,margin,0])
            fillet(fillet_radius, 5*pcb_height);    
}

module left_cutout()
{
    difference()
    {
        cube([2.92+margin,58.08-37.81,3*pcb_height]);
        // round corners
        translate([2.92+margin,0,pcb_height])
            rotate([0,0,90])
                fillet(fillet_radius_left, 5*pcb_height); 
        translate([2.92+margin,58.08-37.81,pcb_height])
            rotate([0,0,180])
                fillet(fillet_radius_left, 5*pcb_height); 
    }
    // round corners
    translate([margin,58.08-37.81,pcb_height])
        rotate([0,0,0])
            fillet(fillet_radius_left, 5*pcb_height); 
    translate([margin,0,pcb_height])
        rotate([0,0,-90])
            fillet(fillet_radius_left, 5*pcb_height);  
}

module cutouts()
{
    // bottom edge cutout
    translate([36.07,-margin,-pcb_height])
        bottom_cutout();

     // top edge cutout
    scale([1,-1,1])
        translate([36.07,-95.89-margin+0.01,-pcb_height])
            bottom_cutout();

    // left edge cutout
    translate([-margin,37.81,-pcb_height])
        left_cutout();
 
    // right edge cutout
    scale([-1,1,1])
        translate([-pcb_width-margin,37.81,-pcb_height])
            left_cutout();
}

module pcb()
{
    color("green") 
        difference()
        {
            cube([pcb_width,pcb_depth,pcb_height]);
            // round corners
            translate([0,0,0])
                rotate([0,0,0])
                    fillet(fillet_radius, 3*pcb_height);
            translate([pcb_width,0,0])
                rotate([0,0,90])
                    fillet(fillet_radius, 3*pcb_height);
            translate([pcb_width,pcb_depth,0])
                rotate([0,0,180])
                    fillet(fillet_radius, 3*pcb_height); 
            translate([0,pcb_depth,0])
                rotate([0,0,-90])
                    fillet(fillet_radius, 3*pcb_height); 
            
            // add the cutouts on each side
            cutouts();
        }
}

module hole()
{
    cylinder(h=pcb_height+2,d=hole_dia);
}

module holes()
{  
    for (i = hole_pos)
    {
        translate([i[0],i[1],-1]) 
            hole();
    }           
}

module via()
{
    cylinder(h=pcb_height+2,d=via_dia);
}

module vias()
{
    for (x = [0:pins_per_row-1])
    { 
        for (y = [0:1])
        {
            translate([x*pitch,y*pitch,-1])
                via();
        }
    }   
}

module board()
{
    union()
    {
        difference() 
        {
            pcb();
            holes();
            translate(pin_H1_01_pos)
                vias();
            translate(pin_H2_01_pos)
                vias(); 
        }    
    }
}

board();
