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

1. 规则中的通配符：与Linux shell通配符基本一致
2. 文件搜寻：有三种方法
   1）文件前加路径
   2）VPATH变量：指定搜索的路径，当前路径是最高路径。eg：VPATH = src：../header 路径之间用:分隔
   3）vpath关键字：vpath <pattern> <directories>：为符合模式<pattern>的文件指定搜索目录<directories>
                  vpath <pattern>：清除符合模式<pattern>的文件的搜索目录。
                  vpath：清除所有已被设置好了的文件搜索目录。
3. 伪目标：“伪目标”并不是一个文件，只是一个标签，由于“伪目标”不是 文件，所以make无法生成它的依赖关系和决定它是否要执行。我们只有通过显式地指明这个“目标”
   才能让其 生效。当然，“伪目标”的取名不能和文件名重名，不然其就失去了“伪目标”的意义了。
   为了避免和文件重名的这种情况，我们可以使用一个特殊的标记“.PHONY”来显式地指明一个目标是“ 伪目标”，向make说明，不管是否有这个文件，这个目标就是“伪目标”。
   另外伪目标也可以作为默认目标，只要将其放在第一个，默认目标总是在第一个。
4. 多目标：当多个目标依赖一致，可以进行合并，若是生成规则不一样，则可以利用自动化变量$@（$@ 表示目标的 集合，就像一个数组， $@ 依次取出目标，并执于命令。）
   eg：bigoutput littleoutput : text.g
         generate text.g -$(subst output,,$@) > $@ subst是一个makefile函数，表示替换
5. 静态模式：
   <targets ...> : <target-pattern> : <prereq-patterns ...>
    <commands>
   targets定义了一系列的目标文件，可以有通配符。是目标的一个集合。
   target-parrtern是指明了targets的模式，也就是的目标集模式。
   prereq-parrterns是目标的依赖模式，它对target-parrtern形成的模式再进行一次依赖目标的定义。
   如果我们 的<target-parrtern>定义成 %.o ，意思是我们的<target>;集合中都是以 .o 结尾的，而 如果我们的<prereq-parrterns>定义成 %.c ，意思是对
   <target-parrtern>所形成的目标集进 行二次定义，其计算方法是，取<target-parrtern>模式中的 % （也就是去掉了 .o 这个结 尾），并为其加上 .c 这个结尾，
   形成的新集合。我们的“目标模式”或是“依赖模式”中都应该有 % 这个字符。
6. 自动生成依赖性：大多数的C/C++编译器都支持一个“-M”的选项，即自动找寻源文件中 包含的头文件，并生成一个依赖关系，如果你使用GNU的C/C++编译器，你得用 -MM
   参数，不然， -M 参数会把一些标准库的头文件也包含进来。
   eg：cc -M main.c 那么他的输出是main.o : main.c defs.h
   那么，编译器的这个功能如何与我们的Makefile联系在一起呢。因为这样一来，我们的Makefile也要根据这些源文件重新生成，让 Makefile自已依赖于源文件？这个功
   能并不现实，不过我们可以有其它手段来迂回地实现这一功能。GNU组织建议把编译器为每一个源文件的自动生成的依赖关系放到一个文件中，为每一个 name.c 的文件
   都生成一个 name.d 的Makefile文件， .d 文件中就存放对应 .c 文件的依赖关系。我们可以写出 .c 文件和 .d 文件的依赖关系，并让make自动更新或生成 .d 文件，
   并把其包含在我们的主Makefile中，这样，我们就可以自动化地生成每个文件的依赖关系了。我们可以使 用Makefile的“include”命令，来引入依赖文件。

三、书写命令
每条规则中的命令和操作系统Shell的命令行是一致的。make会一按顺序一条一条的执行命令，每条命令的 开头必须以 Tab 键开头，除非，命令是紧跟在依赖规则后面的分号
后的。在命令行之间中的空格或是 空行会被忽略，但是如果该空格或空行是以Tab键开头的，那么make会认为其是一个空命令
1. 显示命令：通常，make会把其要执行的命令行在命令执行前输出到屏幕上。当我们用 @ 字符在命令行前，那么， 这个命令将不被make显示出来，但是其他信息还会显示。
   eg： @echo 正在编译XXX模块      echo不会输出，但是‘正在编译XXX模块’会输出
   如果make执行时，带入make参数 -n 或 --just-print ，那么其只是显示命令，但不会执行 命令，这个功能很有利于我们调试我们的Makefile，看看我们书写的命令是执
   行起来是什么样子的或是什么顺序的。
   而make参数 -s 或 --silent 或 --quiet 则是全面禁止命令的显示。
