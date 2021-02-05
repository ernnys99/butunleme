hesapmakinesi: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o hesapmakinesi

lex.yy.c: y.tab.c hesapmakinesi.l
	lex hesapmakinesi.l

y.tab.c: hesapmakinesi.y
	yacc -d hesapmakinesi.y

