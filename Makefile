#
# @file Makefile
#

DEVKEY=other/developer_key
TARGET=bin/eWillowSwf.prg
DEVICE?=vivoactive3

.PHONY = all
all:
	monkeyc -o $(TARGET) -w -y $(DEVKEY) -d $(DEVICE)_sim -s 2.3.0 -f ./monkey.jungle

.PHONY = clean
clean:
	rm -rf bin

.PHONY = run
run:
	monkeydo $(TARGET) $(DEVICE)
