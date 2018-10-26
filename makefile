HEADERS = filter_num.h logger.h features.h
#headers = 
NOMOBJS =  filter_num.o logger.o features.o # no email objects
OBJS =  $(NOMOBJS) main.o 
TOBJS = $(NOMOBJS) tests.o
#objects = main.o
#SOURCES = filter_numerical_columns.c main.c
NOMSOURCES = filter_num.cpp logger.cpp features.cpp # sources excluding main.cpp
SOURCES = $(NOMSOURCES) main.cpp
TSOURCES = $(NOMSOURCES) tests.cpp # test sources
CXXFLAGS = -std=c++11 
CC = g++
OBJ_DIR = build
SRC_DIR = src
BIN_DIR = bin
LIBS = -lhdt -pthread
TLIBS = $(LIBS) -lgtest
TESTAPP = bin/testtadanum
COVAPP = bin/covtadanum
COVCLEANFILES = gcov.css snow.png ruby.png *.gcov  *.gcda *.gcno index-sort-f.html index-sort-l.html index.html \
				amber.png glass.png updown.png coverage.info emerald.png Users usr v1\
#objects_with_dir = $(patsubst %, $(OBJ_DIR/%),$(OBJ_DIR))

#$(BIN_DIR)/tadanum : $(objects_with_dir)
#	echo $(objects_with_dir)
#	$(CC) -o $(BIN_DIR)/tadanum $(objects)
#	mv *.o $(OBJ_DIR) 

#$(OBJ_DIR)/%.o :  $(SRC_DIR)/%.cpp
#	$(CC) -c $(SRC_DIR)/$(SOURCES)

OBJS_ABS = $(patsubst %,$(OBJ_DIR)/%,$(OBJS))
TOBJS_ABS = $(patsubst %,$(OBJ_DIR)/%,$(TOBJS))
SOURCES_ABS = $(patsubst %,$(SRC_DIR)/%,$(SOURCES))
TSOURCES_ABS = $(patsubst %,$(SRC_DIR)/%,$(TSOURCES))


$(BIN_DIR)/tadanum : $(OBJS_ABS)
	$(CC) -o $@ $? $(LIBS)

$(OBJS_ABS): $(SOURCES_ABS)
	$(CC) $(CXXFLAGS) -c $(SOURCES_ABS)
	mv *.o build/

.PHONY: clean run debug test cov cleancov gcov

debug: 
	$(CC) $(CXXFLAGS) -g -c $(SOURCES_ABS)
	mv *.o build/
	$(CC) -g  -o bin/tadanum $(OBJS_ABS) $(LIBS)
	#gdb bin/tadanum
	valgrind --tool=massif bin/tadanum --time-unit=B --stacks=yes

test:
	$(CC) -c $(TSOURCES_ABS)
	mv *.o build/
	$(CC) -o $(TESTAPP) $(TOBJS_ABS) $(TLIBS)
	$(TESTAPP)

cov:
	#$(CC) -c -fprofile-arcs -ftest-coverage $(TSOURCES_ABS)
	#mv *.o build/
	#$(CC) -o $(COVAPP) -fprofile-arcs -ftest-coverage $(TOBJS_ABS) $(TLIBS) 
	#$(COVAPP)
	#gcov src/tests.cpp -o=. 
	#gcov src/*.cpp -o=. 
	#lcov -c  --directory .  --output-file coverage.info
	#genhtml coverage.info --output-directory . 
	$(CC) -c -fprofile-arcs -ftest-coverage -fPIC  $(TSOURCES_ABS)
	mv *.o build/
	$(CC) -o $(COVAPP) -fprofile-arcs -ftest-coverage $(TOBJS_ABS) $(TLIBS) 
	$(COVAPP)
	gcovr -r .
	#$(MAKE) clean
	# Only this line is needed for the coverage badge of codedev.io
	lcov --directory . --capture --output-file coverage.info
	$(MAKE) clean

gcov:
	$(CC) -c -fprofile-arcs -ftest-coverage $(TSOURCES_ABS)
	mv *.o build/
	$(CC) -o $(COVAPP) -fprofile-arcs -ftest-coverage $(TOBJS_ABS) $(TLIBS)
	$(COVAPP)


cleancov:
	-rm -Rf $(COVCLEANFILES)
	
run: 
	bin/tadanum

clean:
	-rm $(BIN_DIR)/* 
	-rm $(OBJ_DIR)/* 
	$(MAKE) cleancov
