SYM_API=../../deps/llvm-verifier/sym-api
CP=.:../../deps/jvm-verifier/support/galois.jar

%.ll: %.c
	clang -S -emit-llvm -I$(SYM_API) $< -o $(shell basename $< .c).ll

%.bc: %.ll
	llvm-as $<

%.bc: %.c
	clang -emit-llvm -I$(SYM_API) -c $< -o $(shell basename $< .c).bc

%.out: %.c
	clang -I$(SYM_API) $(SYM_API)/sym-api.c $< -o $(shell basename $< .c).out

%.class: %.java
	javac -cp $(CP):../jars/galois.jar $<

%.jvm-asm: %.java
	javap -c -classpath $(CP):../jars/galois.jar $(shell basename $< .java) > $@
