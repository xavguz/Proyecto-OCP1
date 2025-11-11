game: main.c
	gcc -o game main.c

.PHONY: clean
clean:
	rm game

.PHONY: run
run: 
	./game
