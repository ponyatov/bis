
import os,sys
import flask

## extended frame model

class Frame:
    def __init__(self,V):
        self.type = self.__class__.__name__.lower()
        self.val  = V
        self.slot = {}
        self.nest = []

    ## dump

    def __repr__(self):
        return self.dump()
    def dump(self,depth=0,prefix=''):
        tree = self._pad(depth) + self.head(prefix)
        if not depth: Frame._dumped = []
        if self in Frame._dumped: return tree + ' _/'
        else: Frame._dumped.append(self)
        for i in self.slot:
            tree += self.slot[i].dump(depth+1,prefix='%s = '%i)
        for j in self.nest:
            tree += j.dump(depth+1)
        return tree
    def head(self,prefix=''):
        return '%s<%s:%s> @%x' % (prefix,self.type,self._val(),id(self))
    def _pad(self,depth):
        return '\n' + '\t' * depth
    def _val(self):
        return '%s' % self.val

    ## operators

    def __getitem__(self,key):
        return self.slot[key]
    def __setitem__(self,key,that):
        self.slot[key] = that ; return self
    def __lshift__(self,that):
        self[that.val] = that ; return self
    def __floordiv__(self,that):
        self.nest.append(that) ; return self

    def pop(self):
        return self.nest.pop(-1)
    def top(self):
        return self.nest[-1]

## Primitives

class Primitive(Frame): pass
class Symbol(Primitive): pass
class String(Primitive): pass
class Number(Primitive): pass
class Integer(Number): pass
class Hex(Integer): pass
class Bin(Integer): pass

## Data containers

class Container(Frame): pass
class Vector(Container): pass
class Stack(Container): pass
class Dict(Container): pass
class Queue(Container): pass

## Executable Data Structure

class Active(Frame): pass
class VM(Active): pass
class Seq(Active,Vector): pass

## global object graph / virtual machine

vm = VM('metaL')

import ply.lex as lex

tokens = ['symbol']

def t_sym(t):
    r'[^ \t\r\n\#\\]+'
    return Symbol(t.value)

def t_ANY_error(t): raise SyntaxError(t)

def WORD(ctx):
    token = ctx.lexer.token()
    if token: ctx // token
    return token

def INTERP(ctx):
    ctx.lexer = lex.lex() ; ctx.lexer.input(ctx.pop().val)
    while True:
        if not WORD(ctx): break
        if isinstance(ctx.top(),Symbol):
            if not FIND(ctx): raise SyntaxError(ctx)
        EVAL(ctx)

if __name__ == '__main__':
    with open(sys.argv[0][:-3]+'.ini') as SRC:
        vm // String(SRC.read()) ; INTERP(vm)