2. 命令执行：当依赖目标新于目标时，也就是当规则的目标需要被更新时，make会一条一条的执行其后的命令。需要注意 的是，如果你要让上一条命令的结果应用在下一条命
   令时，你应该使用分号分隔这两条命令。比如你的第一 条命令是cd命令，你希望第二条命令得在cd之后的基础上运行，那么你就不能把这两条命令写在两行上，而 应该把这
   两条命令写在一行上，用分号分隔。
3. 命令出错：在命令前加上-号，表示出错之后不管它继续执行
4. 嵌套执行：
   总控Makefile：总控Makefile的变量可以传递到下级的Makefile中（如果 你显示的声明），但是不会覆盖下层的Makefile中所定义的变量，除非指定了 -e 参数。
   subsystem:
    cd subdir && $(MAKE)
   subsystem:
    $(MAKE) -C subdir
   如果需要传递变量到下级：export <variable ...>;
   如果不想穿：unexport <variable ...>;
   如果你要传递所有的变量，那么，只要一个export就行了。后面什么也不用跟，表示传递所有的变量。
   另外SHELL和MAKEFLAGS总是会下传。
5. 定义命令包：如果Makefile中出现一些相同命令序列，那么我们可以为这些相同的命令序列定义一个变量。定义这种命令 序列的语法以 define 开始，以 endef 结束
   eg：
   define run-yacc
   yacc $(firstword $^)
   mv y.tab.c $@
   endef
   “run-yacc”是这个命令包的名字，其不要和Makefile中的变量重名。使用时$(run-yacc)

四、使用变量
在Makefile中的定义的变量，就像是C/C++语言中的宏一样，他代表了一个文本字串，在Makefile中 执行的时候其会自动原模原样地展开在所使用的地方。其与C/C++所不
同的是，你可以在Makefile中改变其 值。在Makefile中，变量可以使用在“目标”，“依赖目标”， “命令”或是Makefile的其它部分中。变量的命名字可以包含字符、数字，
下划线（可以是数字开头），但不应该含有 : 、 # 、 = 或是空字符（空格、回车等）。变量是大小写敏感的，“foo”、“Foo”和“FOO”是三个不同的 变量名。传统的Makefile
的变量名是全大写的命名方式，但推荐使用大小写搭配的变量名，如： MakeFlags。这样可以避免和系统的变量冲突，而发生意外的事情。
1. 变量的基础：变量在声明时需要给予初值，而在使用时，需要给在变量名前加上 $ 符号，但最好用小括号 () 或是大括号 {} 把变量给包括起来。如果你要使用真实的 $ 字
   符，那么你需要用 $$ 来表示。
2. 括号的区别
3. 变量中的变量：变量可以用别的变量来定义，右侧的变量可以放到后面来定义，这样就可以推迟定义变量的定义。但是需要注意不要出现循环定义，比如A = $(B) B = $(A)
   这种情况需要用:=来进行定义，它会进行检测是否有循环定义，但是前面的变量不能使用后面的变量，只能使用前面已定义好了的变量。
   还有另外一个常用的?:操作符，其含义是如果定义了就什么不做，否则取后面的值。
   +=操作符：用于给变量追加值，如果变量之前没有定义过，那么， += 会自动变成 = ，如果前面有变量定义，那么 += 会 继承于前次操作的赋值符。如果前一次的是 := ，那么 += 会以 := 作为其赋值符
4. 变量的高级用法：
   1）变量替换：我们可以替换变量中的共有的部分，其格式是 $(var:a=b) 或是 ${var:a=b} ，其意思是， 把变量“var”中所有以“a”字串“结尾”的“a”替换成“b”字串。
      这里的“结尾”意思是“空格”或是“结束符”。eg：
      foo := a.o b.o c.o
      bar := $(foo:.o=.c)
   2）把变量的值再当成变量：a := $($(x))
5. override指示符：如果有变量是通常make的命令行参数设置的，那么Makefile中对这个变量的赋值会被忽略。如果你想 在Makefile中设置这类参数的值，那么，你可以使用“override”指示符。
   override <variable>; = <value>;
   override <variable>; := <value>;
   override <variable>; += <more text>;
6. 多行变量：define + endf定义
7. 环境变量：make运行时的系统环境变量可以在make开始运行时被载入到Makefile文件中，但是如果Makefile中已 定义了这个变量，或是这个变量由make命令行带入，那么系统的环境变量的值将被覆
   盖。（如果make指定 了“-e”参数，那么，系统环境变量将覆盖Makefile中定义的变量）
