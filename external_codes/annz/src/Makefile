CPP = c++

all: annz_net annz_train annz_test

annz_net: annz_net.cpp
	$(CPP) -o annz_net annz_net.cpp

network.o: network.h network.cpp util.o
	$(CPP) -O3 -c network.cpp

train_network.o: train_network.h train_network.cpp
	$(CPP) -O3 -c train_network.cpp

test_network.o: test_network.h test_network.cpp
	$(CPP) -O3 -c test_network.cpp

util.o: util.cpp util.h
	$(CPP) -O3 -c util.cpp

train.o: train.cpp train.h
	$(CPP) -O3 -c train.cpp

test.o: test.cpp test.h
	$(CPP) -O3 -c test.cpp

annz_test: annz_test.cpp network.o util.o test.o test_network.o
	$(CPP) -O3 -o annz_test annz_test.cpp test_network.o network.o util.o test.o

annz_train: annz_train.cpp network.o util.o train.o train_network.o
	$(CPP) -O3 -o annz_train annz_train.cpp train_network.o network.o util.o train.o

clean:
	rm *.o *~
