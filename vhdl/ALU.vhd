-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Tue Oct 29 17:44:16 2013"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ALU IS 
	PORT
	(
		a :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		b :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		op :  IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
		s :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ALU;

ARCHITECTURE bdf_type OF ALU IS 


SIGNAL	addsub :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	s_carry :  STD_LOGIC;
SIGNAL	comp_r :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	logic_r :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	shift_r :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	zero :  STD_LOGIC;


BEGIN 

b2v_add_sub_0 : ENTITY work.add_sub
PORT MAP(sub_mode => op(3),
		 a => a,
		 b => b,
		 carry => s_carry,
		 zero => zero,
		 r => addsub);


b2v_comparator_0 : ENTITY work.comparator
PORT MAP( a_31 => a(31),
		 b_31 => b(31),
		 diff_31 => addsub(31),
		 carry => s_carry,
		 zero => zero,
		 op => op(2 DOWNTO 0),
		 r => comp_r(0));



b2v_logic_unit_0 : ENTITY work.logic_unit
PORT MAP(a => a,
		 b => b,
		 op => op(1 DOWNTO 0),
		 r => logic_r);


b2v_multiplexer_0 : ENTITY work.multiplexer
PORT MAP(i3 => addsub,
		 i2 => comp_r,
		 i1 => logic_r,
		 i0 => shift_r,
		 sel => op(5 DOWNTO 4),
		 o => s);


b2v_shift_unit_0 : ENTITY work.shift_unit
PORT MAP(a => a,
		 b => b(4 DOWNTO 0),
		 op => op(2 DOWNTO 0),
		 r => shift_r);


comp_r(31 DOWNTO 1) <= "0000000000000000000000000000000";
END bdf_type;