8. 目标变量：即局部变量，语法如下
   <target ...> : <variable-assignment>;
   <target ...> : overide <variable-assignment>；
   比如prog : CFLAGS = -g， 编译prog的时候会使用它自己的变量
9. 模式变量：比如%.o:...

五、使用条件判断
使用条件判断，可以让make根据运行时的不同情况选择不同的执行分支。条件表达式可以是比较变量的值， 或是比较变量和常量的值。
1. 语法
   <conditional-directive>
      <text-if-true>
   endif
   或
   <conditional-directive>
      <text-if-true>
   else
      <text-if-false>
   endif
eg: ifeq ($(A),$(B))
    else
    endif
   conditional-directive:ifeq ifneq ifdef ifndef
   
六、使用函数
1. 调用语法：$(<function> <arguments>) 或者 ${<function> <arguments>} <arguments> 为函数的参数， 参数间以逗号 , 分隔，而函数名和参数之间以“空格”分隔。函数调用以 $ 开头，
   以圆括号 或花括号把函数名和参数括起。
2. 字符串处理函数
   1）subst字符串替换行数：$(subst <from>,<to>,<text>) 把字串 <text> 中的 <from> 字符串替换成 <to> 。返回处理后的字符串
   2）patsubst模式字符串替换函数：$(patsubst <pattern>,<replacement>,<text>) 查找 <text> 中的单词（单词以“空格”、“Tab”或“回车”“换行”分隔）是否符合模式 <pattern> ，如果
      匹配的话，则以 <replacement> 替换。这里， <pattern> 可以 包括通配符 % ，表示任意长度的字串。如果 <replacement> 中也包含 % ，那么， <replacement> 中的这个 % 将是 
      <pattern> 中的那个 % 所代表的字串。 （可以用 \ 来转义，以 \% 来表示真实含义的 % 字符）返回处理后的字符串
   3）strip去空格函数：去掉 <string> 字串中开头和结尾的空字符。返回处理后的字符串
   4）findstring查找字符串函数：$(findstring <find>,<in>) 在字串 <in> 中查找 <find> 字串。 如果找到，那么返回 <find> ，否则返回空字符串。
   5）filter过滤函数：$(filter <pattern...>,<text>) 以 <pattern> 模式过滤 <text> 字符串中的单词，保留符合模式 <pattern> 的单词。可以有多个模式。返回符合模式 <pattern> 的字串
   6）filter-out反过滤函数：$(filter-out <pattern...>,<text>) 以 <pattern> 模式过滤 <text> 字符串中的单词，去除符合模式 <pattern> 的单词。可以有多个模式。返回不符合模式 <pattern> 的字串。
   7）sort排序函数：$(sort <list>) 给字符串 <list> 中的单词排序（升序）。返回排序后的字符串。
   8）word取单词函数：$(word <n>,<text>) 取字符串 <text> 中第 <n> 个单词。（从一开始） 返回字符串 <text> 中第 <n> 个单词。如果 <n> 比 <text> 中的 单词数要大，那么返回空字符串。
   9）wordlist取单词串函数：从字符串 <text> 中取从 <ss> 开始到 <e> 的单词串。 <ss> 和 <e> 是一个数字。返回字符串 <text> 中从 <ss> 到 <e> 的单词字串。如果 <ss> 比 <text> 中的单词数要大，
      那么返回空字符串。如果 <e> 大于 <text> 的单词数， 那么返回从 <ss> 开始，到 <text> 结束的单词串。
   10）words单词统计函数：$(words <text>) 统计 <text> 中字符串中的单词个数。 返回单词个数
   11）firstword首单词函数：$(firstword <text>)
2. 文件名操作函数
   1）dir 取目录函数：$(dir <names...>)从文件名序列 <names> 中取出目录部分。目录部分是指最后一个反斜杠（ / ）之前 的部分。如果没有反斜杠，那么返回 ./
   2）notdir取文件函数：$(notdir <names...>)
   3）suffix取后缀函数：$(suffix <names...>) 从文件名序列 <names> 中取出各个文件名的后缀
   4）basename取前缀函数：$(basename <names...>)
   5）addsuffix加后缀函数：$(addsuffix <suffix>,<names...>)
   6）addprefix加前缀函数：$(addprefix <prefix>,<names...>) 把前缀 <prefix> 加到 <names> 中的每个单词后面。
   7）join连接函数：$(join <list1>,<list2>) 把 <list2> 中的单词对应地加到 <list1> 的单词后面。如果 <list1> 的 单词个数要比 <list2> 的多，那么， <list1> 中的多出来的单词将保持原样。如果
      <list2> 的单词个数要比 <list1> 多，那么， <list2> 多出来的单词将被复制到 <list1> 中。
