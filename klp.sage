import itertools
n=5

R.<q>=QQ[]
W = CoxeterGroup(['C', n] , implementation='coxeter3')
s=W.simple_reflections()

indices=sum([list(range(1,i)) for i in range(n,1,-1)],[])
wP=W.prod([s[i] for i in indices])

#KL = KazhdanLusztigPolynomial(W, q)

def coxeterWord(zoWord):
  return W.prod([s[i] for i in coxeterList(zoWord)])

def coxeterList(zoWord):
  if zoWord==(): return []
  subList=[x+1 for x in coxeterList(zoWord[1:])]
  if (zoWord[0]==0): return subList
  if (zoWord[0]==1):
    k=len(zoWord)
    return ([i for i in range(1,k)]+[i for i in range(k,0,-1)]+subList)

for zoWord in itertools.product(*([[1,0]]*n)):
#  for inner in itertools.product(*([[1,0]]*n)):
#    W.kazhdan_lusztig_polynomial(inner,zoWord)
  print W.product(coxeterWord(zoWord),wP)
  print('\n')

#print [KL.P(x,s[2]*s[1]) for x in [1,s[1],s[2],s[2]*s[1]*s[2]]]

#p=KL.P(smaller*wP,bigger*wP)
#print (all [p(1)<=obs(bigger,smaller)])
