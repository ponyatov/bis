
import os, strutils, tables

import metaL

const MODULE  = "bis"
const TITLE   = "Business Intelligence System"
const AUTHOR  = "Dmitry Ponyatov"
const EMAIL   = "dponyatov@gmail.com"
const LICENSE = "2019 All rights reserved"

## global object graph / virtual machine

let vm = newVM("metaL")

echo vm

# when isMainModule:
#   echo("\nHello, World! ",MODULE,' ',TITLE)
#   echo(Frame(tag:"Hello",val:"World"))
#   echo(Frame(tag:"1",val:"Hello") // Frame(tag:"1",val:"World") << Frame(tag:"2",val:"3"))

let hello = newFrame("Hello","World")
let onetwo = newFrame("one","two")
let somth  = newFrame("some","thing")
echo "\npush:",hello // onetwo, "\nhello:", hello , "\nshift:", hello << somth