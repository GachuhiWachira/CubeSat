////////////////////////////////////////////////////////////////////////////////
// LibreCube Board
// (all dimensions in mm)

include <board.scad>;

$fa = 0.05; // default minimum facet angle
$fs = 0.05; // default minimum facet size

conn_width = pins_per_row * pitch + 0.51;
conn_depth = 4.95;
conn_height = 11.05;

// pin offset from connector edge
pin_offset_x = (conn_width - (pins_per_row-1) * pitch - pin_width)/2;
pin_offset_y = (conn_depth - pitch - pin_width)/2; 

module pin()
{
    color("gold")
        cube([pin_width,pin_width,pin_height]);      
}

module pins()
{    
    translate([0,0,-pin_height])
    {
        for (x = [0:pins_per_row-1])
        { 
            for (y = [0:1])
            {
                translate([x*pitch+pin_offset_x,y*pitch+pin_offset_y,0])
                    pin(); 
            }
        }    
    }    
}

module connector()
{  
    difference()
    {
        color("grey") 
            cube([conn_width,conn_depth,conn_height]);
        translate([0,0,pin_height+1])   
            pins();
    }
    pins();
}

module board_assembly()
{
    union()
    { 
        board(); 
        translate(pin_H1_01_pos + [-pin_offset_x-pin_width/2,-pin_offset_y-pin_width/2,pcb_height])
            connector();
        translate(pin_H2_01_pos + [-pin_offset_x-pin_width/2,-pin_offset_y-pin_width/2,pcb_height])
            connector();
    }
}

board_assembly();
