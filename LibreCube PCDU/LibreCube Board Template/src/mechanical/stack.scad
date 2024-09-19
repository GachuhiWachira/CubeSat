////////////////////////////////////////////////////////////////////////////////
// LibreCube Board Stack
// (all dimensions in mm)

use <board_assembly.scad>;

$fa = 0.5; // default minimum facet angle
$fs = 0.5; // default minimum facet size

standoff_body_height = 15.00;//15.24; // 0.600 mil
standoff_body_dia = 6.35; // 0.25 mil
standoff_screw_height = 8; 
standoff_screw_dia = 3.175;

pcb_height = 1.57;

standoff_pos = [[5.08,5.08],
            [85.09,5.08],
            [8.89,90.81],
            [82.55,90.81]];

module standoff()
{
    margin = 1;
    color("silver")
        difference()
        {
            union()
            {
                cylinder(h=standoff_body_height,d=standoff_body_dia);
                translate([0,0,-standoff_screw_height])
                    cylinder(h=standoff_screw_height,d=standoff_screw_dia);  
            }  
            translate([0,0,standoff_body_height-standoff_screw_height])
                cylinder(h=standoff_screw_height+margin,d=standoff_screw_dia);      
        }
}

module stack()
{
    for (i = standoff_pos)
    {
        translate([i[0],i[1],-standoff_body_height]) 
            standoff();
    } 
    
    for (z = [0:3])
    {
        translate([0,0,z*(standoff_body_height+pcb_height)])
        {
            board_assembly();
            for (i = standoff_pos)
            {
                translate([i[0],i[1],pcb_height]) 
                    standoff();
            }             
        }
    }
}

stack();
