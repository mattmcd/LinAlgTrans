all: LinAlgExpr.g ExprGen.g 
	mkdir -p generated
	mkdir -p classes
	java org.antlr.Tool -o generated LinAlgExpr.g
	java org.antlr.Tool -o generated ExprGen.g
	javac -cp $$CLASSPATH:generated -d classes Main.java LinAlg.java generated/*.java

run:
	java -cp $$CLASSPATH:classes Main test2.txt

jar:
	jar cfm linalgtrans.jar manifest.txt -C classes .

deploy: linalgtrans.jar Python.stg
	cp linalgtrans.jar LinAlgTrans/war/WEB-INF/lib
	cp antlrworks-1.4.3.jar LinAlgTrans/war/WEB-INF/lib
	cp Python.stg LinAlgTrans/war/WEB-INF

test:
	java -cp $$CLASSPATH:classes org.antlr.gunit.Interp LinAlgExpr.gunit

testline:
	java -cp $$CLASSPATH:classes Main

test01:
	java -cp $$CLASSPATH:classes Main test01.txt

test02:
	java -cp $$CLASSPATH:classes Main test02.txt

test02mex:
	java -cp $$CLASSPATH:classes Main test02.txt MEXWrapper.stg

test03: 
	java -cp $$CLASSPATH:classes Main test03.txt

test04: 
	java -cp $$CLASSPATH:classes Main test04.txt

appdir:
	mkdir -p WrapperGen
	mkdir -p WrapperGen/src/META-INF
	mkdir -p WrapperGen/war/WEB-INF/classes
	mkdir -p WrapperGen/war/WEB-INF/lib
