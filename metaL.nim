
import tables,strutils

## extended frame model

type Frame* = ref object # of RootObj
  tag *: string
  val : string
  nest: seq[Frame]
  slot: Table[string, Frame]

proc newFrame*(T:string,V:string): Frame = Frame(tag:T,val:V)

## dump

proc pad(this:Frame,depth=0): string =
    var pad = "\n"
    for i in 1..depth: pad = pad & '\t'
    return pad
proc head(this:Frame,prefix=""): string =
    prefix & "<" & this.tag & ":" & this.val & "> @" & (cast[uint](this.unsafeAddr)).toHex
proc dump(this:Frame,depth=0,prefix=""): string =
    var tree = this.pad(depth) & this.head(prefix)
    for ikey,ival in this.slot:
      tree &= ival.dump(depth+1, prefix = ikey & " = ")
    for j in this.nest:
      tree &= j.dump(depth+1)
    return tree
proc `$`*(this:Frame): string = this.dump()
  
## operators

proc `//`*(this:Frame,that:Frame): Frame =
    this.nest.add(that)
    return this
proc `<<`*(this:Frame,that:Frame): Frame =
    this.slot[that.val] = that
    return this

## Primitives

type Primitive = Frame
type Symbol = Primitive
type String = Primitive
type Number = Primitive
type Integer = Number
type Hex = Integer
type Bin = Integer

## Data containers

type Container = Frame
type Vector = Container
type Stack = Container
type Dict = Container
type Queue = Container

## Executable Data Structure

type Active = Frame
type Cmd = Active
type VM* = Active
type Seq = Active

proc newVM*(V:string):VM = VM(tag:"vm",val:V)
