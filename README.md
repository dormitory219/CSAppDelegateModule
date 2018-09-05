# CSAppDelegateModule
一个对臃肿业务的AppDelegate模块的瘦身方案

本方案从工程中抽离出来，目的是优化一个有着非常臃肿业务的AppDelegate。

笔者做这个瘦身优化，是基于一个有着4000行代码的AppDelegate。从代码量就可见这块业务有多臃肿，也暴露出巨大的代码质量问题，在业务开发中，AppDelegate业务有以下问题：

1. 代码量巨大，难以理清逻辑；
2. 业务杂糅在一起，划分不明确；
3. 业务之间相互耦合严重，牵一发动全身

因为笔者所在工程已经经历了近6年，由于人员更迭，由于文档的缺失，一些逻辑快到无人能理清的阶段，而且由于业务的不断叠加，代码质量变坏的趋势越渐明显，针对这个，笔者对这块进行了比较大的重构工作。

### 1. 重构的步骤如下：

1. category横切业务线;
   
   业务非常庞大的情况下，通过cateogry可以清晰的将杂糅的业务进行分层，而且业务上更结构清晰。这种做法最大的好处是可以将老代码逻辑经过变更后的逻辑缺失风险降到最低，相信这是每个重构优化工作者都怕遇到的问题，在合并一些逻辑时不知觉的就去掉了一些隐藏逻辑。
   
2. 建立CSAppDelegateService业务线;
   第一步已经将业务通过category切出来了不同的层次，就比如：
   
   appDelegate+A,
   
   appDelegate+B,
   
   appDelegate+C,
   
   appDelegate+D
   ......
   
   这一步就是将对应的category转化为相应的service，service是每个独立业务的承载体，之后新增的业务都会以service形式存在。
   
   CSAppDelegateAService
   
   CSAppDelegateBService
   
   CSAppDelegateCService
   
3. CSAppDelegateServiceManager接管appDelegate业务，管理各类service调用;
   
   将appDelegate内所有系统事件，全部转接出去，交给一个单独的类CSAppDelegateServiceManager去handler,这样的话，appDelegate将会变得很纯粹，重活累活都交给CSAppDelegateServiceManager了
   
4. CSAppDelegateServiceManager内注册service，分发action到相应的service处理；
   CSAppDelegateServiceManager接管appDelegate所有事件后，由他来分发到对应的service来处理，因为同一个事件，比如
   - (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
   
   该事件会分发到多个service中进行处理，每个service之间的顺序如何，会在这里做优先级处理。

4. CSMediator (Service,Router)作为内部service之间调用，外部业务对appDelegate相关业务调用的解耦
   
   上面的appDelegate事件到达对应的service之后，在service内部会处理相关逻辑，但是service之间可能会有依赖，serviceA可能会调用serviceB的业务，这样在多个service之间会有业务耦合，我们希望解除这种耦合，目前通过CSMediator来完成这件事。CSMediator是笔者之前针对初步组件化封装的解耦方案，目前这里是通过protocol的方式来就解除业务之间的耦合。

5. 具体单个service的优化。
   
   很多人将重构会肤浅的理解为将一块代码分离出来放在另一块，删删减减，这种我不认同。好的重构是一种代码编写思路的转变，是对一种编写方式的协同。回归正题，重构到这个阶段，则是对根深蒂固的老逻辑进行分析，分散但有共性的业务进行整合，杂糅的粗业务戏分。
   
6. 建立该模块内相应技术文档，以及编程注意事项。
   
   对代码进行相关注释，画相关类图，流程图，约定一些编程规范，对组内其他人进行技术分享。


### 2. 具体技术实现：
  待更新


