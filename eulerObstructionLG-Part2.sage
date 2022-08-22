import itertools
import numpy
import pickle

n=5
filename='euObsLG5.txt'
#0 means vertical, (0,0,0,0) is the minimal word.

def decPart(zoWord):
  n=len(zoWord)
  t=[str(n-i) for i in range(n) if zoWord[i]==1]
  if (t==[]): return '()'
  return ''.join(t)

def decP(zoWord):
  n=len(zoWord)
  return tuple([n-i for i in range(n) if zoWord[i]==1])

def flipAt(i,zoWord):
    if i==len(zoWord): return zoWord[:-1]+(1-zoWord[-1],)
    return zoWord[:i-1]+(zoWord[i],zoWord[i-1])+zoWord[i+1:]

def bar(i,zoWord):
    if i==len(zoWord): return zoWord[:-1]
    return zoWord[:i-1]+zoWord[i+1:]

def isLessThan(u,w):
    if not(len(u)==len(w)): return('Incomparable Words')
#    if u==w: return False
    return all([data[u].perm[i]<=data[w].perm[i] for i in range(len(u))]+[not(u==w)])

def indentCorrespondingToRoot(i,zoWord): return (i-data[zoWord].cWord[i-1],1+data[zoWord].cWord[i-1])

def rootCorrespondingToIndent(x):
  (i,j)=x
  return (i+j-1)

def capacity(x,w): 
  (i,j)=x
  return max([min(k-i,j-l) for (k,l) in data[w].indents if (k>=i and l<=j)])

def obs(u,v):
    if (u==v): return 1
    if isLessThan(v,u): return obstruction[u][v]
    return 0

data={}
data[(0,)]=mkWord((0,))
data[(1,)]=mkWord((1,))
obstruction={(0,): {(0,): 1}, (1,): {(0,): 1, (1,): 1}}
for i in range(2,n+1):
  for zoWord in itertools.product(*([[1,0]]*i)):
    data[zoWord]=mkWord(zoWord)
    obstruction[zoWord]={}

for i in range(2,n+1):
  for zoWord in itertools.product(*([[1,0]]*i)):
    for inner in [x for x in itertools.product(*([[1,0]]*i)) if isLessThan(x,zoWord)]:
      root=data[inner].ascent[-1]
      if (root not in data[zoWord].ascent):
        obstruction[zoWord][inner]=obs(zoWord,flipAt(root,inner))
      else:
        barInner=bar(root,inner)
        barZoWord=bar(root,zoWord)
        sign=1
        if root==i: sign=(-1)**capacity(indentCorrespondingToRoot(root,zoWord),inner)
        obstruction[zoWord][inner]=obs(zoWord,flipAt(root,inner)) + sign*obs(barZoWord,barInner)
       
#print ('Generating allNumbers')
#allNumbers=set()
#for diction in obstruction.values():
#  allNumbers=allNumbers.union(set(diction.values()))
#print allNumbers
#print (min(allNumbers))
list4=['()','1','2','21','3','4','31','41','32','42','321','43','421','431','432','4321']

list5=['()','1','2','21','3','31','4','5','32','41','51','321','42','52','421','43','521','53','431','54','531','432','541','532','4321','542','5321','543','5421','5431','5432','54321']


decToZo=dict({})
for zoWord in itertools.product(*([[1,0]]*n)):
  decToZo[decPart(zoWord)]=zoWord

file=open(filename,'w')
for outer in list5:
  file.write('\ncMa('+str(outer)+') = ')
  for inner in list5:
    file.write('+ ')
    file.write(str(obs(decToZo[outer],decToZo[inner])))
    file.write(' CSM('+inner+')')
file.close()

