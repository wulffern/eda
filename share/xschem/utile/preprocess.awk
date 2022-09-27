#!/usr/bin/awk -f
# File: preprocess.awk
# 
# This file is part of XSCHEM,
# a schematic capture and Spice/Vhdl/Verilog netlisting tool for circuit
# simulation.
# Copyright (C) 1998-2021 Stefan Frederik Schippers
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

# 


function expand_file(file,      err)
{
  while ((err=getline  < file) > 0)
  {
    if($1 ~ /^.?include$/) {
      expand_file($2)
    }
    else process_line()
  }
  if(err) {
    print "file: " file " not found." > "/dev/stderr"
    exit
  }
  close(file)
}


{
  if($1 ~ /^.?include$/)
  {
    expand_file($2)
  }
  else process_line()
}

function process_line(       a)
{
  if($0 ~ /^[ \t]*;/) { return }
  sub(/;/," ;",$0)
  if($3 ~/^%/){
    a=$0
    sub(/^[^%]*%/,"",a)
    sub(/%[^%]*$/,"",a)
    gsub(/ /,"_", a)
    sub(/%[^%]*%/, "%" a "%")
  }
  print
}



