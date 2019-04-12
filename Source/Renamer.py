import time



def rename(f:str, t:bool):
    r = open(f, "r").readlines()
    w = open(f, "w")
    w.write(sub_num(r, w) if t else add_num(r, w))

def sub_num(r, w):
    t = ""
    for l in r: t += l[6:len(l)]
    return t

def add_num(r, w):
    t = ""
    for n, l in enumerate(r):
        while len(n) < 6: n="0"+str((n+1)*100)
        t += n + l
    return t


rename('day10/Phnprt01.cbl', True)
#rename('day10/Phnprt01.cbl', False)