3. foreach函数：$(foreach <var>,<list>,<text>)这个函数的意思是，把参数 <list> 中的单词逐一取出放到参数 <var> 所指定的变量中， 然后再执行 <text> 所包含的表达式。每一次 <text> 会返回一个字
   符串，循环过程中， <text> 的所返回的每个字符串会以空格分隔，最后当整个循环结束时， <text> 所返回的 每个字符串所组成的整个字符串（以空格分隔）将会是foreach函数的返回值。<var> 最好是一个变量
   名， <list> 可以是一个表达式，而 <text> 中一般会 使用 <var> 这个参数来依次枚举 <list> 中的单词。
4. if函数：$(if <condition>,<then-part>) 或$(if <condition>,<then-part>,<else-part>)
5. call函数：call函数是唯一一个可以用来创建新的参数化的函数。你可以写一个非常复杂的表达式，这个表达式中， 你可以定义许多参数，然后你可以call函数来向这个表达式传递参数。
   $(call <expression>,<parm1>,<parm2>,...,<parmn>)
   当make执行这个函数时， <expression> 参数中的变量，如 $(1) 、 $(2) 等，会 被参数 <parm1> 、 <parm2> 、 <parm3> 依次取代。而 <expression> 的 返回值就是 call 函数的返回值。
6. origin函数：origin函数不像其它的函数，他并不操作变量的值，他只是告诉你你的这个变量是哪里来的？其语法是$(origin <variable>)
   返回值：
   undefined
   如果 <variable> 从来没有定义过，origin函数返回这个值 undefined
   default
   如果 <variable> 是一个默认的定义，比如“CC”这个变量，这种变量我们将在后面讲述。
   environment
   如果 <variable> 是一个环境变量，并且当Makefile被执行时， -e 参数没有被打开。
   file
   如果 <variable> 这个变量被定义在Makefile中。
   command line
   如果 <variable> 这个变量是被命令行定义的。
   override
   如果 <variable> 是被override指示符重新定义的。
   automatic
   如果 <variable> 是一个命令运行中的自动化变量。
