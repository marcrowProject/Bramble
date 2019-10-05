CC=g++
CFLAGS=-g -c -Wall -Wextra -ansi -std=c++11 -Wno-unused-parameter -Wno-unused-function
LDFLAGS= -g
SOURCES=src/gadget.cpp ../src/tools.cpp ../src/crypt.cpp
OBJECTS=$(SOURCES:.cpp=.o)
#Crée les dépendances avec les .h si un .h modifié on refait le make
DEPS=$(SOURCES:.cpp=.d)
EXECUTABLE=gadget

all: $(SOURCES) $(EXECUTABLE) wifi

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

wifi : src/wifi.cpp
		$(CC) $(LDFLAGS) -std=c++11 src/wifi.cpp -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) $< -o $@

#Crée les dépendances avec les .h si un .h modifié on refait le make
%.d: %.cpp
	$(CC) -MM -MD $(CFLAGS) $< -o $@
clean:
	rm -f gadget src/*.o src/*.d src/*~ *~
	rm -f wifi src/*.o src/*.d src/*~ *~


#Crée les dépendances avec les .h si un .h modifié on refait le make
-include $(DEPS)
