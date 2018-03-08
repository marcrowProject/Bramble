CC=g++
CFLAGS=-g -c -Wall -Wextra -ansi -std=c++11 -Wno-unused-parameter -Wno-unused-function
LDFLAGS= -g
SOURCES=src/vacuum.cpp ../src/tools.cpp
OBJECTS=$(SOURCES:.cpp=.o)
#Crée les dépendances avec les .h si un .h modifié on refait le make
DEPS=$(SOURCES:.cpp=.d)
EXECUTABLE=keyVacuum

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) $< -o $@

#Crée les dépendances avec les .h si un .h modifié on refait le make
%.d: %.cpp
	$(CC) -MM -MD $(CFLAGS) $< -o $@
clean:
	rm -f keyVacuum src/*.o src/*.d src/*~ *~


#Crée les dépendances avec les .h si un .h modifié on refait le make
-include $(DEPS)