7. shell函数：shell函数也不像其它的函数。顾名思义，它的参数应该就是操作系统Shell的命令。它和反引号“`”是 相同的功能。这就是说，shell函数把执行操作系统命令后的输出作为函数返回。
8. 控制函数：make提供了一些函数来控制make的运行。通常，你需要检测一些运行Makefile时的运行时信息，并且 根据这些信息来决定，你是让make继续执行，还是停止。
   $(error <text ...>)：产生一个致命错误，text是其信息
   $(warning <text ...>)：产生warning信息
   
七、Make的运行：
1. make的退出码：
   0：表示成功执行。
   1：如果make运行时出现任何错误，其返回1。
   2：如果你使用了make的“-q”选项，并且make使得一些目标不需要更新，那么返回2
2. 指定Makefile：make –f hchen.mk
3. 指定目标：下面是一些常用的目标
   all:这个伪目标是所有目标的目标，其功能一般是编译所有的目标。
   clean:这个伪目标功能是删除所有被make创建的文件。
   install:这个伪目标功能是安装已编译好的程序，其实就是把目标执行文件拷贝到指定的目标中去。
   print:这个伪目标的功能是例出改变过的源文件。
   tar:这个伪目标功能是把源程序打包备份。也就是一个tar文件。
   dist:这个伪目标功能是创建一个压缩文件，一般是把tar文件压成Z文件。或是gz文件。
   TAGS:这个伪目标功能是更新所有的目标，以备完整地重编译使用。
   check和test:这两个伪目标一般用来测试makefile的流程
   如果makefile中有多个目标，我们需要更新其中的一个而不是重新编译整个工程可用make 目标名
4. 检查规则：有时候，我们不想让我们的makefile中的规则执行起来，我们只想检查一下我们的命令，或是执行的序列。 于是我们可以使用make命令的下述参数：
   -n, --just-print, --dry-run, --recon
      不执行参数，这些参数只是打印命令，不管目标是否更新，把规则和连带规则下的命令打印出来，但不 执行，这些参数对于我们调试makefile很有用处。
   -t, --touch
      这个参数的意思就是把目标文件的时间更新，但不更改目标文件。也就是说，make假装编译目标，但不 是真正的编译目标，只是把目标变成已编译过的状态。
   -q, --question
      这个参数的行为是找目标的意思，也就是说，如果目标存在，那么其什么也不会输出，当然也不会执行 编译，如果目标不存在，其会打印出一条出错信息。
   -W <file>, --what-if=<file>, --assume-new=<file>, --new-file=<file>
      这个参数需要指定一个文件。一般是是源文件（或依赖文件），Make会根据规则推导来运行依赖于这个 文件的命令，一般来说，可以和“-n”参数一同使用，来查看这个依赖文件所发生的规则命令。
   结合-p 和 -v 来输出makefile被执行时的信息
5. make的参数：
   -b, -m
   这两个参数的作用是忽略和其它版本make的兼容性。
   -B, --always-make
   认为所有的目标都需要更新（重编译）。
   -C <dir>, --directory=<dir>
   指定读取makefile的目录。如果有多个“-C”参数，make的解释是后面的路径以前面的作为相对路径 ，并以最后的目录作为被指定目录。如：“make -C ~hchen/test -C prog”等价于 “make -C ~hchen/test/prog”。
   -debug[=<options>]
   输出make的调试信息。它有几种不同的级别可供选择，如果没有参数，那就是输出最简单的调试信息。 下面是<options>的取值：

   a: 也就是all，输出所有的调试信息。（会非常的多）
   b: 也就是basic，只输出简单的调试信息。即输出不需要重编译的目标。
   v: 也就是verbose，在b选项的级别之上。输出的信息包括哪个makefile被解析，不需要被重编 译的依赖文件（或是依赖目标）等。
   i: 也就是implicit，输出所以的隐含规则。
   j: 也就是jobs，输出执行规则中命令的详细信息，如命令的PID、返回码等。
   m: 也就是makefile，输出make读取makefile，更新makefile，执行makefile的信息。
   -d
   相当于“–debug=a”。
   -e, --environment-overrides
   指明环境变量的值覆盖makefile中定义的变量的值。
   -f=<file>, --file=<file>, --makefile=<file>
   指定需要执行的makefile。
   -h, --help
   显示帮助信息。
   -i , --ignore-errors
   在执行时忽略所有的错误。
   -I <dir>, --include-dir=<dir>
   指定一个被包含makefile的搜索目标。可以使用多个“-I”参数来指定多个目录。
   -j [<jobsnum>], --jobs[=<jobsnum>]
   指同时运行命令的个数。如果没有这个参数，make运行命令时能运行多少就运行多少。如果有一个以上的“-j”参数，那么仅最后一个“-j”才是有效的。（注意这个参数在MS-DOS中是无用的）
   -k, --keep-going
   出错也不停止运行。如果生成一个目标失败了，那么依赖于其上的目标就不会被执行了。
   -l <load>, --load-average[=<load>], -max-load[=<load>]
   指定make运行命令的负载。
   -n, --just-print, --dry-run, --recon
   仅输出执行过程中的命令序列，但并不执行。
   -o <file>, --old-file=<file>, --assume-old=<file>
   不重新生成的指定的<file>，即使这个目标的依赖文件新于它。
   -p, --print-data-base
   输出makefile中的所有数据，包括所有的规则和变量。这个参数会让一个简单的makefile都会输出 一堆信息。如果你只是想输出信息而不想执行makefile，你可以使用“make -qp”命令。如果你想查 看执行makefile前的预设变量和规则，你可以使用 “make –p –f /dev/null”。这个参数输出的 信息会包含着你的makefile文件的文件名和行号，所以，用这个参数来调试你的 makefile会是很有 用的，特别是当你的环境变量很复杂的时候。
   -q, --question
   不运行命令，也不输出。仅仅是检查所指定的目标是否需要更新。如果是0则说明要更新，如果是2则说 明有错误发生。
   -r, --no-builtin-rules
   禁止make使用任何隐含规则。
   -R, --no-builtin-variabes
   禁止make使用任何作用于变量上的隐含规则。
   -s, --silent, --quiet
   在命令运行时不输出命令的输出。
   -S, --no-keep-going, --stop
   取消“-k”选项的作用。因为有些时候，make的选项是从环境变量“MAKEFLAGS”中继承下来的。所以你 可以在命令行中使用这个参数来让环境变量中的“-k”选项失效。
   -t, --touch
   相当于UNIX的touch命令，只是把目标的修改日期变成最新的，也就是阻止生成目标的命令运行。
   -v, --version
   输出make程序的版本、版权等关于make的信息。
   -w, --print-directory
   输出运行makefile之前和之后的信息。这个参数对于跟踪嵌套式调用make时很有用。
   --no-print-directory
   禁止“-w”选项。
   -W <file>, --what-if=<file>, --new-file=<file>, --assume-file=<file>
   假定目标<file>;需要更新，如果和“-n”选项使用，那么这个参数会输出该目标更新时的运行动作。 如果没有“-n”那么就像运行UNIX的“touch”命令一样，使得<file>;的修改时间为当前时间。
   --warn-undefined-variables
   只要make发现有未定义的变量，那么就输出警告信息。
   
八、隐含规则：
1. 常用的隐含规则：
   编译C程序的隐含规则。
      <n>.o 的目标的依赖目标会自动推导为 <n>.c ，并且其生成命令是 $(CC) –c $(CPPFLAGS) $(CFLAGS)
   编译C++程序的隐含规则。
      <n>.o 的目标的依赖目标会自动推导为 <n>.cc 或是 <n>.C ，并且其生成命令是 $(CXX) –c $(CPPFLAGS) $(CFLAGS) 。（建议使用 .cc 作为C++源文件的后缀，而不是 .C ）
   汇编和汇编预处理的隐含规则。
      <n>.o 的目标的依赖目标会自动推导为 <n>.s ，默认使用编译品 as ，并且其生成 命令是： $ (AS) $(ASFLAGS) 。 <n>.s 的目标的依赖目标会自动推导为 <n>.S ， 默认使用C预编译器 cpp ，并且其生成命令是： $(AS) $(ASFLAGS) 。
   链接Object文件的隐含规则。
      <n> 目标依赖于 <n>.o ，通过运行C的编译器来运行链接程序生成（一般是 ld ）， 其生成命令是： $(CC) $(LDFLAGS) <n>.o $(LOADLIBES) $(LDLIBS) 。这个规则对于 只有一个源文件的工程有效，同时也对多个Object文件（由不同的源文件生成）的也有效。
2. 隐含规则使用的有关命令的变量：
   AR : 函数库打包程序。默认命令是 ar
   AS : 汇编语言编译程序。默认命令是 as
   CC : C语言编译程序。默认命令是 cc
   CXX : C++语言编译程序。默认命令是 g++
   CO : 从 RCS文件中扩展文件程序。默认命令是 co
   CPP : C程序的预处理器（输出是标准输出设备）。默认命令是 $(CC) –E
   FC : Fortran 和 Ratfor 的编译器和预处理程序。默认命令是 f77
   GET : 从SCCS文件中扩展文件的程序。默认命令是 get
   LEX : Lex方法分析器程序（针对于C或Ratfor）。默认命令是 lex
   PC : Pascal语言编译程序。默认命令是 pc
   YACC : Yacc文法分析器（针对于C程序）。默认命令是 yacc
   YACCR : Yacc文法分析器（针对于Ratfor程序）。默认命令是 yacc –r
   MAKEINFO : 转换Texinfo源文件（.texi）到Info文件程序。默认命令是 makeinfo
   TEX : 从TeX源文件创建TeX DVI文件的程序。默认命令是 tex
   TEXI2DVI : 从Texinfo源文件创建军TeX DVI 文件的程序。默认命令是 texi2dvi
   WEAVE : 转换Web到TeX的程序。默认命令是 weave
   CWEAVE : 转换C Web 到 TeX的程序。默认命令是 cweave
   TANGLE : 转换Web到Pascal语言的程序。默认命令是 tangle
   CTANGLE : 转换C Web 到 C。默认命令是 ctangle
   RM : 删除文件命令。默认命令是 rm –f
3. 关于命令参数的变量：
   ARFLAGS : 函数库打包程序AR命令的参数。默认值是 rv
   ASFLAGS : 汇编语言编译器参数。（当明显地调用 .s 或 .S 文件时）
   CFLAGS : C语言编译器参数。
   CXXFLAGS : C++语言编译器参数。
   COFLAGS : RCS命令参数。
   CPPFLAGS : C预处理器参数。（ C 和 Fortran 编译器也会用到）。
   FFLAGS : Fortran语言编译器参数。
   GFLAGS : SCCS “get”程序参数。
   LDFLAGS : 链接器参数。（如： ld ）
   LFLAGS : Lex文法分析器参数。
   PFLAGS : Pascal语言编译器参数。
   RFLAGS : Ratfor 程序的Fortran 编译器参数。
   YFLAGS : Yacc文法分析器参数。
4. 隐含规则链与模式规则：
5. 自动化变量：
   $@ : 表示规则中的目标文件集。在模式规则中，如果有多个目标，那么， $@ 就是匹配于 目标中模式定义的集合。
   $% : 仅当目标是函数库文件中，表示规则中的目标成员名。例如，如果一个目标是 foo.a(bar.o) ， 那么， $% 就是 bar.o ， $@ 就是 foo.a 。如果目标不是函数库文件 （Unix下是 .a ，Windows下是 .lib ），那么，其值为空。
   $< : 依赖目标中的第一个目标名字。如果依赖目标是以模式（即 % ）定义的，那么 $< 将是符合模式的一系列的文件集。注意，其是一个一个取出来的。
   $? : 所有比目标新的依赖目标的集合。以空格分隔。
   $^ : 所有的依赖目标的集合。以空格分隔。如果在依赖目标中有多个重复的，那个这个变量会去除 重复的依赖目标，只保留一份。
   $+ : 这个变量很像 $^ ，也是所有依赖目标的集合。只是它不去除重复的依赖目标。
   $* : 这个变量表示目标模式中 % 及其之前的部分。如果目标是 dir/a.foo.b ，并且 目标的模式是 a.%.b ，那么， $* 的值就是 dir/a.foo 。这个变量对于构造有关联的 文件名是比较有较。如果目标中没有模式的定义，那么 $* 也就
        不能被推导出，但是，如果目标文件的 后缀是make所识别的，那么 $* 就是除了后缀的那一部分。例如：如果目标是 foo.c ，因为 .c 是make所能识别的后缀名，所以， $* 的值就是 foo 。这个特性是GNU make的， 很有可能不兼
        容于其它版本的make，所以，你应该尽量避免使用 $* ，除非是在隐含规则或是静态 模式中。如果目标中的后缀是make所不能识别的，那么 $* 就是空值。
   这七个自动化变量还可以取得文件的目录名或是在当前 目录下的符合模式的文件名，只需要搭配上 D 或 F 字样
   $(@D)：表示 $@ 的目录部分（不以斜杠作为结尾），如果 $@ 值是 dir/foo.o ，那么 $(@D) 就是 dir ，而如果 $@ 中没有包含斜杠的话，其值就是 . （当前目录）。
   $(@F)：表示 $@ 的文件部分，如果 $@ 值是 dir/foo.o ，那么 $(@F) 就是 foo.o ， $(@F) 相当于函数 $(notdir $@) 。
   $(*D), $(*F）：和上面所述的同理，也是取文件的目录部分和文件部分。对于上面的那个例子， $(*D) 返回 dir ， 而 $(*F) 返回 foo
   $(%D), $(%F)：分别表示了函数包文件成员的目录部分和文件部分。这对于形同 archive(member) 形式的目标中的 member 中包含了不同的目录很有用。
   $(<D), $(<F)：分别表示依赖文件的目录部分和文件部分。
   $(^D), $(^F)：分别表示所有依赖文件的目录部分和文件部分。（无相同的）
   $(+D), $(+F)：分别表示所有依赖文件的目录部分和文件部分。（可以有相同的）
   $(?D), $(?F)：分别表示被更新的依赖文件的目录部分和文件部分。
6. 隐含规则搜索算法：搜索目标T的算法（T是假设的）
   1.把T的目录部分分离出来。叫D，而剩余部分叫N。（如：如果T是 src/foo.o ，那么，D就是 src/ ，N就是 foo.o ）
   2.创建所有匹配于T或是N的模式规则列表。
   3.如果在模式规则列表中有匹配所有文件的模式，如 % ，那么从列表中移除其它的模式。
   4.移除列表中没有命令的规则。
   5.对于第一个在列表中的模式规则：
      推导其“茎”S，S应该是T或是N匹配于模式中 % 非空的部分。
      计算依赖文件。把依赖文件中的 % 都替换成“茎”S。如果目标模式中没有包含斜框字符， 而把D加在第一个依赖文件的开头。
      测试是否所有的依赖文件都存在或是理当存在。（如果有一个文件被定义成另外一个规则的目标文件， 或者是一个显式规则的依赖文件，那么这个文件就叫“理当存在”）
      如果所有的依赖文件存在或是理当存在，或是就没有依赖文件。那么这条规则将被采用，退出该算法。
   6.如果经过第5步，没有模式规则被找到，那么就做更进一步的搜索。对于存在于列表中的第一个模式规则：
      如果规则是终止规则，那就忽略它，继续下一条模式规则。
      计算依赖文件。（同第5步）
      测试所有的依赖文件是否存在或是理当存在。
      对于不存在的依赖文件，递归调用这个算法查找他是否可以被隐含规则找到。
      如果所有的依赖文件存在或是理当存在，或是就根本没有依赖文件。那么这条规则被采用，退出该算法。
      如果没有隐含规则可以使用，查看 .DEFAULT 规则，如果有，采用，把 .DEFAULT 的命令给T使用。






example：
CC = gcc

#source files
CXXSRCS += ${wildcard src/[^t]*.cpp}
TESTSRCS += ${wildcard src/t*.cpp}

#object files
CXXOBJS = ${CXXSRCS:.cpp=.o}
TESTOBJS = ${TESTSRCS:.cpp=.o}
CXXDEPENDS = ${CXXSRCS:.cpp=.d}
TESTDEPENDS = ${TESTSRCS:.cpp=.d}

OBJS = ${CXXOBJS}
DEPENDS = ${CXXDEPENDS}

CPP_Project_DIR = ./
LIB_DIR = ${CPP_Project_DIR}/third_party/
CUDA_DIR = /usr/local/cuda-8.0/

#include
INCLUDES = -I ${CUDA_DIR}/include -I ${CPP_Project_DIR} -I${LIB_DIR}/eigen3 -I ${LIB_DIR}. -I ${LIB_DIR}/include -I . -I ./src -I ${CPP_Project_DIR}/include -I ${LIB_DIR}/opencv-lib/include -I ./include/bazel-genfiles -I ./include/nsync
STATIC_LIB = ${LIB_DIR}/boost-lib/libboost_filesystem.a ${LIB_DIR}/boost-lib/libboost_thread.a #${LIB_DIR}/boost-lib/libboost_system.a
DYNAMIC_LIB = -lrt -lpthread -ldl -lm -L ${CUDA_DIR}/lib64 -lcudart -lcublas

# C++ optimization flags
COPT = -O3 -funroll-loops -fomit-frame-pointer -fno-tree-pre -falign-loops -ffast-math -ftree-vectorize -fpermissive
CXXOPT = $(COPT)

# C++ compilation flags
CXXFLAGS = $(CXXOPT) -Wall -Wextra -WnO-write-strings -Wno-deprecated -ansi

# link flags
LDFLAGS = -shared -Wl,--whole-archive ${LIB_DIR}/google/libprotobuf.a -L ${LIB_DIR}/opencv-lib/lib -lopencv_video -lopencv_imgproc -lopencv_highgui -lopencv_core -lopencv_flann -lopencv_features2d -lopencv_calib3d -lopencv_imgcodecs -L ${LIB_DIR}/tensorflow/lib -ltensorflow_cc -ltensorflow_framework -Wl,--no-whole-archive 

TARGET = libTfMaskRcnn.so
TEST= Test

all: ${TARGET} ${TEST}
%.o: %.cpp
        ${CXX} -std=c++11 -c -fPIC -DUSE_GPU -DVL_THREADS_POSIX -DVL_DISABLE_AVX -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS -DUSE_MKL $(COPT) $(INCLUDES) $< -o $@
%.d: %.cpp
        ${CXX} -DUSE_MKL -DUSE_GPU -DVL_THREADS_POSIX -DVL_DISABLE_AVX -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS -M $(INCLUDES) $< > $@
%.o: %.c
        ${CC} -c -fPIC -DUSE_GPU -DVL_THREADS_POSIX -DVL_DISABLE_AVX -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS -DUSE_MKL $(COPT) $(INCLUDES) $< -o $@
%.d: %.c
        ${CC} -DUSE_GPU -DVL_THREADS_POSIX -DVL_DISABLE_AVX -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS -DUSE_MKL -M $(INCLUDES) $< > $@

${TARGET}: ${OBJS}
        ${CXX} ${LDFLAGS} ${OBJS} -Wl,-Bsymbolic -g -o $@ ${STATIC_LIB} ${DYNAMIC_LIB} -L./third_party/boost-lib -lboost_filesystem

${TEST}: ${TESTOBJS}
        ${CXX} -I ./src/ ${TESTOBJS} -Wl,-Bsymbolic -g -o $@ -L/home/xueyong.wxy/work/mask-rcnn ${TARGET} ${STATIC_LIB} ${DYNAMIC_LIB} -L ${LIB_DIR}/tensorflow/lib -ltensorflow_cc -ltensorflow_framework -L ${LIB_DIR}/opencv-lib/lib -lopencv_video -lopencv_imgproc -lopencv_highgui -lopencv_core -lopencv_flann -lopencv_features2d -lopencv_calib3d -lopencv_imgcodecs

clean:
        rm -rf ${DEPENDS} ${TESTOBJS} ${OBJS} ${TARGET} ${TEST}
