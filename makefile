一、Makefile介绍

1. make的编译和链接规则：
   如果这个工程没有编译过，那么我们的所有c文件都要编译并被链接。
   如果这个工程的某几个c文件被修改，那么我们只编译被修改的c文件，并链接目标程序。
   如果这个工程的头文件被改变了，那么我们需要编译引用了这几个头文件的c文件，并链接目标程序
2. makefile的规则：
   target ... ： prerequisites...
      command (此处注意：command必须以tab键为开头)  -command：加减号的意义是也许某些文件出现问题，但不要管，继续做后面的事
3. Makefile里主要包含了五个东西：显式规则、隐晦规则（自动推导）、变量定义、文件指示和注释。
   文件指示：一是在一个Makefile中引用另一个Makefile，就像C语言中 的include一样；另一个是指根据某些情况指定Makefile中的有效部分，就像C语言中的预编译
   #if一 样；还有就是定义一个多行的命令。
4. Makefile文件名：GNUMakefile（GNU专用）、Makefile（推荐）、makefile
5. 文件引用：include <filename> filename 可以使用shell的文件模式（路径和通配符） eg：include ../../make*
   make命令开始时，会找寻 include 所指出的其它Makefile，并把其内容安置在当前的位置。就好 像C/C++的 #include 指令一样。如果文件都没有指定绝对路径或是
   相对路径的话，make会在当前目 录下首先寻找，如果当前目录下没有找到，那么，make还会在下面的几个目录下找：
      如果make执行时，有 -I 或 --include-dir 参数，那么make就会在这个参数所指定的目 录下去寻找。
      如果目录 <prefix>/include （一般是： /usr/local/bin 或 /usr/include ）存在的话，make也会去找。
   如果有文件没有找到的话，make会生成一条警告信息，但不会马上出现致命错误。它会继续载入其它的 文件，一旦完成makefile的读取，make会再重试这些没有找到，
   或是不能读取的文件，如果还是 不行，make才会出现一条致命信息。如果你想让make不理那些无法读取的文件，而继续执行，你可以 在include前加一个减号“-”。
6. 环境变量MAKEFILES:如果你的当前环境中定义了环境变量 MAKEFILES ，那么，make会把这个变量中的值做一个类似于 include 的动作。这个变量中的值是其它的Makefile，
   用空格分隔。只是，它和 include 不 同的是，从这个环境变量中引入的Makefile的“目标”不会起作用，如果环境变量中定义的文件发现 错误，make也会不理。一般不适用
7. makefile的工作方式：
   读入所有的Makefile。
   读入被include的其它Makefile。
   初始化文件中的变量。
   推导隐晦规则，并分析所有规则。
   为所有的目标文件创建依赖关系链。
   根据依赖关系，决定哪些目标要重新生成。
   执行生成命令

二、书写规则：一个是依赖关系，一个是生成目标的方法。make会以UNIX的标准Shell，也就是 /bin/sh 来执行命令

1. 规则中的通配符：
   *: 
   ~:
   ?:
